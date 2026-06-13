# CLAUDE.md — Mo

Project context for Claude Code sessions. Read this first, then `current-state.md` for where work left off.

## What this is

**Mo** is a contemplative iOS divination app based on the Tibetan Mo system (Manjushri). The user holds a clear question, performs a ritual casting flow, and receives JSON-driven interpretive guidance drawn from a fixed cycle of **36 entries**. It is a study and reflection tool, not a game.

**Design philosophy (load-bearing — do not violate without discussion):**
- Ritual first — nothing should interrupt or trivialize the casting experience.
- Clarity over complexity — features should reduce confusion, not add cognitive load.
- Depth over engagement hacks — **no gamification, streaks, daily nudges, or addictive loops.**
- Respect the tradition — educational content stays accurate, concise, grounded.
- User ownership — users can save, reflect, and export freely. No lock-in.
- Explicitly avoided: social features, gamification, AI-generated interpretations.

## Repository layout (important gotcha)

The git repo and Xcode project live in **`Mo_app_wd/`**, *not* its parent `Mo-app/`. The parent folder only holds reference material (PDFs, PRD.md, design PNGs, `mo_entries.json` source copy). **Run `/start-here`, `/safe-close`, and all `git` commands from inside `Mo_app_wd/`** or git will fail with "not a git repository."

```
Mo_app_wd/                     <- repo root (run skills/git here)
  CLAUDE.md                    <- this file
  current-state.md             <- session waypoint (written by safe-close)
  phase-3-plan.md              <- active implementation plan
  product-roadmap.md           <- the canonical 4-phase roadmap
  README.md
  *.md                         <- content source (onboarding, how-to-consult, etc.)
  Mo.xcodeproj
  Mo/
    MoApp.swift                <- @main entry
    ContentView.swift          <- NavigationStack + screen switch + menu/onboarding
    Models/                    MoEntry, MoReading (+ MoCastPair, MoFirmness), SavedReading, Interpretation
    ViewModels/                MoAppViewModel  (single source of app state)
    Views/                     HomeView, RitualView, ResultView, SavedReadingsViews,
                               BringYourOwnDiceView, BookmarksView, FoundationLayerViews
    Components/                MoTokenView, ResultCardView
    Utilities/                 MoRepository, MoEntryLoader, SavedReadingStore, BookmarkStore, MoTheme
    Resources/mo_entries.json  <- single source of truth for the 36 entries
    Assets.xcassets
```

## Architecture

- **SwiftUI, MVVM, no external package dependencies.** Pure first-party frameworks.
- **`MoAppViewModel`** (`@MainActor`, `ObservableObject`) is the single hub for app state: current screen (`home`/`ritual`/`result`), current reading, saved readings, bookmarks, and all mutation methods. Most views take it as `@ObservedObject`. Built via `MoAppViewModel.makeLive()`; previews use `.makePreview()`.
- **JSON is the single source of truth for entries.** `MoEntryLoader` loads `Resources/mo_entries.json` → `MoRepository` indexes them and maps a dice/cast pair to an entry.
- **Casting logic, firmness logic, and persistence are kept separate:**
  - Casting/mapping → `MoRepository` (`castPair(for:)`, `reading(...)`).
  - Firmness → `MoFirmnessEvaluator.evaluate(primary:secondary:)` in `MoReading.swift` (veryFirm if casts match, weak if reversed, else standard).
  - Persistence → `SavedReadingStore` + `BookmarkStore`, plain JSON files in **Application Support/Mo/** (`saved-readings.json`, `bookmarked-entry-keys.json`), `.iso8601` dates, atomic writes. No CoreData.
- **`SavedReading`** is the persisted record (id, savedAt, optional question, primary/secondary cast, firmness + source, full `MoEntry` snapshot, isBookmarked). Its decoder uses `decodeIfPresent` for optional fields, so **adding new optional fields is backward-compatible** with existing saved files — rely on this for Phase 3.
- **Navigation:** `ContentView` holds a `NavigationStack` over `AppMenuDestination` (enum in `FoundationLayerViews.swift`) plus an in-place screen switch for the cast flow. The menu is a `HomeMenuSheet`. Onboarding is a `fullScreenCover` gated by `@AppStorage("shouldSkipOnboarding")`, re-shown on each fresh app open unless the user opted out.
- **`MoTheme`** centralizes colors and fonts — reuse it; don't hardcode styling.

## Build / run / test

- Open `Mo.xcodeproj` in Xcode, scheme **`Mo`**, run on an iPhone simulator (SwiftUI, no signing needed for sim).
- Single target `Mo`. **There is no test target yet** — no automated tests exist. Verify changes by building and running in the simulator (XcodeBuildMCP tools are available).
- After editing, the lightest check is a simulator build of the `Mo` scheme.

## Phase status

Phases 0–2 of `product-roadmap.md` are **complete**: cast flow, mantra animation, second-cast firmness, JSON interpretations, onboarding, intro + how-to-consult content, 36-entry browser, saved readings + detail, optional question, bring-your-own-dice, bookmarks.

**Current branch:** `phase3-reflection-layer`. Next work: a small set of Phase 2 save-time polish prompts, then Phase 3 (Reflection Layer). See `phase-3-plan.md` and `current-state.md`.

## Working agreement

- Don't make code changes until Todd gives the go-ahead; orient first.
- Honor the design philosophy above — when a feature could read as "engagement," flag it.
- Keep `current-state.md` truthful (git is the source of truth); update it via `/safe-close` when stepping away.
