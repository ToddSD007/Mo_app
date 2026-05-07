# Mo

Mo is a contemplative iOS divination app based on the Tibetan Mo system. It helps users hold a clear question, complete a ritual casting flow, receive JSON-driven interpretive guidance, and study the full cycle of 36 Mo entries.

The app prioritizes clarity, calmness, and ritual integrity over speed, gamification, or social engagement.

## Status

- Phase 0 MVP: complete
- Phase 1 Foundation Layer: complete
- Phase 2 Personal Practice Layer: next

## Current Features

- Home → Ritual → Result casting flow
- Token-based casting mapped to Manjushri mantra syllables
- Animated mantra ritual screen
- Second cast firmness evaluation
- JSON-backed result interpretations
- First-launch onboarding with an explicit "Don't show this again" option
- Introduction and "How to Consult the Mo" foundation content
- 36-entry browser for study and reference

## Project Structure

```text
Mo/
  MoApp.swift
  ContentView.swift
  Models/
  ViewModels/
  Views/
  Components/
  Utilities/
  Assets.xcassets
  Resources/mo_entries.json
```

Supporting product and reference documents live at the repository root:

- `product-roadmap.md`
- `introduction-section.md`
- `how-to-consult-the-mo.md`
- `onboarding.md`
- `dice-syllables.md`

## Build And Run

1. Open `Mo.xcodeproj` in Xcode.
2. Select the `Mo` scheme.
3. Choose an iPhone simulator or connected device.
4. Build and run.

The project is implemented in SwiftUI and does not require external package dependencies.

## Roadmap

Phase 2 is focused on the personal practice layer:

- saved readings
- reading detail history
- optional user questions
- manual "bring your own dice" casting
- favorites or bookmarks

