# Proposal

#old proposal
# 1. Proposal, version 2

## App name

Vivari

* Derived from *vivarium* (Latin for "place of life").

## The problem, in one sentence

Aquarium hobbyists with multiple tanks struggle to keep track of their tank inhabitants, recurring maintenance tasks, and water parameters, making it easy to miss important care tasks or overlook potentially harmful changes in water quality.

## Who is this for

* Freshwater, planted, and saltwater aquarium owners, especially hobbyists who maintain multiple tanks.
* They currently rely on memory, physical logbooks, whiteboard calendars, spreadsheets, or generic reminder apps that do not connect maintenance tasks with specific aquariums or track water parameters and inhabitants together.

## Core features (MVP), revised

| # | Feature                  | Still in the MVP? | Flutter pieces it needs                                                                                 | Honest estimate |
| - | ------------------------ | ----------------- | ------------------------------------------------------------------------------------------------------- | --------------- |
| 1 | Aquarium Management      | keep              | `ListView.builder`, `Card`, `TextField`, `showDialog`, `Navigator.push`, `setState`                     | 10 hours        |
| 2 | Maintenance Task Manager | keep              | `ListView.builder`, `Card`, `TextField`, `Checkbox`, date picker, recurring task controls, `showDialog` | 10 hours        |
| 3 | Water Parameter Tracking | keep              | `Card`, `TextField`, parameter controls, `ListView.builder`, `Navigator.push`                           | 8 hours         |

**Estimated MVP total: approximately 28 hours.**

I am keeping Aquarium Management, Maintenance Task Manager, and Water Parameter Tracking because these are the features that directly address the original problem. I also decided to keep the MVP focused on the main aquarium management functions instead of adding a server and shared account system. Since Vivari is primarily a personal aquarium management app, the user's aquarium information can be stored locally on their device. This reduces development time and avoids adding authentication, cloud database setup, and synchronization that are not necessary for the core purpose of the app.

## Stretch goals

1. **Water Parameter Graphs** – Allow users to view their recorded water measurements as Week, Month, or Custom graphs to see changes and trends over time.
2. **Fish Species Smart Search** – When adding an inhabitant, the user can type part of a species name and receive suggestions from an external fish species API/database instead of manually entering the entire species name.
3. **Notifications** – Notify users about upcoming or overdue maintenance tasks such as water changes, dosing, cleaning, or other recurring aquarium care.

I decided to make the graphs a stretch goal because they are useful for seeing trends, but they are not necessary for the main purpose of Water Parameter Tracking. Users can still record measurements, see the current status, compare values with the recommended range, and identify possible problems without graphs. This also gives me more time to complete the core MVP features first.

The fish species search and notifications are also features I would like to include if there is enough time, but the core app will still function without them.

## NEW: How my app saves data

**The question from page 1:** if two different people install my app, should they see the same data?

**No.** Vivari is intended to work as a personal aquarium management app. Each user can manage and save their own aquarium information, maintenance tasks, inhabitants, and water parameter records on their device. The app does not need two different users to access the same aquarium data.

Because shared data is not required, I do not need a server or cloud database for the MVP. Keeping the data on the device also reduces the amount of setup and development time needed for the project.

**Roughly how many records** does my app hold in a realistic week of use?

I estimate that an active user with multiple aquariums could create approximately **50–100 new records per week**, mainly from maintenance tasks and water parameter measurements. This could be higher for users who test their water frequently or maintain several tanks.

**My choice:** **Local database/storage on the device.**

**Why this one and not a server:**

I chose local storage because Vivari does not require different users to share the same aquarium data. A server would add extra work such as authentication, cloud database setup, synchronization, and internet requirements. Since the main purpose of Vivari is to help an individual aquarium owner manage their own tanks, keeping the data on the device is enough for the MVP. This allows me to spend more time developing and testing the actual aquarium management features.

**What I save, concretely:**

* **Aquarium** – aquarium ID, name, tank type, volume, setup date, image, and notes.
* **Inhabitant** – inhabitant ID, aquarium ID, species/name, category, and quantity.
* **Maintenance Task** – task ID, aquarium ID(s), task name, category, due date, recurrence, and completion status.
* **Water Parameter Record** – record ID, aquarium ID, parameter type, measured value, unit, and date/time recorded.
* **Parameter Settings** – aquarium ID, enabled parameters, and recommended minimum/maximum values.

