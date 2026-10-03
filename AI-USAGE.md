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

### 2026-10-01
- **Tool:** Codex
- **What I asked for:** I requested the creation of a three-view Parameters section, including a base dashboard, a detailed chart screen limited to week and month views, and a draggable settings modal. I specifically asked to implement a horizontal tank scroller without an "All Tanks" option, reusable status badges indicating if values are within or outside target ranges, and the ability to toggle a comprehensive list of additional water parameters. Finally, I directed the assistant to include a range customization pop-up accessible from the settings list to easily define the minimum and maximum optimal values for any parameter.
- **What it gave back:** provided the correct navigational flow and functional logic, but it failed to maintain consistent UI styling, particularly regarding the border radius of the pill buttons. The generated code also resulted in a RenderFlex overflow error, indicating layout constraints were not handled properly. Additionally, the Parameter Details screen lacked proper top padding or safe area implementation.
- **What I kept, what I changed, and why:** I made several UI adjustments to fix layouts and improve consistency. To resolve the RenderFlex overflows, I removed the "-" prefix from the "no readings" badge to save space (especially critical on the chart screens). I also implemented text truncation (adding "...") for lengthy aquarium names across the Parameters, Care, and Home dashboard screens to prevent the text from cramping the UI or wrapping awkwardly. Finally, to ensure visual consistency with the app's theme, I added SafeArea boundaries to fix the notch overlap, made the customize parameter settings button thinner, and updated the active toggle button colors to match the app's specific palette instead of using the default bright green.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/4cdd5bbc6574139cd5f19dc6ce39e199845e0427

### -- 
- **Tool:** 
- **What I asked for:**
- **What it gave back:** 
- **What I kept, what I changed, and why:** 
- **Commit:** 

### -- 
- **Tool:** 
- **What I asked for:**
- **What it gave back:** 
- **What I kept, what I changed, and why:** 
- **Commit:** 

### -- 
- **Tool:** 
- **What I asked for:**
- **What it gave back:** 
- **What I kept, what I changed, and why:** 
- **Commit:** 

## 2. Where the AI got it wrong

### Case 1 - Care screen layout overflow

- **What it gave me:** Copilot generated a Care screen with multiple views, but the layout displayed them incorrectly: one view was squeezed and part of the Week view peeked in from the right. The screen also produced vertical RenderFlex overflow errors, with content extending beyond the available space.
- **What was wrong with it:** The Care screen’s layout did not fit the available space. One view was squeezed, while part of the Week view appeared at the right edge. The fixed vertical layout also overflowed the screen, making content extend beyond the visible area and triggering several RenderFlex overflow errors.
- **What I did instead:** I would simplify the layout so only the selected view is shown at a time, check that the view switcher fits within the screen width, and make the care content scrollable. I would then run the screen at different device sizes and confirm that all views display without overflow.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/46f392df8454d23a707e489f82c7b0fdd2a1a85f

### Case 2 - PARAMETER CHARTS/GRAPHS

- **What it gave me:**  It built a custom parameter chart with Week and Month views. It filters the saved measurements to the selected aquarium and time period, plots values over time, and displays measurement-range values on the vertical axis. It also updates the latest reading, average, and status badge based on the logged data.
- **What was wrong with it:** The chart positioned readings according to their measurement dates, but did not display date labels on the horizontal (x) axis. This made it difficult to tell when readings were taken or interpret the trend over the selected week or month.
- **What I did instead:** I connected the chart to the saved parameter readings and added status and average calculations, and the graph with x-axis date labels. It now shows suitable dates along the bottom of the chart—for example, days of the week in Week view and dates or weekly intervals in Month view.
- **Commit:**

### Case 3 -

- **What it gave me:** 
- **What was wrong with it:** 
- **What I did instead:** 


## 3. Who wrote what

At least a fifth of this project is code you wrote yourself. Name it, and explain
it in your own words.

### Written by me

- **File:**
- **Commit:**
- **What it does and why it is built this way:**

### The AI-written part I understand best

- **File:**
- **Commit:**
- **What it does and why we kept it:**