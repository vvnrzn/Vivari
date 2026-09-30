# AI usage

This project was built with AI assistance. This file is the record of it. It is
graded as the finals badge, and it is worth 100 points.

Start it in week 1 and keep it up as you go. The commit history of this file is
part of the evidence: a file written all at once the night before the deadline
looks exactly like what it is.

## 1. How I used AI

At least six entries. One per real use. Every entry needs a commit link.

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

### -- 
- **Tool:** 
- **What I asked for:**
- **What it gave back:** 
- **What I kept, what I changed, and why:** 
- **Commit:** 

## 2. Where the AI got it wrong

Three cases. Be specific. If you write that the AI was never wrong, this section
scores zero.

### Case 1 - Care screen layout overflow

- **What it gave me:** Copilot generated a Care screen with multiple views, but the layout displayed them incorrectly: one view was squeezed and part of the Week view peeked in from the right. The screen also produced vertical RenderFlex overflow errors, with content extending beyond the available space.
- **What was wrong with it:** The Care screen’s layout did not fit the available space. One view was squeezed, while part of the Week view appeared at the right edge. The fixed vertical layout also overflowed the screen, making content extend beyond the visible area and triggering several RenderFlex overflow errors.
- **What I did instead:** I would simplify the layout so only the selected view is shown at a time, check that the view switcher fits within the screen width, and make the care content scrollable. I would then run the screen at different device sizes and confirm that all views display without overflow.
- **Commit:** https://github.com/vvnrzn/Vivari/commit/46f392df8454d23a707e489f82c7b0fdd2a1a85f

### Case 2 -

- **What it gave me:** 
- **What was wrong with it:** 
- **What I did instead:** 

### Case 3 -

- **What it gave me:** 
- **What was wrong with it:** 
- **What I did instead:** 


## 3. Who wrote what

At least a fifth of this project is code you wrote yourself. Name it, and explain
it in your own words.

> Group projects: give each member their own heading below, and use your GitHub
> handle as the heading. You are graded on your own section.

### Written by me

- **File:**
- **Commit:**
- **What it does and why it is built this way:**

### The AI-written part I understand best

- **File:**
- **Commit:**
- **What it does and why we kept it:**