# Unattended TestFlight / App Store deploy

This pipeline removes local Xcode Organizer clicking. **Apple Review is still Apple.** Nothing here uploads until a human enrolls, stores secrets outside git, and runs a lane or `workflow_dispatch`.

There is **no Apple Developer membership in this repo**. Do not invent a team ID, Apple ID password, or API key. Do not commit `.p8` files.

## Identity (do not silently rename)

| Field | Value |
| --- | --- |
| Xcode bundle ID (used by Fastlane) | `com.eliranrp.foosballscoreboard` |
| Suggested bundle ID in SUBMIT.md | `com.eliranrp.tischkickerscoreboard` — **not** applied. Keep the current Xcode ID unless there is a committed reason to change it. |
| SKU (create the ASC app record with this) | `tischkicker-zahler` |
| Scheme / project | `FoosballScoreboard` / `FoosballScoreboard/FoosballScoreboard.xcodeproj` |
| Categories | Sports (primary), Utilities (secondary) |
| Export compliance | NO — `ITSAppUsesNonExemptEncryption = false` in `Info.plist` |

Listing copy in `fastlane/metadata/` is transcribed from `docs/` and `SUBMIT.md` (names from `InfoPlist.xcstrings`). Subtitle, keywords, promotional text, copyright, and screenshots are **not** invented. `fastlane release` will **skip `submit_for_review`** until those required pieces exist.

## Live URLs (HTTP 200)

- Privacy: https://eliranrp.github.io/tischkicker-scoreboard/privacy.html
- Support: https://eliranrp.github.io/tischkicker-scoreboard/

## One-time HUMAN steps (cannot be automated)

1. **Enroll in the Apple Developer Program** (paid membership) at https://developer.apple.com/programs/
2. In App Store Connect, accept the **Paid Apps**, **tax**, and **banking** agreements. TestFlight and App Store uploads fail without these.
3. Create an **App Store Connect API key** (Users and Access → Integrations → App Store Connect API):
   - Role: **App Manager** (or Admin).
   - Save **Issuer ID**, **Key ID**, and the **`.p8` private key**.
   - Store the `.p8` in a password manager and as a GitHub secret. **Never commit it.**
4. Create the **app record** in App Store Connect if the API cannot create it on first upload:
   - Bundle ID: `com.eliranrp.foosballscoreboard` (must match Xcode).
   - SKU: `tischkicker-zahler`.
   - Platforms: iPhone.
5. Complete the **age rating** questionnaire in App Store Connect (SUBMIT.md: 4+). This repo does not invent a rating JSON.
6. Capture **App Store screenshots** on a Mac (README lists preview states). Put them in `fastlane/metadata/screenshots/<locale>/` when you have real shots. Generated Fastlane snapshot output under `fastlane/screenshots/` is gitignored.
7. Add a **copyright** line to `fastlane/metadata/copyright.txt` when you know the legal owner. Do not guess.
8. Add GitHub Actions secrets (repository Settings → Secrets and variables → Actions):

   | Secret | Contents |
   | --- | --- |
   | `APPLE_TEAM_ID` | 10-character Team ID from Apple Developer / Xcode |
   | `APP_STORE_CONNECT_API_KEY_KEY_ID` | Key ID |
   | `APP_STORE_CONNECT_API_KEY_ISSUER_ID` | Issuer ID |
   | `APP_STORE_CONNECT_API_KEY_KEY` | Full `.p8` PEM text (or Base64 of that PEM). Newlines may be stored as `\n`. |

   Locally, the same names are environment variables. You may use `APP_STORE_CONNECT_API_KEY_KEY_FILEPATH` or `KEY_FILEPATH` instead of putting PEM in `APP_STORE_CONNECT_API_KEY_KEY`.

## Unattended after that

On a Mac with Xcode (this agent does not upload):

```sh
bundle install
bundle exec fastlane test      # Simulator; prefers iPhone 17
bundle exec fastlane beta      # archive + TestFlight
bundle exec fastlane release   # archive + listing; submit only if complete
```

Or GitHub Actions: **Actions → Release → Run workflow**, track `testflight` or `appstore`. That workflow is **`workflow_dispatch` only**. There is no push-to-`main` auto-submit.

Override the Simulator name with `SIMULATOR_DEVICE` if needed. The test lane does **not** require iPhone 16; if iPhone 17 is missing it uses any available iPhone.

Bump `CURRENT_PROJECT_VERSION` / `MARKETING_VERSION` in the Xcode project before a new upload. This pipeline does not invent build numbers.

## Tests: Mac vs GitHub Actions

XCTest is **23/23 green** on a local Mac (Xcode 26.6, iPhone 17). That machine is the source of truth.

`.github/workflows/ci.yml` runs `bundle exec fastlane test` on `macos-latest` for pull requests as a **best-effort** job (`continue-on-error`). Hosted Simulator images can be slow, missing a device name, or on a different Xcode. If that job flakes, re-run locally; do not treat GHA Simulator as authoritative.

## Honest limit

Fastlane and the workflow replace clicking Archive / Distribute / TestFlight in Xcode. They do **not** replace App Review, agreements, screenshots, or a real Developer team.
