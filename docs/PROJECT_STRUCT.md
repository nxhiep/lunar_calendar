lunar_calendar/
├── lib/
│   ├── lunar_calendar.dart              # File export chính
│   └── src/
│       ├── models/
│       │   ├── lunar_date.dart          # Model LunarDate
│       │   ├── lunar_event.dart         # Model LunarEvent
│       │   └── calendar_view.dart       # Enum CalendarView
│       │
│       ├── widgets/
│       │   ├── lunar_calendar.dart      # Widget LunarCalendar chính
│       │   ├── calendar_header.dart     # Widget CalendarHeader
│       │   ├── day_cell.dart           # Widget DayCell
│       │   └── event_dialog.dart        # Dialog thêm/sửa sự kiện
│       │
│       ├── theme/
│       │   └── lunar_calendar_theme.dart # Class LunarCalendarTheme
│       │
│       ├── localization/
│       │   └── lunar_calendar_localization.dart # Hỗ trợ đa ngôn ngữ
│       │
│       └── utils/
│           ├── lunar_utils.dart         # Các tiện ích chuyển đổi âm-dương
│           ├── date_utils.dart          # Tiện ích xử lý ngày tháng
│           └── event_utils.dart         # Tiện ích xử lý sự kiện
│
├── example/
│   ├── lib/
│   │   └── main.dart                    # Demo app
│   └── pubspec.yaml
│
├── test/
│   ├── models/
│   │   ├── lunar_date_test.dart
│   │   └── lunar_event_test.dart
│   ├── widgets/
│   │   ├── lunar_calendar_test.dart
│   │   └── day_cell_test.dart
│   └── utils/
│       └── lunar_utils_test.dart
│
├── docs/
│   ├── API.md                          # Tài liệu API
│   └── CONTRIBUTING.md                 # Hướng dẫn đóng góp
│
├── .gitignore
├── CHANGELOG.md
├── LICENSE
├── README.md
└── pubspec.yaml