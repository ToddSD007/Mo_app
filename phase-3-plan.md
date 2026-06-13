# Phase 3 — Reflection Layer (Implementation Plan)

Derived from `product-roadmap.md` items 9–11. **Goal: deepen insight over time** — turn readings into reflection, and close the loop on outcomes. Same constraints as always: lightweight, optional, no engagement loops. Notifications are used *only* for outcome check-ins — never daily prompts or nudges.

Status: **planned, not started.** Branch `phase3-reflection-layer`.

---

## Pre-Phase-3: Phase 2 save-time polish (do first)

Todd wants "a few prompts when saving a reading" added to the Phase 2 save flow before starting Phase 3.

- **Where:** `ResultView.saveSection` (`Views/ResultView.swift`) — today it has a single optional "Question or note" `TextField` bound to `readingQuestion`, then a Save button calling `viewModel.saveCurrentReading(question:)`.
- **Likely shape:** a small number of optional short prompts captured at save time (in addition to / instead of the single note field).
- **⚠ Open — confirm with Todd before building:** exactly which prompts, how many, and whether they're distinct from the Phase 3 *Guided Reflection* prompts (item 9 below). These two could overlap; clarify the boundary so we don't build the same thing twice. Decide whether save-time prompts persist as structured fields on `SavedReading` (preferred — see 3A) or just concatenate into `question`.

---

## 9. Guided Reflection (journal evolution)

Optional reflection attached to a **saved** reading. Prompts (all optional):
- What was your question?
- What stands out in this reading?
- What action feels appropriate?
- What remains unclear?

Design: lightweight, never required, one optional reflection per reading. Editable after the fact.

## 10. Outcome Check-In

Close the loop over time:
- When saving a reading, optional **"Remind me"** → user picks a date/time.
- Schedule a **local notification**: "Revisit your reading."
- Tapping the notification opens *that specific reading*.
- Follow-up prompts on return: *What happened? Did the sign become clearer?*

## 11. Notifications (minimal)

`UNUserNotificationCenter` local notifications, **outcome check-ins only.** Request authorization *only when the user first opts into a reminder* (not at launch). No daily/engagement notifications, ever.

---

## Implementation milestones

### 3A — Data model & persistence (foundation)
- Extend `SavedReading` (`Models/SavedReading.swift`) with **new optional fields**, backward-compatible via `decodeIfPresent`:
  - `reflection: Reflection?` — struct holding the optional prompt answers (+ its own `updatedAt`).
  - `checkIn: CheckIn?` — struct holding `remindAt: Date?`, scheduled notification id, and outcome answers (`whatHappened`, `becameClearer`) + `completedAt`.
- Make the affected fields `var` and add `CodingKeys` + decode lines for each new field. Bump nothing else — existing `saved-readings.json` files must still load.
- Add `MoAppViewModel` methods: `updateReflection(_:for:)`, `setReminder(_:for:)` / `clearReminder(for:)`, `recordOutcome(_:for:)`, each persisting through `SavedReadingStore` (reuse the existing `persistSavedReadings` path).
- Keep JSON the source of truth; no CoreData.

### 3B — Guided Reflection UI
- Add a **Reflection** section to `SavedReadingDetailView` (`Views/SavedReadingsViews.swift`): the four optional prompts as editable fields, an empty/"Add reflection" state, save action → `viewModel.updateReflection`.
- Show a subtle indicator on `SavedReadingRowView` when a reflection exists.
- Reuse `MoTheme` card styling; keep it calm and uncluttered.

### 3C — Outcome Check-In + Notifications
- New utility `Utilities/ReflectionNotificationScheduler.swift`: request authorization on demand, schedule/cancel a local notification tied to a reading id, expose authorization state.
- "Remind me" entry point: at save time (`ResultView`) and/or in `SavedReadingDetailView`. Date/time picker; on confirm → request auth (if needed) → schedule → store `checkIn.remindAt` + notification id.
- **Deep link:** handle notification tap → route `ContentView`'s `navigationPath` to `.readings` → the specific `SavedReadingDetailView` (need an `AppMenuDestination` / path entry that carries a reading id, or select-by-id on appear).
- Follow-up outcome prompts shown when revisiting a reading whose `remindAt` has passed → `viewModel.recordOutcome`.

### 3D — Surfacing & polish (keep minimal)
- Optionally surface readings awaiting an outcome check-in (no badge spam).
- No new top-level nav unless it earns its place.

---

## Open questions (resolve before/while building)
1. **Phase 2 save prompts vs. Phase 3 reflection prompts** — what's the boundary? (See pre-phase note.)
2. Reflection prompts: four separate fields, or one combined note? (Plan assumes separate optional fields.)
3. Notification permission UX — confirm "ask only on first reminder opt-in" is the desired behavior.
4. Deep-linking mechanism into a specific saved reading — confirm approach when we get to 3C.
5. Do we want a test target before Phase 3 (currently none), at least for the persistence/migration logic? Recommended given the model changes.

## Verification
No automated tests exist. After each milestone, build + run the `Mo` scheme in the simulator and manually verify: existing saved readings still load (migration), reflection saves/reloads, reminder schedules + fires + deep-links, outcome records persist.
