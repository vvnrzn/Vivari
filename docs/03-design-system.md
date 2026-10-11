# Design system

## Visual reference

![Vivari design system](assets/PROJECT/DESIGN%20SYSTEM.png)

## Palette

The interface uses a dark, aquarium-inspired palette. These colors are defined
in [`app_theme.dart`](../lib/theme/app_theme.dart).

| Role | Hex | Use |
| --- | --- | --- |
| Background | `#0E1718` | Screen canvas |
| Surface | `#172526` | Cards, sheets, and dialogs |
| Secondary | `#213536` | Container fills and subtle highlights |
| Primary | `#4F9D92` | Main actions, active states, and navigation |
| Positive | `#8BAF8A` | Success and in-range status |
| Warning | `#C59B52` | Pending tasks and due-today status |
| Error | `#B85C50` | Overdue tasks and out-of-range status |
| Text (primary) | `#E6EEEE` | Headings and primary text |
| Text (muted) | `#A7B9BA` | Captions, subtitles, and hints |
| Border | `#304344` | Card outlines and dividers |

## Type scale

| Style | Font | Size | Weight | Use |
| --- | --- | --- | --- | --- |
| Heading | Space Grotesk | 24 px | Bold (700) | Screen titles and detail headings |
| Body | DM Sans | 16 px | Regular (400) | Main content, task titles, and inputs |
| Caption | DM Sans | 12 px | Regular (400) | Supporting labels, metadata, and badges |
| Numeric display | DM Mono | 24 px | Bold (700) | Prominent parameter values |

## Spacing

Spacing values are defined by `AppSpacing` in
[`app_theme.dart`](../lib/theme/app_theme.dart).

| Use | Value |
| --- | --- |
| Base unit and related-item gap | 8 px |
| Gap between sections | 16 px |
| Screen edge padding | 24 px |

## Components

| Component | Implementation | Design behavior |
| --- | --- | --- |
| Primary and secondary buttons | Flutter Material buttons styled in `app_theme.dart` | Teal filled primary action; outlined or text treatment for secondary actions |
| Floating add button | [`vivari_add_button.dart`](../lib/widgets/vivari_add_button.dart) | Rounded floating action button for adding items |
| Bottom navigation | [`vivari_bottom_navigation.dart`](../lib/widgets/vivari_bottom_navigation.dart) | Parameters, Home, and Care destinations; teal active state |
| Cards | [`vivari_card.dart`](../lib/widgets/vivari_card.dart) and `CardTheme` in `app_theme.dart` | Surface-colored containers with subtle borders and rounded corners |
| Summary card | [`summary_card.dart`](../lib/widgets/summary_card.dart) | Dashboard metric with a concise label and value |
| Empty state | [`empty_state.dart`](../lib/widgets/empty_state.dart) | Guidance shown when a screen has no content |
| Aquarium multi-select sheet | [`aquarium_multi_select_sheet.dart`](../lib/widgets/aquarium_multi_select_sheet.dart) | Select aquariums when filtering or associating care tasks |
| Status badges and parameter cards | Screen-specific widgets | Positive, warning, and error colors communicate parameter and task status |
