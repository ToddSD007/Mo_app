# Current State — Mo

_Last updated: 2026-06-13_

The session waypoint. A fresh session should read this first, then `CLAUDE.md`, then `phase-3-plan.md`.

## Where things stand

- **Phases 0–2 complete** and consistent with the code (cast flow, mantra ritual + second-cast firmness, JSON interpretations, onboarding, intro/how-to content, 36-entry browser, saved readings + detail, optional question, bring-your-own-dice, bookmarks).
- **Branch:** `phase3-reflection-layer`.
- No drift found between docs and code as of this date. Git is the source of truth.

## This session (2026-06-13)

This was an onboarding/handoff session — taking over from a prior Codex session whose conversation history was lost. **No app code was changed.** Work done:
- Got fully oriented in the codebase (read models, view model, views, persistence, navigation).
- Created **`CLAUDE.md`** — durable project context, architecture, design philosophy, build/run, and the repo-layout gotcha (repo root is `Mo_app_wd/`, not the parent `Mo-app/` — running skills/git from the parent fails with "not a git repository").
- Created **`phase-3-plan.md`** — the Phase 3 (Reflection Layer) implementation plan, with the Phase 2 save-time polish captured as the explicit first step.

## Next concrete steps

1. **Phase 2 save-time polish (do first):** add "a few prompts when saving a reading" in `ResultView.saveSection`. **Before building, resolve Open Question #1** — confirm exactly which prompts and how they relate to Phase 3's Guided Reflection prompts (see `phase-3-plan.md`).
2. **Phase 3, milestone 3A:** extend `SavedReading` with optional `reflection` + `checkIn` fields (backward-compatible via `decodeIfPresent`) and add the corresponding `MoAppViewModel` methods.
3. Then 3B (reflection UI) → 3C (outcome check-in + local notifications + deep-link) → 3D (minimal surfacing). Full breakdown in `phase-3-plan.md`.

## Open questions

1. **Phase 2 save prompts vs. Phase 3 reflection prompts** — what's the boundary / are they the same thing? (Resolve before building either.)
2. Reflection prompts: four separate optional fields, or one combined note?
3. Notification permission UX — confirm "ask only on first reminder opt-in."
4. Deep-link mechanism into a specific saved reading (decided when we reach 3C).
5. Add a test target before Phase 3? None exists today; recommended for the persistence/migration changes.

## Notes for resuming

- Run `/start-here`, `/safe-close`, and `git` from inside `Mo_app_wd/`.
- Build/verify: open `Mo.xcodeproj`, scheme `Mo`, run on an iPhone simulator. No automated tests yet.
- Don't change code until Todd gives the go-ahead.
