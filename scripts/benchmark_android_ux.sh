#!/usr/bin/env bash
# Physical-device baseline for low-end Spotify WebView rendering.
# Usage: ./scripts/benchmark_android_ux.sh [package] [output_dir]
set -euo pipefail
PKG="${1:-com.project.lol}"
OUT="${2:-benchmarks/ux-$(date +%Y%m%d-%H%M%S)}"
command -v adb >/dev/null || { echo "adb is required" >&2; exit 1; }
adb get-state >/dev/null || { echo "Connect an Android device" >&2; exit 1; }
mkdir -p "$OUT"
echo "package=$PKG" > "$OUT/info.txt"
adb shell getprop ro.build.version.release | tr -d '\r' >> "$OUT/info.txt"
adb shell getprop ro.product.model | tr -d '\r' >> "$OUT/info.txt"

echo "Cold launch (includes Spotify network time)"
adb shell am force-stop "$PKG"
adb shell dumpsys gfxinfo "$PKG" reset >/dev/null 2>&1 || true
adb shell am start -W -n "$PKG/com.project.lol.ui.SplashActivity" | tee "$OUT/cold-start.txt"
echo "Use the app normally for ~30 seconds: scroll Home, Search, Library and the player."
sleep 30
adb shell dumpsys gfxinfo "$PKG" framestats > "$OUT/foreground-framestats.txt"
adb shell dumpsys meminfo "$PKG" > "$OUT/foreground-meminfo.txt"
adb shell top -b -n 1 > "$OUT/foreground-top.txt"

echo "Warm launch"
adb shell input keyevent 3
adb shell am start -W -n "$PKG/com.project.lol.ui.SplashActivity" | tee "$OUT/warm-start.txt"
echo "Start music manually, then lock the screen. Capturing system usage after 30 seconds."
sleep 30
adb shell input keyevent 26
sleep 30
adb shell dumpsys meminfo "$PKG" > "$OUT/screen-off-meminfo.txt"
adb shell top -b -n 1 > "$OUT/screen-off-top.txt"
adb shell dumpsys media_session > "$OUT/media-session.txt"
adb shell input keyevent 26 || true
echo "Saved raw baselines in $OUT"
