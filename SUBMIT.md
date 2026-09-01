# App Store Connect checklist

Human checklist for a later App Store Connect listing. **Do not archive, sign, or submit.** There is no Apple Developer team yet.

## Identity

| Field | Value |
| --- | --- |
| Suggested bundle ID | **SUGGESTED** `com.eliranrp.tischkickerscoreboard` — no team exists; do not treat this as assigned |
| Current Xcode `PRODUCT_BUNDLE_IDENTIFIER` | `com.eliranrp.foosballscoreboard` (project default until a team sets a real ID) |
| Suggested SKU | `tischkicker-zahler` |
| Version | 1.0 (build 1) |
| Devices | iPhone only (`TARGETED_DEVICE_FAMILY = 1`) |

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
- Privacy policy URL (once GitHub Pages is on): `https://eliranrp.github.io/tischkicker-scoreboard/privacy.html`
- App Privacy answers: all “no” / data not collected.

## Support / contact

Until an App Store listing support email exists, contact is **GitHub issues**:

https://github.com/eliranRP/tischkicker-scoreboard/issues

Do **not** invent an email address. When a listing exists, use the support email on that App Store product page.

Support page (once Pages is on): `https://eliranrp.github.io/tischkicker-scoreboard/`

## App Review notes

Paste into App Review Information when a team exists:

> No account. No login. Works fully offline. No demo account needed. iPhone only. Table-football (foosball / Tischkicker) scoresheet for a phone on the rail — not a soccer live-score, not a video game. Tap a side to add a goal, undo, new match. Delete the app to wipe local match data; there is no cloud copy.

## What this repo will not do

- Do not archive.
- Do not code-sign for distribution.
- Do not upload to App Store Connect.
- Do not submit for review.
