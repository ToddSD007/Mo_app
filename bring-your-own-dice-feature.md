Implement the “Bring Your Own Dice” feature in the existing SwiftUI Mo app.

Read the Product Roadmap for overall context and preserve the contemplative tone and visual language of the app.

IMPORTANT DESIGN GOAL

This feature should feel like:
- a respectful companion to a physical ritual
- not a utility form
- not a game mechanic
- not a calculator

The user is already performing the ritual externally with physical dice or tokens.
The app’s role here is:
- interpretation
- guidance
- preservation of the ritual structure

Do NOT route the user through the existing Ritual animation screen for this flow.
That would feel redundant because the user is already performing the ritual physically.

-----------------------------------
FEATURE OVERVIEW
-----------------------------------

Add a new menu item:
- “Bring Your Own Dice”

Selecting it should open a dedicated manual casting screen.

The screen allows the user to:
1. Enter the first cast manually
2. Optionally enter a second cast for firmness
3. Reveal the corresponding result directly

No ritual animation screen should appear.

-----------------------------------
SCREEN STRUCTURE
-----------------------------------

TITLE:
Bring Your Own Dice

SUBTITLE:
“Roll your dice while holding your question in mind, then enter the result below.”

SECONDARY LINK:
“How to use your own dice”

This link should open a scrollable modal sheet displaying markdown content from a local .md file.

The instructions content will be supplied separately.

-----------------------------------
MAIN CAST SECTION
-----------------------------------

The primary cast should be visually organized into TWO CLEAR COLUMNS:

LEFT COLUMN:
First Die

RIGHT COLUMN:
Second Die

This visual separation is important because it teaches and reinforces:
- order matters
- first die = first syllable
- second die = second syllable

Each column should contain six selectable token buttons.

Each token should display:
- the number
- the syllable

Example:
1: "DHI", "དྷཱིཿ "
2: "RA", "ར"
3: "PA", "པ"
4: "NA", "ན"
5: "TSA", "ཙ"
6: "AH", "ཨ"

Use the app’s established visual language:
- soft rounded tokens
- gold accent when selected
- elegant spacing
- calm, tactile feeling

Avoid:
- picker wheels
- text fields
- dropdowns
- cramped grids

The selection should feel intentional and ritual-like.

-----------------------------------
OPTIONAL FIRMNESS CAST
-----------------------------------

Below the primary cast section:

Add a divider and a collapsed optional section.

Collapsed state:

TITLE:
Optional Firmness Cast

BODY:
“Determine how firmly the result should be held.”

BUTTON:
“Add Firmness Cast”

When tapped:
- expand the section inline
- reveal another pair of columns:
  - First Die
  - Second Die

Use the exact same token selector UI as the primary cast.

This second cast is OPTIONAL.

If the user does not enter it:
- no firmness should be computed
- no firmness section should appear on the Result screen

If the user DOES enter it:
- compute firmness using the existing firmness logic:
  - same order = very firm
  - reversed order = weak
  - otherwise = standard

-----------------------------------
PRIMARY ACTION
-----------------------------------

Primary button at bottom:

“Reveal the Result”

Behavior:
- validate that primary cast is complete
- lookup result using existing JSON
- compute firmness ONLY if optional firmness cast exists
- navigate directly to Result screen

No ritual animation transition.

Optional:
- use a subtle fade transition only

-----------------------------------
RESULT SCREEN UPDATES
-----------------------------------

Reuse the existing Result screen.

If the user entered a firmness cast:
- display the existing firmness section normally

Additionally:
- include a very subtle line of text near the firmness section:

“Firmness determined from manual cast”

This should:
- be visually quiet
- almost footnote-like
- not draw excessive attention

Purpose:
- reinforce that the user performed the ritual physically
- strengthen trust in the process

If NO firmness cast was entered:
- omit firmness entirely
- do not display placeholders
- do not display “unknown firmness”

-----------------------------------
INSTRUCTIONS MODAL
-----------------------------------

The “How to use your own dice” link should present:
- a scrollable modal sheet
- beautiful typography
- same long-form editorial style used in:
  - Introduction
  - How to Consult

Implementation:
- load markdown content from local bundled .md file

Requirements:
- readable line spacing
- generous padding
- elegant spacing between sections
- support headings and bullet lists cleanly

-----------------------------------
DATA / LOGIC REQUIREMENTS
-----------------------------------

Reuse the existing:
- syllable mapping
- result lookup logic
- firmness evaluation logic
- Mo entry JSON

Do NOT create duplicate lookup systems.

-----------------------------------
UX REQUIREMENTS
-----------------------------------

The screen should feel:
- spacious
- calm
- ceremonial
- easy to understand immediately

Avoid:
- overwhelming the user
- dense instruction blocks on the main screen
- excessive controls
- unnecessary validation warnings

Use progressive disclosure:
- firmness cast hidden until requested

-----------------------------------
ARCHITECTURE
-----------------------------------

Please implement cleanly:
- reusable token selector component
- reusable cast pair model if useful
- manual cast logic separated from UI
- markdown modal view reusable elsewhere later

Keep code organized and extensible.

-----------------------------------
FINAL GOAL
-----------------------------------

This feature should feel like:
- the app respectfully assisting a traditional physical ritual
rather than
- the app replacing it.