These records will be stored locally on the user's device. No internet connection or user account is required for the core MVP.

**Have I tried it yet?**

Not yet. I will first test the selected local storage/database option by saving and retrieving a few sample aquarium records before building the complete data structure.

## NEW: One thing I want to add that the course did not teach

I want to add **three** features that were not part of the course's core Flutter activities: water parameter graphs, fish species smart search, and notifications. All three are **stretch goals**.

### 1. Water Parameter Graphs

Users will be able to view their recorded water measurements as graphs. The graphs can show parameter changes over a selected period such as Week, Month, or Custom.

* **Purpose:** Help users see water parameter trends over time.
* **Priority:** **Stretch goal.**
* **Reason:** Graphs are useful for analyzing trends, but they are not required for recording measurements or showing parameter alerts. The core parameter tracking feature can work without them.

### 2. Fish Species Smart Search

When the user adds an inhabitant, they can type part of a species name and receive matching suggestions from an external fish species database/API. This would make adding inhabitants faster because users would not need to manually type the entire species name.

* **Package:** `http` for making API requests.
* **Where it runs:** `http` is listed as working in the web development environment.
* **Web fallback:** If the selected fish species API does not work correctly on web, users can still manually type and save the species name.
* **How I will demonstrate the real feature:** If the API works on web, it will be demonstrated directly in the browser. If it requires a supported device or has another platform limitation, I will demonstrate the working API search through a phone recording in the final demonstration.
* **Priority:** **Stretch goal.**

### 3. Notifications

Notifications will remind users about upcoming or overdue aquarium maintenance tasks.

* **Package:** `flutter_local_notifications`.
* **Where it runs:** The course platform table indicates that local notifications do not work in the web development environment and require a real device.
* **Web fallback:** The web version will still open and allow the user to navigate through the Care screen and view sample/upcoming task notification states without the actual device notification service.
* **How I will demonstrate the real feature:** The actual notification will be demonstrated on a supported phone/device and shown through the final recording.
* **Priority:** **Stretch goal.**

## NEW: How my project runs when someone else opens it

* I am keeping the `device_preview` wrapper: **Yes.**
* My app runs in a browser with `flutter run -d web-server`, start to finish, with every screen reachable: **Not yet.** I still need to test the complete navigation and local data storage.
* Anything that needs real hardware degrades to sample data instead of crashing: **Not applicable.** Vivari does not currently depend on aquarium sensors or other physical hardware.
* My project will live in a **public repository in my own GitHub account**, not the course org. Does anything I plan to build need an API key, a password, or real personal data? **The MVP does not require an external API key. The fish species API may require an API key depending on the service I choose. If an API key or other secret is required, it will not be committed to the public repository and will be kept using the course's recommended secret-management approach. No real personal data will be included in the repository.**

## Data the app remembers

| Thing                   | Fields                                                                                | Where it is saved      |
| ----------------------- | ------------------------------------------------------------------------------------- | ---------------------- |
| Aquariums               | aquarium ID, name, tank type, volume, setup date, image, notes                        | Local storage/database |
| Inhabitants             | inhabitant ID, aquarium ID, species/name, category, quantity                          | Local storage/database |
| Maintenance Tasks       | task ID, aquarium ID(s), task name, category, due date, recurrence, completion status | Local storage/database |
| Water Parameter Records | record ID, aquarium ID, parameter type, measured value, unit, date/time recorded      | Local storage/database |
| Parameter Settings      | aquarium ID, enabled parameters, recommended minimum/maximum values                   | Local storage/database |

## Screens

The app has three main navigation sections: **Home, Parameters, and Care**. Other screens are accessed by branching from these main sections.

1. **Home Dashboard**
   The main overview of the app. The user can see the number of aquariums, inhabitants, tasks due today, parameter alerts, recent water changes/dosing, and their aquarium cards. The user can click an aquarium to open its details or use **+ Add** to add an aquarium.

