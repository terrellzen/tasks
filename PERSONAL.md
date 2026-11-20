# Tasks Personal

Personal GPL-3.0 fork of https://github.com/tasks/tasks. This is an unofficial build, not a Tasks.org release. The upstream license and notices remain in this repository.

Independent CalDAV/Nextcloud/Etebase sync and local Pro features do not require a Tasks.org subscription. `LocalFeatures.enabled` is the fork's permanent local-feature policy, separate from purchase receipts. No subscription is fabricated and no Tasks.org server access is granted. Donation/support and hosted-service screens from upstream may still appear; they do not gate independent sync.

## Downloads and installation

Open https://github.com/terrellzen/tasks/actions/workflows/personal.yml, choose a successful run and download its three artifacts. Artifacts expire (GitHub's default retention); save the extracted installers somewhere permanent.

- Android: extract the artifact ZIP and install the APK. The application ID is `org.tasks.personal`; its name is Tasks Personal. It can coexist with the official application. Export/back up existing tasks before migrating; this application has separate data. The same personal signing key must be used for every future APK update.
- Linux x86_64: extract the artifact ZIP, run `chmod +x Tasks-Personal-linux-x86_64.AppImage` and launch it. If FUSE is unavailable, run it with `--appimage-extract-and-run`. The runtime is bundled.
- Windows x86_64: extract both the artifact ZIP and the portable application ZIP. Run `tasks-personal.exe` inside the extracted folder and keep its `app` and `runtime` folders beside it. The application is not signed with a commercial Windows certificate. The runtime is bundled.

Desktop is upstream's alpha application. These packages target 64-bit Intel/AMD PCs. Android is the established Android application, not the experimental Compose Android application. Desktop retains upstream's data-directory logic; back up an existing desktop installation before trying it.

On each device select **Add account → CalDAV**, then enter your server URL, username, and app password. Use your server's task-enabled CalDAV endpoint (Nextcloud lists it under Calendar settings). Configure the same account on all devices. You do not need to sign in to Tasks.org. Server hosting can have its own costs.

## Build when you choose

On the Actions page select **Run workflow**, branch **personal**. The workflow builds all three packages and runs the independent-sync regression test on Linux. There is no schedule or push trigger in this workflow. Upstream's inherited workflows are disabled in this fork's GitHub settings. No Conveyor updater or AppImage update URL is included in these packages.

The Android key is stored in this fork's encrypted Actions secrets (`PERSONAL_KEYSTORE`, `PERSONAL_KEY_PASSWORD`). A protected local backup was created at `/home/fedora/.local/share/tasks-personal/` on the build machine. Copy that entire directory to secure backup storage. Never commit the key or password. Losing it prevents updating this Android installation with a newly signed APK.

For local builds install JDK 25, Android SDK platform 37 and build-tools 37, and set `ANDROID_HOME` (or `sdk.dir` in `local.properties`). Commands:

```sh
python3 scripts/personal/check-policy.py
./gradlew :composeApp:desktopTest --tests org.tasks.sync.IndependentSyncTest
./gradlew :composeApp:createDistributable
# Linux only:
scripts/personal/appimage.sh
```

For an Android release configure Gradle's `tasksStoreFile`, `tasksStorePassword`, `tasksKeyAlias=personal`, and `tasksKeyPassword` using environment variables or your private Gradle user properties, then run `./gradlew :app:assembleGenericRelease`. Windows desktop packaging must run on Windows; the manual workflow does this for you.

## Take upstream fixes only when you want

Your checkout uses `origin` for this fork and `upstream` for tasks/tasks. Start with a clean `personal` branch:

```sh
scripts/personal/update-upstream.sh
```

The script fetches upstream and leaves its merge uncommitted for review. If conflicts occur, resolve them while preserving the local-feature policy. Run the policy check and regression test, inspect new sync/account/billing code, then commit and push. Run the manual build again and install its new artifacts when you choose. If you do not want the merge, `git merge --abort` cancels it.

The policy checker deliberately fails if known policy hooks change. The regression test verifies a CalDAV sync pass without a Tasks.org account and with a billing provider that throws if consulted. Neither can prove arbitrary future upstream changes are safe: review new gates before accepting an update. A merge never updates an already-installed app by itself.
