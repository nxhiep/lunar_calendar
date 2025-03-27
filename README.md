# Lunar Calendar Plus

A Flutter package that supports lunar-solar calendar with date display and event management features.

![demo image from docs](https://raw.githubusercontent.com/Nghi-NV/lunar_calendar/refs/heads/main/docs/images/demo.png)

## Features

### 1. Calendar Display
- Displays both lunar and solar dates simultaneously
- Monthly view mode
- Navigate between months using buttons or swipe gestures
- Highlight current day
- Option to show/hide dates from other months
- Button to return to current date

### 2. Event Management
- Display events for selected dates
- Supports multiple event types with intuitive icons:
  - Birthday (🎂)
  - Meeting (👥)
  - Holiday (🎉)
  - Reminder (🔔)
  - Task (✓)
  - Anniversary (❤️)
- Supports both lunar and solar dates
- Option for yearly or monthly recurring events

### 3. Date Picker Widget
- LunarCalendarPicker widget for easy date selection
- Supports display in lunar or solar date format
- Customizable text and icon display
- Integrated bottom sheet picker

## Installation

Add this to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  lunar_calendar_plus: ^1.0.0
```

## Usage

### Basic Calendar Widget Initialization

```dart
LunarCalendar(
  onDateSelected: (solarDate, lunarDate) {
    print('Solar date: $solarDate');
    print('Lunar date: $lunarDate');
  },
)
```

### Using LunarCalendarPicker

```dart
// Display solar date (default)
LunarCalendarPicker(
  initialSolarDate: DateTime.now(),
  onDateSelected: (solarDate, lunarDate) {
    print('Solar date: $solarDate');
    print('Lunar date: $lunarDate');
  },
);

// Display lunar date
LunarCalendarPicker(
  initialSolarDate: DateTime.now(),
  onDateSelected: (solarDate, lunarDate) {
    print('Solar date: $solarDate');
    print('Lunar date: $lunarDate');
  },
  displayMode: 'lunar',
  showLunarDate: true,
);

// Customize display
LunarCalendarPicker(
  initialSolarDate: DateTime.now(),
  onDateSelected: (solarDate, lunarDate) {
    print('Solar date: $solarDate');
    print('Lunar date: $lunarDate');
  },
  dateText: 'Select date',
  dateFormat: 'dd/MM/yyyy',
  icon: Icons.calendar_today,
  iconColor: Colors.blue,
);
```

### Adding Events

```dart
LunarCalendar(
  events: [
    LunarEvent(
      title: 'Birthday',
      type: 'birthday',
      solarDate: DateTime(2024, 3, 15),
    ),
    LunarEvent(
      title: 'Grandfather\'s Death Anniversary',
      type: 'anniversary',
      lunarDate: LunarDate(day: 15, month: 7, year: 2024),
      isYearlyRecurring: true,
    ),
  ],
)
```

### Customizing Interface

```dart
LunarCalendar(
  theme: LunarCalendarTheme(
    primaryColor: Colors.blue,
    textColor: Colors.black87,
    backgroundColor: Colors.white,
    sundayColor: Colors.red,
    saturdayColor: Colors.blue,
  ),
  showOutsideDays: false,
  showTodayButton: true,
  maxWidth: 400,
)
```

## API Reference

### LunarCalendar
| Property | Type | Description |
|----------|------|-------------|
| theme | LunarCalendarTheme? | Custom theme for calendar |
| localization | LunarCalendarLocalization? | Language configuration |
| onDateSelected | Function(DateTime, LunarDate)? | Callback when date is selected |
| showOutsideDays | bool? | Show dates from other months |
| events | List<LunarEvent> | List of events |
| maxWidth | double? | Maximum width of calendar |
| showTodayButton | bool | Show Today button |

### LunarCalendarPicker
| Property | Type | Description |
|----------|------|-------------|
| initialSolarDate | DateTime | Initial solar date |
| onDateSelected | Function(DateTime, LunarDate) | Callback when date is selected |
| theme | LunarCalendarTheme? | Custom theme |
| localization | LunarCalendarLocalization? | Language configuration |
| showLunarDate | bool | Show lunar date |
| dateFormat | String? | Date display format |
| textStyle | TextStyle? | Style for text |
| icon | IconData? | Display icon |
| iconColor | Color? | Icon color |
| iconSpacing | double | Space between icon and text |
| dateText | String? | Text to display instead of date |
| displayMode | String | Display mode ('solar' or 'lunar') |

### LunarEvent
| Property | Type | Description |
|----------|------|-------------|
| title | String | Event title |
| description | String? | Event description |
| type | String? | Event type (birthday, meeting, holiday, reminder, task, anniversary) |
| lunarDate | LunarDate? | Lunar date |
| solarDate | DateTime? | Solar date |
| isYearlyRecurring | bool | Yearly recurring |
| isMonthlyRecurring | bool | Monthly recurring |
| color | Color? | Event color |

## License

This package is released under the [MIT license](LICENSE).