2. **Aquarium Details**
   Shows information about a selected aquarium, including its tank type, volume, age, and inhabitants. The user can edit aquarium details, add or manage inhabitants, and view information specific to that aquarium.

3. **Parameters**
   The user can view water parameters for their aquariums and switch between tanks from the top of the screen. It shows current measurements and alerts when a parameter is outside its recommended range. The user can also log new measurements or change which parameters are displayed.

4. **Care**
   The main task management screen. The user can view aquarium maintenance tasks using **List, Week, Calendar,** and **History** views, sort tasks by aquarium, and see overdue, due today, and upcoming tasks. The user can create one-time or recurring tasks and assign them to one or more aquariums.

## Risks, revised

* **The risk I named last time:** The external fish species database/API is still a risk, but it has become smaller because it is now a stretch goal rather than a requirement for the MVP. The core app will allow users to manually enter species names, so Vivari will still work if the external API cannot be completed.

  * **First step to reduce it:** Research and test one suitable fish species API by making a simple species search request and displaying the returned suggestions.

* **A new risk:** The local data storage/database may take more time than expected because Vivari has several related types of data that need to be saved and retrieved correctly.

  * **First step to reduce it:** Test saving and retrieving one sample aquarium and its related information before implementing the complete data structure.

* **Another possible risk:** The parameter graphs may take longer than expected because they require the recorded measurements to be organized correctly before displaying them.

  * **First step to reduce it:** Keep the graphs as a stretch goal and only begin them after the main MVP features are working.

## What changed, and why

| Section                  | Prelim said                                                                 | Now says                                                                  | Why it changed                                                                                                                                                                                                |
| ------------------------ | --------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Core features            | Aquarium Management, Maintenance Task Manager, and Water Parameter Tracking | Same three features remain in the MVP                                     | These features directly address the original problem and are the main functions needed for Vivari.                                                                                                            |
| Water Parameter Tracking | Record parameters, display graphs, and show alerts                          | Record parameters and show alerts; graphs moved to Stretch Goal           | Graphs are useful for viewing trends, but they are not necessary for recording measurements or identifying values outside the recommended range. Moving them to a stretch goal keeps the MVP more manageable. |
| Fish Species Database    | External fish species database/API identified as a major risk               | Moved to Stretch Goal: Fish Species Smart Search                          | The app can still allow manual species entry, so the core aquarium management feature does not depend on an external API.                                                                                     |
| Stretch Goals            | Photo Gallery and Dosing/Fertilizer Calculator                              | Water Parameter Graphs, Fish Species Smart Search, and Notifications      | The stretch goals were changed to features that better match the current Vivari design and can be added if there is enough time.                                                                              |
| Notifications            | Not included                                                                | Added as a Stretch Goal                                                   | Notifications would make recurring maintenance more convenient, but the main task manager can still work without them.                                                                                        |
| Data Storage             | No specific storage solution                                                | Local storage/database                                                    | Vivari does not require different users to share the same aquarium data. Local storage is enough for a personal aquarium management app and avoids the additional work of a server.                           |
| Shared Account           | Not included                                                                | Not part of the MVP                                                       | Shared access would require a server, authentication, and synchronization, which are not necessary for the core purpose of Vivari.                                                                            |
| Risk                     | External fish species API                                                   | API remains a smaller risk; local data storage becomes a development risk | The fish API is now optional, while the local data structure still needs to be tested and implemented.                                                                                                        |
| Development estimates    | No estimates                                                                | Approximately 28 hours for the MVP                                        | The estimate was adjusted based on the reduced scope and the decision not to include a server or cloud database.                                                                                              |
| Web compatibility        | Not specifically considered                                                 | Web support will be tested before the final version                       | The extending-your-app unit uses Flutter web, so the complete app and local data storage still need to be tested in the browser.                                                                              |
Paste in the proposal you submitted, and replace it with the final version when
the project is done. You do not need to keep it in sync week to week: nobody
reads this folder until you hand the project in.

Keep these headings so a reader can scan it:

## The problem, in one sentence
## Who it is for
## Core features
## Out of scope, and why
## Data the app remembers, and where it is saved
## Risks
## Changes since the last version

_(A few dated lines saying what changed and why. Worth writing even if you only
do it two or three times: it is the part that shows judgement.)_