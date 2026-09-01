# App Store Connect checklist

Human listing fields for App Store Connect. **How to enroll and run the unattended pipeline is in [DEPLOY.md](DEPLOY.md).**

This repository does **not** contain an Apple team ID, API key, or password. Do not add them.

## Identity

| Field | Value |
| --- | --- |
| Suggested bundle ID | **SUGGESTED** `com.eliranrp.tischkickerscoreboard` — no team exists; do not treat this as assigned |
| Current Xcode `PRODUCT_BUNDLE_IDENTIFIER` | `com.eliranrp.foosballscoreboard` (Fastlane uses this; do not silently rename) |
| Suggested SKU | `tischkicker-zahler` |
| Version | 1.0 (build 1) |
| Devices | iPhone only (`TARGETED_DEVICE_FAMILY = 1`) |

The suggested bundle ID and the Xcode bundle ID **differ**. Keep the Xcode value until there is a committed reason to change it.

## Categories

- Primary: **Sports**
- Secondary: **Utilities** (phone-on-the-rail scoresheet, not a soccer game)

## Export compliance

**NO.** The app does not use encryption other than what iOS provides. v1 has no network.

`ITSAppUsesNonExemptEncryption` is already `false` in `Info.plist`.

## Age / content rights

- Age rating: **4+**
- Original scoresheet UI and copy; bundled Anton / Oswald fonts are SIL Open Font License (see `FoosballScoreboard/FoosballScoreboard/Fonts/`).

## Privacy

- Data collected: **none** (no account, no analytics, no ads, no crash reporter, no tracker).
- Privacy policy URL: https://eliranrp.github.io/tischkicker-scoreboard/privacy.html
- App Privacy answers: all “no” / data not collected.

## Support / contact

Until an App Store listing support email exists, contact is **GitHub issues**:

https://github.com/eliranRP/tischkicker-scoreboard/issues

Do **not** invent an email address. When a listing exists, use the support email on that App Store product page.

Support page: https://eliranrp.github.io/tischkicker-scoreboard/

## App Review notes

Paste into App Review Information when a team exists (also in `fastlane/metadata/review_information/notes.txt`):

> No account. No login. Works fully offline. No demo account needed. iPhone only. Table-football (foosball / Tischkicker) scoresheet for a phone on the rail — not a soccer live-score, not a video game. Tap a side to add a goal, undo, new match. Delete the app to wipe local match data; there is no cloud copy.

## Human vs unattended

See **[DEPLOY.md](DEPLOY.md)**. Short version:

- **Human, one-time:** Apple Developer enrollment; Paid Apps / tax / banking in App Store Connect; create the API key (Issuer ID, Key ID, `.p8`); create the app record if the API cannot; age rating; real screenshots; copyright line.
- **Unattended after that:** `bundle exec fastlane beta` or `bundle exec fastlane release` on a Mac with Xcode, or Actions → Release → `workflow_dispatch` (`testflight` or `appstore`).
- **Never automatic:** push to `main` does not submit. Apple Review is still Apple.
- **This PR / this repo does not upload.** Lanes fail loudly without `APPLE_TEAM_ID` and the API key env vars.
