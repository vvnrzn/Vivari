# Weekly Increment Report (template)

## Week of: September 16 to September 23, 2026

## What changed this week

- Replaced the starter Flutter counter screen with the Vivari Home Dashboard.
- Added the Vivari themed color palette.
- Added shared typography using Space Grotesk, DM Sans, and DM Mono.
- Added reusable theme and spacing values.
- Created reusable card, summary card, empty state, and bottom navigation widgets.
- Added empty dashboard states with zero values and no fabricated aquarium data.
- Added the My Aquariums section with a functional Add Aquarium button.
- Added functional navigation from the Home screen to Parameters and Care.
- Added placeholder screen structures for Aquarium Details, Parameters, and Care.
- Added navigation from Tasks Due Today and View All to the Care screen.
- Updated the layout to match the dashboard mockup.
- Updated the bottom navigation styling and replaced the Home icon with a fish-in-a-fishbowl icon.


## Why

- These changes were made to create a usable foundation for Vivari before adding real aquarium data and more complex features. The dashboard now communicates that the app is ready for the user to add their first aquarium, while the navigation and screen structure are ready for future development.
- The design system was centralized so future screens can use the same colors, fonts, spacing, cards, buttons, icons, and navigation styles without recreating those decisions in every file.

## What broke or what I got stuck on

- The initial summary layout did not support a task card that stretched across both columns, so the layout had to be changed from one grid to multiple explicit rows.
- Some Flutter theme properties were not available in the installed Flutter version. The unsupported navigation property had to be removed and the styling was implemented using supported properties.
- The app currently has placeholder versions of the Parameters, Care, and Aquarium Details screens. Their navigation works, but their full content has not been built yet.
- There is no database or application state for aquariums, inhabitants, tasks, water changes, or dosing records yet. Therefore, the dashboard can only display empty and zero states.

## What is left

- Build the full Parameters screen.
- Build the full Care screen.
- Build the Aquarium Details screen.
- Build the Add/Edit Aquarium screen.
- Add aquarium, inhabitant, task, and parameter models when the feature requirements are finalized.
- Add local storagefor real user data.
- Replace placeholder navigation screens with complete interfaces.
- Add parameter records, water-change records, dosing records, and task functionality.

# Weekly Increment Report

## Week of: September 24 to September 27, 2026

## What changed this week

* Built the Add Aquarium form with fields for aquarium name, aquarium type, volume and units, optional photo, and creation date.
* Added aquarium cards to the Home Dashboard that display aquarium entries created during the current app session.
* Added navigation from aquarium cards to an Aquarium Details screen, which currently has a placeholder structure.
* Reworked the Care screen into a schedule overview with an aquarium filter and separate List, Week, Month, and History views.
* Added empty states to the Care views since task data is not connected yet.
* Added a basic Parameters screen with an empty state.
* Added reusable floating action buttons to the Care and Parameters screens.
* Added placeholder screens for the Add Task and Log Parameters actions.
* Updated the bottom navigation styling, icons, and animation.
* Revised the README with setup instructions, project structure, screenshots, feature descriptions, and known limitations.
* Added Care and Add Aquarium screenshots to the README and corrected their image references.

## Why

* These changes were made to build the initial aquarium setup flow and allow users to create aquarium entries and view them on the dashboard.
* The Care and Parameters screens were expanded to establish the main structure for future task scheduling and water parameter tracking.


## What broke or what I got stuck on

* The Care and Parameters screens are not connected to task or measurement data yet, so their add actions currently lead to placeholder screens.
* Aquarium entries are currently stored only in memory, so the entries are lost when the app restarts.
* Aquarium details, editing, inhabitant management, and persistent storage have not been implemented yet.

## What is left

* Update or fix the two failing widget tests so they match the current UI.
* Build the full Aquarium Details and Edit Aquarium screens.
* Add inhabitant management.
* Add persistent storage for aquarium data and photos.
* Build parameter logging, history, and tracking.
* Implement task creation, scheduling, completion, and history in Care.
* Connect dashboard summaries to aquarium, inhabitant, parameter, and care data.
* Replace the remaining placeholder screens with complete interfaces.
* Record and add the demo video to the documentation.
