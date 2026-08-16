# Android APK Signing Setup

Your APKs will now be signed with the same key every time, so updates install
over the old version without uninstalling first.

## Files in this folder

| File | Purpose |
|------|---------|
| `release.keystore` | The signing key (keep private!) |
| `KEY-PASSWORDS.txt` | Passwords + alias (keep private!) |
| `keystore-base64.txt` | Base64 of keystore, paste into GitHub secret |
| `encode-keystore.ps1` | Regenerates keystore-base64.txt if you need it again |
| `reusable-sign-apk.yml` | **Reusable workflow** - signs any app automatically. Do this once. |
| `app-caller-workflow.yml` | The only file each new app needs (copy + edit) |
| `workflow-build-signed-apk.yml` | Alternative: standalone workflow (copy per app) |
| `gradle-signing-template.gradle` | Only needed for the standalone option |

## Recommended: reusable workflow (set up once, reuse forever)

### 1. Add GitHub secrets (Settings -> Secrets and variables -> Actions)
Create these four secrets **in your keys repo** (or at org level so all repos
inherit them):

- `ANDROID_SIGNING_KEY` = the full contents of `keystore-base64.txt`
- `ANDROID_KEYSTORE_PASSWORD` = password in `KEY-PASSWORDS.txt`
- `ANDROID_KEY_ALIAS` = `androidreleasekey`
- `ANDROID_KEY_PASSWORD` = password in `KEY-PASSWORDS.txt`

### 2. Publish the reusable workflow
Copy `reusable-sign-apk.yml` to `.github/workflows/reusable-sign-apk.yml` in a
repo named `keys`. Make that repo **public** - it contains no secrets (the
keystore only ever lives inside GitHub Actions secrets), and GitHub requires
the hosting repo to be public for other repos to call it.

### 3. For EVERY new app, add this one file
Copy `app-caller-workflow.yml` to `.github/workflows/build-signed-apk.yml` in
the app repo, and replace `YOUR_USERNAME` with your GitHub username. The app
repo also needs the same 4 secrets (or inherit them from org-level secrets).

That's it - no build.gradle edits needed. The reusable workflow signs the APK
with the same key every time, so updates upgrade in place.

## Alternative: standalone workflow (one file per app)
Copy `workflow-build-signed-apk.yml` into `.github/workflows/` of each app repo
and add the `signingConfigs` block from `gradle-signing-template.gradle` to
`app/build.gradle`.

## Build
Push a tag like `v1.0` (or trigger the workflow manually). The release APK in
the "signed-apk" artifact is signed. Install it and future updates will
upgrade in place.

## Very important
- `release.keystore` is a PKCS12 keystore, valid 10,000 days.
- Android **requires the same key** to update an app. Losing the keystore or
  passwords means you can never update your published apps again.
- Back these files up somewhere safe (not a public repo).
- For Play Store publishing, the release key used here is the one that must
  be uploaded to Google Play Console as your app signing key.