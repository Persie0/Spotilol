# UI performance and low-end device QA

Measure on a real Android phone; debug builds, network response time, WebView version, logged-in Spotify state and device temperature affect results. Compare before/after on the same device with the same Spotify account, page, songs and connectivity.

## Performance features

- Fast startup is now the default. Users who explicitly disabled it keep their extended splash.
- The custom player reconciles DOM state every ~200 ms while visible, or ~400 ms in low-end mode; progress is smoothed by CSS.
- Canvas/video discovery runs less often than progress UI updates. Play/pause icons are only rebuilt on a state change.
- Search invalidates old results immediately, aborts stale requests, caches recent queries for 60 seconds, and batches results.
- Low-end mode is automatically enabled for Android low-RAM devices by default; it is manually adjustable in settings. It pauses decorative Canvas/video and reduces custom UI work, without changing the Spotify account's video preferences.
- Power Save no longer overrides every `setInterval` on Spotify's webpage. Other Spotilol-specific work still suspends while the app is backgrounded.

## Checklist

1. On a fresh install, launch; test login and page transition. Compare startup before/after. Check the Fast Startup preference and long-splash opt-out.
2. Play/pause, seek, shuffle, repeat, like, tracks, albums, podcasts; verify each icon and elapsed time respond.
3. Rapidly scroll a long playlist and search for different queries; confirm stale results never replace newer results.
4. Switch between home, search, library; verify the custom player initializes and survives navigation.
5. Test settings switches: Low-end mode, Power Save, Canvas, videos, player modes, swipe-stop.
6. Test 30+ minutes of screen-off playback, notifications, Bluetooth, audio focus and offline player regression.
7. Confirm Canvas/video behavior and Spotify preferences are preserved when low-end mode is disabled.
8. Rotate and use picture-in-picture; verify animations and video fullscreen controls.

## Benchmark

Run `bash scripts/benchmark_android_ux.sh` with ADB connected, then repeat with low-end mode on and off. The script saves Android launch timing, gfxinfo framestats, memory, top snapshots and media session state. The shell script does not compute subjective smoothness; inspect janky frame counts, p90/p95 frame durations, CPU usage, renderer memory and visible user experience.

For representative performance testing, use a non-debug signing build and Android Macrobenchmark in addition to this smoke test. Never equate build success with on-device UX validation.
