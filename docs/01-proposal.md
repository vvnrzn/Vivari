# Proposal

## The problem, in one sentence

Vivari helps aquarium owners keep track of multiple tanks, inhabitants, recurring care tasks, and water-quality readings in one place so they can catch maintenance issues before they become bigger problems.

## Who it is for

* Aquarium hobbyists who manage one or more freshwater, planted, or saltwater tanks.
* People who currently rely on memory, notes, spreadsheets, or a mix of reminder apps and paper logs.
* Users who want a single place to track tank details, care routines, and water health without needing a shared account or cloud setup.

## Core features

* Aquarium management: create, edit, and browse multiple tanks with details such as name, type, volume, notes, and photo.
* Inhabitant tracking: add species or common names to each aquarium and manage counts.
* Maintenance task management: create recurring and one-off care tasks, track completion, and review due or overdue work.
* Water parameter tracking: log measurements such as temperature, pH, ammonia, nitrite, nitrate, and salinity, and compare them with recommended ranges.
* Overview dashboard: see total aquariums, inhabitants, due tasks, and recent activity across the user's setup.

## Out of scope, and why

* Shared accounts and cloud syncing: this app is designed for a single owner managing their own tanks, so a server is unnecessary for the MVP.
* Advanced species databases and external APIs: the app already works with a local catalog and manual entry, which keeps the MVP simple and reliable.
* Push notifications and scheduled reminders: they are useful later, but the core task and parameter tracking experience is more important to get working first.
* Social or community features and advanced analytics: they would expand the app beyond its main purpose and add complexity before the core care workflow is finished.

## Data the app remembers, and where it is saved

* Aquarium data: aquarium ID, name, type, volume, notes, created date, and photo.
* Inhabitant data: aquarium ID, species or common name, category, and quantity.
* Maintenance task data: aquarium association, task name, due date, recurrence, completion state, and activity history.
* Water readings: aquarium ID, parameter type, reading, unit, and timestamp.
* Parameter settings: enabled parameters and recommended minimum and maximum values.
* Current state: the app stores this information locally on the device rather than in a shared server. The current version keeps it in app memory during a session; the planned MVP storage approach is local device persistence (for example, a SQLite or Hive-style local database) because the app is personal and does not need multi-user access.

## Risks

* Data persistence risk: if local storage is not implemented carefully, aquarium, task, and parameter records can be lost when the app closes or restarts.
* Platform limitations: features such as notifications and web-specific behavior may require fallback patterns or device testing.
* Scope creep: adding species APIs, graphs, and notifications too early can delay the core aquarium-care experience.
* Water-parameter complexity: multiple tanks and many readings can make compliance checks and charting harder if the data model is not kept simple and consistent.
