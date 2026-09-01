# Foosball Scoreboard

Local table-football (Tischkicker / baby-foot / tafelvoetbal / calcio balilla / futbolín / piłkarzyki) scoreboard for a phone on the rail. Two teams, race to 5 or 10, huge taps, undo, reset. No account, iCloud, network, analytics, or ads.

Home-screen names follow the system language: **Tischkicker Zähler** (DE), **Score Baby-foot** (FR), **Tafelvoetbal Scorebord** (NL), **Foosball Scoreboard** (EN), plus Italian, Spanish, and Polish.

## Run in Xcode

1. On a Mac, clone this repo and open `FoosballScoreboard/FoosballScoreboard.xcodeproj` in Xcode 16 or later (iOS 17 SDK).
2. Select the **FoosballScoreboard** scheme.
3. Pick a simulator (iPhone 16 Pro, 6.7" is a good screenshot size) or a signed-in device.
4. Choose your Development Team under the target’s **Signing & Capabilities** tab if you are running on a device.
5. Press **Run** (⌘R).

The app follows the device language. To preview German or another locale in Simulator: **Settings → General → Language & Region**.

SwiftUI previews (Canvas) cover the screenshot states: race picker, live 0–0, live 4–3 / 3–2, and match-over.

## What it does

- **Race picker:** first to 5 (after work) or first to 10 (long match).
- **Live board:** Red / Blue columns, giant scores, tally boxes, `+ Goal` (localized) on each side. Tap the score or the button. Tap a team name to rename it.
- **Undo:** last goal, including if that goal just ended the match.
- **New match:** confirm, then 0–0 with the same race.
- **Match over:** play again (starts the next set and keeps set counts) or change race.
- Landscape is the comfortable rail layout; portrait is fully usable.

## Project layout

```
FoosballScoreboard/
  FoosballScoreboard.xcodeproj
  FoosballScoreboard/
    FoosballScoreboardApp.swift   App entry + previews
    Session.swift                 Live match state
    Match.swift                   First-to-N scoring
    RacePickerView.swift
    ScoreboardView.swift
    BoardChrome.swift             Oak header, felt field, paper card
    Theme.swift                   Color tokens + Anton / Oswald
    L10n.swift
    Localizable.xcstrings         DE FR NL EN IT ES PL
    InfoPlist.xcstrings           Localized display names
    Assets.xcassets/AppIcon       1024×1024, opaque, no mask
    Fonts/                        Anton + Oswald (SIL Open Font License)
```

Color tokens: paper `#F3E6C8`, paperShadow `#E4D4B0`, ink `#1C1612`, inkMuted `#483C30`, felt `#1F5C43`, oak `#8B5A2B`, oakLight `#C4A574`, oakDark `#56361C`, teamRed `#C23B32`, teamBlue `#2B5F8A`, brass `#C9A227`.
