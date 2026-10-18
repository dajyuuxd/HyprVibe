#!/usr/bin/env bash
# ==============================================================================
# Chromium Data Cleaner (Hourly Task)
# Deletes all browsing history, cache, web storage, and session data
# while strictly PRESERVING user cookies and login sessions.
# ==============================================================================

set -euo pipefail

CHROME_CONFIG="$HOME/.config/chromium"
CHROME_CACHE="$HOME/.cache/chromium"
LOG_FILE="$HOME/.local/state/chromium-cleaner.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

log "Starting Chromium periodic data cleanup..."

# 1. Clean entire disk caches in ~/.cache/chromium
if [ -d "$CHROME_CACHE" ]; then
    find "$CHROME_CACHE" -mindepth 1 -delete 2>/dev/null || true
    log "Purged cache directory: $CHROME_CACHE"
fi

# 2. Clean each profile directory (Default, Profile 1, etc.)
if [ -d "$CHROME_CONFIG" ]; then
    # Also clean top-level crash reports / caches in config dir
    rm -rf "$CHROME_CONFIG"/BrowserMetrics* \
           "$CHROME_CONFIG"/component_crx_cache* \
           "$CHROME_CONFIG"/"Crash Reports"* \
           "$CHROME_CONFIG"/extensions_crx_cache* \
           "$CHROME_CONFIG"/GPUPersistentCache* \
           "$CHROME_CONFIG"/OptimizationHints* \
           "$CHROME_CONFIG"/segmentation_platform* \
           "$CHROME_CONFIG"/ZxcvbnData* 2>/dev/null || true

    for profile_dir in "$CHROME_CONFIG"/Default "$CHROME_CONFIG"/Profile*; do
        [ -d "$profile_dir" ] || continue

        # If Chromium is running, attempt SQLite purge on History first
        if [ -f "$profile_dir/History" ] && command -v sqlite3 >/dev/null 2>&1; then
            sqlite3 "$profile_dir/History" \
                "DELETE FROM urls; DELETE FROM visits; DELETE FROM visit_source; DELETE FROM downloads; DELETE FROM downloads_slices; DELETE FROM downloads_url_chains; DELETE FROM keyword_search_terms; DELETE FROM segment_usage; DELETE FROM segments; VACUUM;" 2>/dev/null || true
        fi

        # Remove browsing history & site metadata files
        rm -f "$profile_dir"/History* \
              "$profile_dir"/Favicons* \
              "$profile_dir"/"Top Sites"* \
              "$profile_dir"/Shortcuts* \
              "$profile_dir"/"Network Action Predictor"* \
              "$profile_dir"/"Visited Links"* \
              "$profile_dir"/DIPS* \
              "$profile_dir"/"Account Web Data"* \
              "$profile_dir"/"Affiliation Database"* \
              "$profile_dir"/CdmStorage.db* \
              "$profile_dir"/declarative_performance_observer.db* \
              "$profile_dir"/heavy_ad_intervention_opt_out.db* \
              "$profile_dir"/"Reporting and NEL"* \
              "$profile_dir"/"Web Data"* \
              "$profile_dir"/TransportSecurity* \
              "$profile_dir"/LOG* 2>/dev/null || true

        # Remove web storage & cache folders (leaving Cookies, Preferences, Login Data, Extensions intact)
        rm -rf "$profile_dir"/Sessions* \
               "$profile_dir"/"Session Storage"* \
               "$profile_dir"/blob_storage* \
               "$profile_dir"/GPUCache* \
               "$profile_dir"/DawnGraphiteCache* \
               "$profile_dir"/DawnWebGPUCache* \
               "$profile_dir"/"Service Worker"* \
               "$profile_dir"/WebStorage* \
               "$profile_dir"/IndexedDB* \
               "$profile_dir"/BudgetDatabase* \
               "$profile_dir"/"File System"* \
               "$profile_dir"/"Download Service"* \
               "$profile_dir"/optimization_guide_hint_cache_store* \
               "$profile_dir"/AutofillAiModelCache* \
               "$profile_dir"/AutofillStrikeDatabase* \
               "$profile_dir"/chrome_cart_db* \
               "$profile_dir"/commerce_subscription_db* \
               "$profile_dir"/discount_infos_db* \
               "$profile_dir"/discounts_db* \
               "$profile_dir"/parcel_tracking_db* \
               "$profile_dir"/shared_proto_db* \
               "$profile_dir"/"Platform Notifications"* \
               "$profile_dir"/"Segmentation Platform"* \
               "$profile_dir"/"Shared Dictionary"* 2>/dev/null || true

        log "Cleaned profile: $(basename "$profile_dir") (preserved Cookies and Preferences)"
    done
fi

log "Chromium cleanup completed successfully."
