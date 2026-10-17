#!/usr/bin/env bash
# ==============================================================================
# GPU/VGA Performance Monitor for Waybar
# Supports Intel HD/Iris Graphics, AMD Radeon, and NVIDIA GPUs
# ==============================================================================

busy=0
freq=""
vga_name="VGA"

# 1. Check NVIDIA GPU
if command -v nvidia-smi >/dev/null 2>&1; then
    nv_out=$(nvidia-smi --query-gpu=utilization.gpu,name,clocks.gr --format=csv,noheader,nounits 2>/dev/null | head -n 1)
    if [ -n "$nv_out" ]; then
        busy=$(echo "$nv_out" | awk -F',' '{print $1}' | tr -d ' ')
        vga_name=$(echo "$nv_out" | awk -F',' '{print $2}' | sed 's/^[ ]*//')
        freq=$(echo "$nv_out" | awk -F',' '{print $3}' | tr -d ' ')
    fi

# 2. Check AMD GPU sysfs
elif [ -f "/sys/class/drm/card0/device/gpu_busy_percent" ] || [ -f "/sys/class/drm/card1/device/gpu_busy_percent" ]; then
    amd_path=$(ls /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -n 1)
    busy=$(cat "$amd_path" 2>/dev/null || echo 0)
    vga_name="AMD Radeon"

# 3. Check Intel Graphics (Skylake/Gen9+ RC6 Residency + RPS frequency)
else
    rc6_path=$(ls /sys/class/drm/card*/power/rc6_residency_ms /sys/class/drm/card*/gt/gt0/rc6_residency_ms 2>/dev/null | head -n 1)
    freq_path=$(ls /sys/class/drm/card*/gt_act_freq_mhz /sys/class/drm/card*/gt/gt0/rps_act_freq_mhz 2>/dev/null | head -n 1)
    
    if [ -f "$rc6_path" ]; then
        r1=$(cat "$rc6_path")
        t1=$(date +%s%N)
        sleep 0.12
        r2=$(cat "$rc6_path")
        t2=$(date +%s%N)
        
        dt=$(( (t2 - t1) / 1000000 ))
        dr=$(( r2 - r1 ))
        
        if [ "$dt" -gt 0 ]; then
            idle=$(( dr * 100 / dt ))
            [ "$idle" -gt 100 ] && idle=100
            busy=$(( 100 - idle ))
            [ "$busy" -lt 0 ] && busy=0
        fi
    fi
    
    if [ -f "$freq_path" ]; then
        freq=$(cat "$freq_path" 2>/dev/null)
    fi
    vga_name="Intel HD Graphics 530"
fi

# Determine CSS styling class
class="normal"
if [ "$busy" -ge 85 ]; then
    class="critical"
elif [ "$busy" -ge 60 ]; then
    class="warning"
fi

# Format tooltip
if [ -n "$freq" ]; then
    tooltip="GPU: $vga_name\nLoad: ${busy}%\nClock: ${freq} MHz\nClick to open htop"
else
    tooltip="GPU: $vga_name\nLoad: ${busy}%\nClick to open htop"
fi

echo "{\"text\":\"󰢮 ${busy}%\",\"tooltip\":\"${tooltip}\",\"class\":\"${class}\"}"

