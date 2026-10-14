# Foreground media playback smoke test

Target: Android 9–16, with particular focus on Android 12+ background-start restrictions
and Android 13+ system media controls.

## Online/WebView playback

1. Cold-launch Spotilol while **not** playing. Confirm that it does not display a
   perpetual *playing* notification merely because the WebView loaded.
2. Play a track. Confirm that Android displays a system media player with
   **correct track, artist, cover, elapsed time, and play/pause/previous/next**.
3. Lock the screen, switch apps, and turn off the display for several minutes.
   The track should continue without interruption. Use Bluetooth/headset
   play/pause/next and the lock-screen media controls.
4. While playing, swipe the app away from Recents with the default settings.
   Playback and the foreground service should remain active. Users who have
   explicitly enabled `SwipeStop` should still get their chosen stop behavior.
5. Pause from the notification. The notification should report **paused**, not
   playing. It should stop using foreground-service priority after ~10 minutes
   of continuous pause; Android may still show a resumable media card.
6. Resume from the system media player after the 10-minute grace period. Verify
   that playback returns to foreground mode.
7. Rapidly skip tracks with distinct cover art. The notification must never
   revert to the artwork of an earlier track because of a late image download.
8. If available, test Android Auto browsing/playback and PiP controls.

## Offline playback regression

Play a downloaded track, then pause/resume/skip via notification and wired or
Bluetooth controls. Verify that the independent `OfflineMediaService` remains
functional. Offline playback's player lifecycle is not migrated in this change.

## ADB inspection

```sh
adb shell dumpsys media_session | grep -A 25 -B 5 'SpotilolSession'
adb shell dumpsys activity services com.project.lol | grep -E 'MediaNotificationService|foreground|fg'
adb logcat -d -s MediaNotifService:* AndroidRuntime:E
```

For the online session, expected state is `PLAYING` during playback and
`PAUSED` during pause, with a valid session token and a media-playback
foreground service only during playback or the pause grace period.

**Limitations:** A force-stop in Android Settings always terminates playback.
Some device OEM battery-saving policies may interrupt WebView-based streams;
a foreground service cannot override force-stop or every OEM restriction.
