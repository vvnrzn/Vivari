# AI usage

## 1. How I used AI

### 2026-09-23 Built initial home screen dashboard
- **Tool:** Copilot
- **What I asked for:** Create the base structure for the home dashboard as well as the other three main screens: Aquarium Details, Parameters, and Care. I also want to make sure the main navigation between Home, Parameters, and Care is working so I have a clear foundation for building the rest of the app.
- **What it gave back:** It generated the initial Home Dashboard layout and placeholder screens for Aquarium Details, Parameters, and Care. It also set up navigation between Home, Parameters, and Care. The first version did not include empty states, so I added those myself.
- **What I kept, what I changed, and why:** Reworked the Home Dashboard by removing the Settings and Notifications buttons and extra heading, then arranging the summaries into a two-column aquarium and inhabitant row, a tappable Tasks Due Today card that opens Care, and a split card for the latest water change and dosing. All data remains empty, while the Add Aquarium button and bottom navigation remain functional.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/7dbb54ce0ecb2e5ad26827846021b852627e323f

### 2026-09-30 Construct care screen activity log and task creation
- **Tool:** Copilot
- **What I asked for:** Add an activity logging flow and the basic task creation flow, then connect the saved information to the Home dashboard and Care screen views.
- **What it gave back:** The assistant delivered modular Flutter source files—including care_screen.dart, log_activity_screen.dart, add_task_screen.dart, home_dashboard.dart, and care_record.dart—complete with state wiring, recurring schedule tabs, calendar grids, unit selection modals, and dashboard synchronization.
- **What I kept, what I changed, and why:** I kept the core architecture and cross-screen state binding because they successfully connected dashboard metrics and care schedules, but I modified specific UI and logic elements like enabling multi-select pre-made activities, stripping redundant category inputs, restyling calendar highlights into soft rounded squares with capped indicator dots, and adding dynamic tank filter generation to ensure a cleaner, highly intuitive user experience.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/158c8c31ababb4981daa3b094c9c470447c00988

### 2026-10-01 Parameter setting configuration
- **Tool:** Codex
- **What I asked for:** I requested the creation of a three-view Parameters section, including a base dashboard, a detailed chart screen limited to week and month views, and a draggable settings modal. I specifically asked to implement a horizontal tank scroller without an "All Tanks" option, reusable status badges indicating if values are within or outside target ranges, and the ability to toggle a comprehensive list of additional water parameters. Finally, I directed the assistant to include a range customization pop-up accessible from the settings list to easily define the minimum and maximum optimal values for any parameter.
- **What it gave back:** provided the correct navigational flow and functional logic, but it failed to maintain consistent UI styling, particularly regarding the border radius of the pill buttons. The generated code also resulted in a RenderFlex overflow error, indicating layout constraints were not handled properly. Additionally, the Parameter Details screen lacked proper top padding or safe area implementation.
- **What I kept, what I changed, and why:** I made several UI adjustments to fix layouts and improve consistency. To resolve the RenderFlex overflows, I removed the "-" prefix from the "no readings" badge to save space (especially critical on the chart screens). I also implemented text truncation (adding "...") for lengthy aquarium names across the Parameters, Care, and Home dashboard screens to prevent the text from cramping the UI or wrapping awkwardly. Finally, to ensure visual consistency with the app's theme, I added SafeArea boundaries to fix the notch overlap, made the customize parameter settings button thinner, and updated the active toggle button colors to match the app's specific palette instead of using the default bright green.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/4cdd5bbc6574139cd5f19dc6ce39e199845e0427

### 2026-10-04 Parameter Logging & Care Sync
- **Tool:** Copilot
- **What I asked for:** I requested the implementation of the Log Parameter screen based on the provided reference design, ensuring that newly logged readings immediately updated the Care screen history, updated the weekly and monthly chart views, and dynamically recalculated parameter status badges using a warning color for both above- and below-range values. 
- **What it gave back:** Parameter logging interface with form controls for selecting parameters, entering values, and picking measurement dates and times, while correctly inheriting the active aquarium context. It successfully wired the backend logic so logged readings updated the parameter list, populated the Care history tab, and rendered visual data points on the Week and Month charts with calculated averages and out-of-range status warnings.
- **What I kept, what I changed, and why:** I kept the primary logging flow, date/time picking, and cross-screen state updates because the data propagation to the charts and Care history functioned smoothly. However, I made several UI and logic refinements to clean up the user experience. I removed redundant action buttons (such as the extraneous "Done" button when "Log Parameter" already submitted the form) to reduce visual clutter, added missing parameter units next to raw numbers on the main Parameters page for visual clarity, and filtered the parameter dropdown in the Log Parameters screen so it strictly displays parameters currently toggled ON in the settings.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/a03ed00093cf9847636f291af0b628d77c61f480

