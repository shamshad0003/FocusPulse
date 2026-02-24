# FocusPulse - Apple Watch Pomodoro & Productivity

FocusPulse is a high-performance, automated Pomodoro timer designed specifically for watchOS. It helps users maintain deep focus and manage work-break cycles directly from their wrist, minimizing smartphone distractions.

## Features

### Core Experience
- Preset Durations: Quickly start sessions with 25, 50, or 90-minute presets.
- Beautiful UI: Circular progress rings and high-contrast typography for readability.
- Haptic Alerts: Distinct haptic feedback for session completions.
- Session History: Local storage of completed sessions using `UserDefaults`.

### Pro Productivity Tools
- Automated Cycles: Seamlessly transition from Focus -> Short Break -> Focus. Every 4th session triggers a Long Break.
- Auto-Cycle Mode: Hands-free timer progression for uninterrupted work blocks.
- Customizable Durations: Set your own focus, short break, and long break times in Settings.
- Daily Goals: Set a daily target for focus sessions and track your progress.
- Analytics Dashboard: Real-time tracking of current streak, daily focus minutes, and weekly hours.
- Smart Reminders: Follow-up notifications if a new session isn't started within 2 minutes.

### Watch Complications
- Support for `accessoryCircular` and `accessoryRectangular` families.
- Quick glance at remaining time, current cycle number, and daily goal progress.

## Tech Stack & Architecture

- Language: Swift 5.0+
- Frameworks: SwiftUI, Combine, WidgetKit, UserNotifications
- Architecture: MVVM (Model-View-ViewModel)
  - Models: Defines data structures for Sessions and Modes.
  - ViewModels: Handles timer logic, state management, and Combine publishers.
  - Services: Specialized managers for Cycles, Analytics, and Notifications.
  - Storage: Centralized persistence layer using `StorageManager`.

##  Project Structure

```text
FocusPulse/
├── FocusPulse Watch App/
│   ├── Models/         # Data structures (SessionMode, FocusSession)
│   ├── ViewModels/     # Business logic (TimerViewModel)
│   ├── Views/          # SwiftUI components (HomeView, AnalyticsView, etc.)
│   ├── Services/       # Managers (CycleManager, AnalyticsManager, NotificationManager)
│   └── Storage/        # Persistence (StorageManager)
└── FocusPulseComplication/  # WidgetKit implementation
```



