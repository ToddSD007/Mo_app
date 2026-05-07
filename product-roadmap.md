
**Product Vision**

Mo is a contemplative divination app that helps users:

- ask clear questions
- receive meaningful guidance
- reflect over time
- deepen their understanding of the Mo system

The experience prioritizes **clarity, calmness, and ritual integrity** over speed, gamification, or social engagement.



**Guiding Principles**

1. **Ritual First**

- The casting experience is the heart of the app
- Nothing should interrupt or trivialize it

3. **Clarity Over Complexity**

- Features should reduce confusion, not add cognitive load

5. **Depth Over Engagement Hacks**

- No gamification, streaks, or addictive loops
- Retention comes from meaning, not compulsion

7. **Respect the Tradition**

- Educational content should be accurate, concise, and grounded

9. **User Ownership**

- Users can save, reflect, and export freely
- No lock-in or forced ecosystem



**Release Phases**



**PHASE 0 — MVP (Complete)**

**Status: Done**

Core functionality:

- Cast flow (Home → Ritual → Result)
- Token-based casting
- Mantra animation
- Second cast (firmness)
- Result interpretation (JSON-driven)



**PHASE 1 — Foundation Layer**

**Goal:** Help users understand what they are doing and how to do it well

**Features**

**1. Introduction Section**

**Purpose:** Context and legitimacy

Content:

- What is Mo
- Why Manjushri
- What this app is (and is not)

Constraints:

- Short, readable, not academic
- ~2–4 screens max



**2. How to Consult the Mo (Critical)**

**Purpose:** Improve question quality and interpretation

Content sections:

- Preparing the mind
- The mantra (meaning + role)
- How to form a clear question
- What makes a question “good”
- How to receive an answer

Optional:

- short guided visualization (text only)



**3. 36 Entries Browser**

**Purpose:** Transparency + study tool

Features:

- List of all entries
- Tap → full interpretation view
- Same layout as Result screen

Constraints:

- Clearly separate from ritual flow
- No casting from this screen



**4. Lightweight Onboarding**

**Purpose:** Prevent confusion on first use

Trigger:

- First app launch only

Content:

- 2–3 screens max:

- “Hold a clear question in mind”
- “This app presents traditional Mo guidance”
- “Proceed when ready”

Option:

- “Don’t show again”



**Phase 1 Outcome**

User now:

- understands what Mo is
- knows how to ask better questions
- trusts the system
- can explore the entries



**PHASE 2 — Personal Practice Layer**

**Goal:** Create continuity across readings



**5. Saved Readings (High Priority)**

**Purpose:** Preserve meaningful readings

Data stored:

- date/time
- user question (optional input)
- result key + title
- firmness
- full interpretation snapshot

UI:

- “Save reading” button on Result screen
- “Readings” section in menu

List view:

- chronological
- simple cards:

- title
- date
- optional question preview



**6. Reading Detail View**

**Purpose:** Revisit past readings

Displays:

- full result (same as Result screen)
- stored question
- firmness
- timestamp



**7. Bring Your Own Dice**

**Purpose:** Support traditional practice

Flow:

- User selects “Manual Cast”
- Inputs two values (1–6 each)
- App maps to syllables + result

Optional:

- toggle in settings or entry point in menu

Constraint:

- Keep UI minimal and respectful



**8. Favorites / Bookmarks**

**Purpose:** Personal reference library

Features:

- Bookmark any entry
- “Favorites” section
- Works for:

- saved readings
- 36 entries browser



**Phase 2 Outcome**

User now:

- builds a personal history
- revisits meaningful results
- engages with Mo beyond single sessions



**PHASE 3 — Reflection Layer**

**Goal:** Deepen insight over time



**9. Guided Reflection (Journal Evolution)**

**Purpose:** Turn readings into insight

Attached to saved readings

Prompts (optional):

- What was your question?
- What stands out in this reading?
- What action feels appropriate?
- What remains unclear?

Design:

- lightweight, not overwhelming
- optional entry per reading



**10. Outcome Check-In**

**Purpose:** Close the loop over time

Feature:

- “Remind me” when saving a reading

User selects:

- date/time

Notification:

- “Revisit your reading”

Follow-up prompt:

- What happened?
- Did the sign become clearer?



**11. Notifications (Minimal Use)**

**Purpose:** Support reflection, not engagement

Only used for:

- outcome check-ins

Avoid:

- daily prompts
- engagement nudges



**Phase 3 Outcome**

User now:

- reflects over time
- tests interpretation against experience
- develops intuition with the system



**PHASE 4 — Utility & Polish**

**Goal:** Add flexibility without changing tone



**12. Export Function**

**Purpose:** User ownership

Formats:

- plain text
- nicely formatted share card (optional)

Includes:

- question
- result
- interpretation
- reflection (if present)

No social features required



**13. Search / Filter (Entries)**

**Purpose:** Improve discoverability

Options:

- search by title
- filter by tone:

- favorable
- mixed
- unfavorable



**14. Settings (Lightweight)**

Possible options:

- haptics on/off
- animation speed
- show transliteration
- default cast mode (app/manual)



**Future (Optional / Exploratory)**

- Audio mantra (very carefully designed)
- Ritual customization (advanced users)
- Expanded educational content

Avoid:

- social features
- gamification
- AI-generated interpretations



**Navigation Structure (Future State)**

Menu:

- Cast (Home)
- Readings
- Entries
- How to Consult
- Introduction
- Favorites
- Settings



**Technical Notes for Codex**

- Keep JSON as single source of truth for entries
- Add persistence layer (CoreData or lightweight local storage)
- Separate:

- casting logic
- firmness logic
- persistence layer

- Design reusable ResultView for:

- live results
- saved readings
- entry browser



**Summary**

**What this roadmap prioritizes:**

- understanding → before features
- continuity → before expansion
- reflection → before engagement

**What it avoids:**

- clutter
- social pressure
- shallow interaction loops