#!/bin/bash
# In-memory Command History Manager
# Stored strictly in RAM (/dev/shm). Maximum 15 entries.
# Purges junk commands (clear, exit, ls, cd, typos, empty lines) when reaching limit.

MEM_FILE="/dev/shm/cmd_history_${USER}.txt"
touch "$MEM_FILE" 2>/dev/null

is_junk() {
    local cmd="$1"
    # Trim leading and trailing whitespace
    cmd="$(echo "$cmd" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    
    # Empty or single-character commands
    [ -z "$cmd" ] && return 0
    [ ${#cmd} -le 1 ] && return 0
    
    # Common trivial junk commands
    case "$cmd" in
        clear|exit|pwd|history|cls|q|c|fg|bg) return 0 ;;
        ls|ll|la|"ls -la"|"ls -l"|"ls -a"|"ls -lh") return 0 ;;
        cd|"cd .."|"cd -"|"cd ~") return 0 ;;
        cd\ *) return 0 ;;
    esac
    return 1
}

clean_history() {
    [ ! -f "$MEM_FILE" ] && return
    local temp_file="/dev/shm/.cmd_hist_tmp.$$"
    grep -v '^[[:space:]]*$' "$MEM_FILE" 2>/dev/null > "$temp_file"
    local total
    total=$(wc -l < "$temp_file" 2>/dev/null || echo 0)
    
    # If exceeding 15 entries, purge junk commands
    if [ "$total" -gt 15 ]; then
        local filtered="/dev/shm/.cmd_hist_fil.$$"
        > "$filtered"
        while IFS= read -r line; do
            if ! is_junk "$line"; then
                echo "$line" >> "$filtered"
            fi
        done < "$temp_file"
        
        # Deduplicate while preserving order and keep newest 15
        awk '!seen[$0]++' "$filtered" | tail -n 15 > "$MEM_FILE"
        rm -f "$filtered" "$temp_file"
    else
        mv "$temp_file" "$MEM_FILE"
    fi
}

case "$1" in
    add)
        shift
        cmd="$*"
        [ -z "$cmd" ] && exit 0
        last_line=$(tail -n 1 "$MEM_FILE" 2>/dev/null)
        if [ "$cmd" != "$last_line" ]; then
            echo "$cmd" >> "$MEM_FILE"
            clean_history
        fi
        ;;
    waybar)
        clean_history
        python3 -c '
import json, os
mem_file = "'"$MEM_FILE"'"
cmds = []
if os.path.exists(mem_file):
    with open(mem_file, "r", errors="ignore") as f:
        cmds = [line.strip() for line in f if line.strip()]

count = len(cmds)
tooltip = "In-Memory Command History (Max 15):\n"
if cmds:
    tooltip += "\n".join(f"{i+1}. {c}" for i, c in enumerate(reversed(cmds)))
else:
    tooltip += "(No saved commands)"

data = {
    "text": f"󰋚 {count}",
    "tooltip": tooltip,
    "class": "history"
}
print(json.dumps(data, ensure_ascii=False))
'
        ;;
    menu)
        selected=$(tac "$MEM_FILE" 2>/dev/null | wofi --dmenu --prompt "History (Max 15)...")
        if [ -n "$selected" ]; then
            kitty -e bash -c "$selected; exec bash" &
        fi
        ;;
    list)
        cat "$MEM_FILE"
        ;;
    clear)
        > "$MEM_FILE"
        ;;
esac
