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
