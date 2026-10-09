# Weekly reports

One entry per week, newest at the top, written **during** that week. Five minutes
each. They are the record of how the project actually went, and they make your
final reflection almost write itself.

Copy this block:

---

## Week 4 (October 6 to October 9)

**Done this week**
- Improved the global aquarium state flow so total inhabitants are recalculated correctly when inhabitants are added, edited, or removed.
- Finished the pending task badge workflow on aquarium cards and linked it to the Care screen for faster task awareness.
- Continued refining the aquarium details experience and dashboard logic to better reflect real aquarium status.
- Updated the project proposal, README, and security/privacy documentation to match the current app scope and implementation status.
- Added supporting AI usage and project documentation updates to keep the development trail clear for final review.

**In progress**
- Finalizing the remaining polish for the aquarium details, care, and summary screens.
- Checking where the app still depends on mock or in-memory data before the next persistence work.

**Blocked or stuck on**
- Local persistence is still not implemented, so aquarium, inhabitant, and task data are still lost when the app restarts.
- Some stretch features, such as custom parameter date ranges and external species lookups, are still deferred.

**Decisions made, and why**
- Kept improvements focused on state accuracy and user-facing task awareness so the dashboard reflects real app status instead of placeholder values.
- Updated the docs and proposal alongside the product changes so the final project record matches the actual implementation.
- Prioritized usability fixes over broad feature expansion while the app still lacks persistent storage.

**Hours spent, roughly:** 8-12 hours

**Next week I will:**
- Finalize the remaining aquarium detail and dashboard refinements.
- Continue tightening the data lifecycle and state consistency across screens.
- Move toward persistence and the next round of app-level QA and documentation cleanup.

---

## Week 3 (September 28 to October 5)

**Done this week**
- Built the Add Inhabitant workflow with smart local search and category filtering for freshwater and saltwater species.
- Added a reusable local inhabitants catalog so users can add matching species without relying on an external API.
- Improved the Aquarium Details screen so it can display inhabitants, edit quantities, and filter by type.
- Added state coordination so the total inhabitants count updates correctly across the app when aquarium data changes.
- Added pending task badge logic on aquarium cards and linked it to the care workflow.
- Expanded the documentation and proposal notes to reflect the new aquarium and inhabitant features.

**In progress**
- Polishing the full aquarium details experience and making sure the status cards and care states align with the available data.
- Finalizing the app’s core state model so the dashboard and detail screens obey the same rules.

**Blocked or stuck on**
- The app still relies on in-memory state rather than persistent local storage.
- There is no external species API yet, so the catalog remains local and static.
- Some advanced feature ideas, such as custom date ranges and reminders, remain in the planning stage.

**Decisions made, and why**
- Chose a local catalog instead of an external API to keep development moving without introducing web or backend dependencies.
- Kept state updates centralized so counts and summaries stay accurate as aquarium data changes.
- Focused on the aquarium details and care linkages first because they directly improve the user’s daily maintenance flow.

**Hours spent, roughly:** 10-14 hours

**Next week I will:**
- Finish the remaining aquarium details and dashboard polish.
- Tighten state consistency around tasks and summaries.
- Continue building toward persistence, final QA, and documentation updates.

---

## Week 2 (September 24 to September 27)

**Done this week**
- Built the Add Aquarium form with fields for name, type, volume, units, optional photo, and creation date.
- Added aquarium cards to the Home Dashboard that display entries created in the current app session.
- Added navigation from aquarium cards to an Aquarium Details screen placeholder.
- Reworked the Care screen into a schedule overview with aquarium filter and List/Week/Month/History views.
- Added empty states to the Care views because task data was not connected yet.
- Added a basic Parameters screen with an empty state and reusable floating action buttons.
- Added placeholder screens for Add Task and Log Parameters actions.
- Updated navigation styling, icons, and animation polish.
- Updated the README with setup instructions, project structure, screenshots, feature descriptions, and known limitations.

**In progress**
- Finalizing the aquarium setup flow and dashboard behavior.
- Expanding the main structure for Care, Parameters, and Aquarium Details.
- Preparing the app for real data and fuller feature work without overbuilding before requirements are set.

**Blocked or stuck on**
- The Care and Parameters screens are still not connected to live task or measurement data.
- Aquarium entries are only stored in memory, so they disappear when the app restarts.
- Aquarium details, editing, inhabitant management, and persistent storage are still not implemented.
- Two widget tests are still failing and need to be updated to match the current UI.

**Decisions made, and why**
- Kept the app focused on the basic aquarium setup flow and foundational screens before building full logic.
- Used placeholder actions and empty states instead of fake task or parameter data so the app remains honest about what is implemented.
- Prioritized stable navigation and reusable patterns so future features can be added cleanly.

**Hours spent, roughly:** 10-14 hours

**Next week I will:**
- Fix the failing widget tests so the project is stable and matches the current UI.
- Build the full Aquarium Details and Edit Aquarium screens.
- Add inhabitant management and persistent storage for aquarium data and photos.
- Implement parameter logging, history, and tracking.
- Build task creation, scheduling, completion, and history in Care.
- Connect dashboard summaries to real aquarium, inhabitant, parameter, and care data.
- Replace the remaining placeholder screens with complete interfaces.
- Record the demo video and add it to the documentation.

---

## Week 1 (September 16 to September 23)

**Done this week**
- Replaced the starter Flutter counter screen with the Vivari Home Dashboard.
- Added the Vivari design system: theme colors, typography, spacing, and reusable layout values.
- Built reusable UI elements like cards, summary cards, empty states, and the bottom navigation.
- Added an empty dashboard state and the My Aquariums section with an Add Aquarium button.
- Added working navigation from the Home screen to Parameters and Care, along with placeholder screens for Aquarium Details, Parameters, and Care.
- Updated the layout to match the dashboard mockup and refined the navigation styling/icon set.

**In progress**
- Turning the app structure into a real feature foundation that can support aquarium data and future screens.
- Building the core navigation and screen hierarchy so later features have a stable home.

**Blocked or stuck on**
- The original summary layout could not support a task card spanning both columns, so it had to be redesigned.
- Some Flutter theme properties were not supported by the installed Flutter version, so the styling had to be adjusted.
- The Parameters, Care, and Aquarium Details screens were placeholder-only because the app did not yet have aquarium data or storage.

**Decisions made, and why**
- Centralized the design system early so the app would stay consistent and easier to extend.
- Used empty states and no fabricated aquarium data to avoid pretending the app had real functionality before the data model existed.
- Kept navigation and screen shells in place even before full content was added, so the app structure was ready for the next feature layer.

**Hours spent, roughly:** 12-15 hours

**Next week I will:**
- Build the Add Aquarium flow and allow users to create aquarium entries.
- Add aquarium cards to the dashboard so the app feels more real and interactive.
- Expand the Care and Parameters screens into more complete structures.
- Continue refining the app foundation before adding full data models and persistence.

---