### 2026-10-04 Home Dashboard tests
- **Tool:** Copilot
- **What I asked for:**  I requested updates to the Home Dashboard widgets so that the last water change and dosing display relative dates (e.g., "Today" or "{no.} days ago") instead of full dates, accompanied by a smaller caption with an ellipsis rule for long names, a bullet separator, and the corresponding amount and unit on the right. I also asked to add a warning-colored pending task count badge to the left of the water type on aquarium cards that only appears when pending tasks exist (>0) and is completely omitted if zero, along with corresponding widget test coverage.
- **What it gave back:**  Aside from the dashboard changes itself, The assistant implemented the dashboard logic and delivered modular widget test suites—specifically validating that latest activities show relative dates with compact details, that aquarium cards display a count-only pending badge when needed, and that the badge is successfully omitted when the pending count is zero.
- **What I kept, what I changed, and why:** I kept the relative date formatting, conditional pending badge logic, and test cases because they provided a solid foundation for the dashboard update. However, I made several UI and state refinements: I ensured both lines of text align properly when data exists in the last water change/dosing views, prepended the tank name to the amount and unit, left-aligned this text block to eliminate awkward spacing for shorter names, matched the relative date font size to the "no tasks due today" label.
- **Commit:**  https://github.com/vvnrzn/Vivari/commit/d0c53bfcd214f3bd751f1bb34ae16f0c022ab8d6

### 2026-10-04 Add Inhabitant Catalog
- **Tool:**  Copilot
- **What I asked for:** Implement "Add Inhabitant" screen with smart keyword search. Since there is no API currently, create a local inhabitants.json mock file with at least 20 records per water type (saltwater and freshwater), explicitly including the GloFish Tetra and Betta Fish. The inhabitant cards should display the common name, muted scientific name, and a combined badge formatted as [Water Type][Inhabitant Type] (omitting size details).reference
- **What it gave back:** Added an image-free catalog screen with smart search across common names, scientific names, and keywords, plus category filters and multi-select. Added inhabitants.json: 140 records, with 20 per water-type/category combination. Freshwater and saltwater catalogs include fish, inverts, and plants; saltwater also includes corals.
- **What I kept, what I changed, and why:** I kept The core search filtering logic, category pill navigation, custom badge formatting, and the entire inhabitants.json local dataset structure, but I updated the state management so that adding or removing inhabitants dynamically recalculates and updates the global Total Inhabitants count on the Home Dashboard.
- **Commit:** https://github.com/vvnrzn/Vivari/fd9d63c8ec2440887aac86480b12bea5fa592a1d

## 2. Where the AI got it wrong

### Case 1 - CARE SCREEN SEPARATE VIEWS OVERFLOW

- **What it gave me:** Copilot generated a Care screen with multiple views, but the layout displayed them incorrectly: one view was squeezed and part of the Week view peeked in from the right. The screen also produced vertical RenderFlex overflow errors, with content extending beyond the available space.
- **What was wrong with it:** The Care screen’s layout did not fit the available space. One view was squeezed, while part of the Week view appeared at the right edge. The fixed vertical layout also overflowed the screen, making content extend beyond the visible area and triggering several RenderFlex overflow errors.
- **What I did instead:** I would simplify the layout so only the selected view is shown at a time, check that the view switcher fits within the screen width, and make the care content scrollable. I would then run the screen at different device sizes and confirm that all views display without overflow.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/46f392df8454d23a707e489f82c7b0fdd2a1a85f

### Case 2 - PARAMETER CHARTS/GRAPHS

- **What it gave me:**  It built a custom parameter chart with Week and Month views. It filters the saved measurements to the selected aquarium and time period, plots values over time, and displays measurement-range values on the vertical axis. It also updates the latest reading, average, and status badge based on the logged data.
- **What was wrong with it:** The chart positioned readings according to their measurement dates, but did not display date labels on the horizontal (x) axis. This made it difficult to tell when readings were taken or interpret the trend over the selected week or month.
- **What I did instead:** I connected the chart to the saved parameter readings and added status and average calculations, and the graph with x-axis date labels. It now shows suitable dates along the bottom of the chart—for example, days of the week in Week view and dates or weekly intervals in Month view.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/b5157c580c1b2ae54e6c2e61a6ef99051d751761

### Case 3 - Care tank filter

- **What it gave me:** Copilot updated the Care screen’s aquarium filter to scroll horizontally and added a test for accessing additional tanks.
- **What was wrong with it:** The filter still didn’t scroll reliably in the app, and the bottom of the pills was clipped. The visible scrollbar also wasn’t wanted.
- **What I did instead:** I asked fixed the interaction and layout by adding horizontal drag and wheel scrolling, adjusted the filter’s height and padding to prevent clipping, and hid the scrollbar while keeping scrolling available. I verified the fix with widget tests.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/4a0411f4ec99a1fc69a20faf8b890f2ac56e6387


## 3. Who wrote what

### Written by me

- **File:** aquarium.dart, care_record.dart, water_reading.dart, and app_theme.dart
- **Commit:**
- **What it does and why it is built this way:** I used the model files to describe the information my app works with, such as aquariums, care tasks, activities, and water readings. Keeping this information in separate classes makes it easier for the app to pass it between screens and work with it consistently. I also made a central app theme for the shared colors, text styles, spacing, and common widget styles, so the screens look like they belong to the same app.

### The AI-written part I understand best

- **File:** `aquarium_multi_select_sheet.dart`, `empty_state.dart`, `summary_card.dart`, `vivari_add_button.dart`, `vivari_bottom_navigation.dart`, and `vivari_card.dart` in the `widgets` folder
- **Commit:**
- **What it does and why we kept it:** These files contain reusable parts of the app's interface. They let the app show a consistent card, summary, empty state, add button, bottom navigation, and a sheet for selecting aquariums. We kept them as separate widgets so screens can reuse the same interface elements instead of repeating the same layout code, which makes the app easier to keep consistent and update.