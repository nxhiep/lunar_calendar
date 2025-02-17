# Lunar Calendar API Documentation

## Widgets

### LunarCalendar

Widget chính để hiển thị lịch âm dương.

```dart
LunarCalendar({
  Key? key,
  DateTime? initialDate,
  CalendarView initialView = CalendarView.month,
  LunarCalendarTheme? theme,
  List<LunarEvent>? events,
  bool showLunarDates = true,
  bool showHolidays = true,
  bool enableMultiSelection = false,
  Function(DateTime)? onDateSelected,
  Function(List<DateTime>)? onMultiDateSelected,
  Function(DateTime)? onMonthChanged,
  LunarCalendarLocalization? localization,
})
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| initialDate | DateTime? | Ngày khởi tạo ban đầu. Mặc định là ngày hiện tại |
| initialView | CalendarView | Chế độ xem ban đầu (tháng/năm). Mặc định là tháng |
| theme | LunarCalendarTheme? | Theme tùy chỉnh cho calendar |
| events | List<LunarEvent>? | Danh sách các sự kiện cần hiển thị |
| showLunarDates | bool | Hiển thị ngày âm lịch. Mặc định là true |
| showHolidays | bool | Hiển thị ngày lễ. Mặc định là true |
| enableMultiSelection | bool | Cho phép chọn nhiều ngày. Mặc định là false |
| onDateSelected | Function(DateTime)? | Callback khi chọn một ngày |
| onMultiDateSelected | Function(List<DateTime>)? | Callback khi chọn nhiều ngày |
| onMonthChanged | Function(DateTime)? | Callback khi thay đổi tháng |
| localization | LunarCalendarLocalization? | Cấu hình ngôn ngữ. Mặc định là tiếng Việt |

### CalendarHeader

Widget hiển thị phần header của lịch với tháng/năm và nút điều hướng.

```dart
CalendarHeader({
  required DateTime currentDate,
  required Function() onPrevious,
  required Function() onNext,
  CalendarView view = CalendarView.month,
  Function()? onViewChanged,
})
```

### DayCell

Widget hiển thị một ô ngày trong lịch.

```dart
DayCell({
  required DateTime date,
  required LunarDate lunarDate,
  bool isSelected = false,
  bool isToday = false,
  bool isHoliday = false,
  bool isWeekend = false,
  List<LunarEvent>? events,
  Function()? onTap,
})
```

## Models

### LunarDate

Model biểu diễn ngày âm lịch.

```dart
class LunarDate {
  final int day;
  final int month;
  final int year;
  final String? canChi;
  final bool isLeapMonth;

  LunarDate({
    required this.day,
    required this.month,
    required this.year,
    this.canChi,
    this.isLeapMonth = false,
  });

  // Chuyển đổi từ dương lịch sang âm lịch
  static LunarDate fromSolar(DateTime solarDate);

  // Chuyển đổi từ âm lịch sang dương lịch
  DateTime toSolar();
}
```

### LunarEvent

Model biểu diễn sự kiện trong lịch.

```dart
class LunarEvent {
  final String title;
  final String? description;
  final LunarDate? lunarDate;
  final DateTime? solarDate;
  final bool isYearlyRecurring;
  final bool isMonthlyRecurring;
  final Color? color;
  final DateTime? reminder;

  LunarEvent({
    required this.title,
    this.description,
    this.lunarDate,
    this.solarDate,
    this.isYearlyRecurring = false,
    this.isMonthlyRecurring = false,
    this.color,
    this.reminder,
  });
}
```

### LunarCalendarTheme

Class để tùy chỉnh giao diện của calendar.

```dart
class LunarCalendarTheme {
  final Color primaryColor;
  final Color selectedDayColor;
  final Color todayColor;
  final TextStyle weekdayTextStyle;
  final TextStyle weekendTextStyle;
  final TextStyle holidayTextStyle;
  final TextStyle lunarDateTextStyle;
  final TextStyle solarDateTextStyle;
  final BoxDecoration? dayCellDecoration;
  final BoxDecoration? selectedDayCellDecoration;

  LunarCalendarTheme({
    this.primaryColor = Colors.blue,
    this.selectedDayColor = Colors.blue,
    this.todayColor = Colors.red,
    this.weekdayTextStyle = const TextStyle(),
    this.weekendTextStyle = const TextStyle(color: Colors.red),
    this.holidayTextStyle = const TextStyle(color: Colors.red),
    this.lunarDateTextStyle = const TextStyle(fontSize: 11),
    this.solarDateTextStyle = const TextStyle(fontSize: 14),
    this.dayCellDecoration,
    this.selectedDayCellDecoration,
  });
}
```

### LunarCalendarLocalization

Class để hỗ trợ đa ngôn ngữ cho calendar.

```dart
class LunarCalendarLocalization {
  final String locale;
  final Map<String, String> translations;

  const LunarCalendarLocalization({
    required this.locale,
    required this.translations,
  });

  // Ngôn ngữ tiếng Việt (mặc định)
  static const vi = LunarCalendarLocalization(
    locale: 'vi',
    translations: {
      'month': 'Tháng',
      'year': 'Năm',
      // ... other Vietnamese translations
    },
  );

  // Ngôn ngữ tiếng Anh
  static const en = LunarCalendarLocalization(
    locale: 'en',
    translations: {
      'month': 'Month',
      'year': 'Year',
      // ... other English translations
    },
  );

  String get(String key) => translations[key] ?? key;
}
```

## Enums

### CalendarView

```dart
enum CalendarView {
  month,
  year
}
```

## Utilities

### LunarUtils

Class chứa các phương thức tiện ích để làm việc với lịch âm.

```dart
class LunarUtils {
  // Chuyển đổi ngày dương lịch sang âm lịch
  static LunarDate solarToLunar(DateTime solarDate);

  // Chuyển đổi ngày âm lịch sang dương lịch
  static DateTime lunarToSolar(LunarDate lunarDate);

  // Lấy can chi của năm
  static String getYearCanChi(int year);

  // Lấy can chi của ngày
  static String getDayCanChi(DateTime date);

  // Kiểm tra ngày hoàng đạo
  static bool isGoodDay(DateTime date);

  // Lấy danh sách các giờ hoàng đạo trong ngày
  static List<String> getGoodHours(DateTime date);
}
```

## Ví dụ

### Khởi tạo calendar với đầy đủ tính năng

```dart
LunarCalendar(
  initialDate: DateTime.now(),
  theme: LunarCalendarTheme(
    primaryColor: Colors.red,
    selectedDayColor: Colors.blue,
    holidayTextStyle: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
    ),
  ),
  events: [
    LunarEvent(
      title: 'Tết Nguyên Đán',
      lunarDate: LunarDate(day: 1, month: 1, year: 2024),
      isYearlyRecurring: true,
      color: Colors.red,
    ),
    LunarEvent(
      title: 'Rằm tháng Giêng',
      lunarDate: LunarDate(day: 15, month: 1, year: 2024),
      isYearlyRecurring: true,
    ),
  ],
  showLunarDates: true,
  showHolidays: true,
  enableMultiSelection: true,
  onDateSelected: (date) {
    print('Selected date: $date');
  },
  onMonthChanged: (date) {
    print('Month changed to: ${date.month}/${date.year}');
  },
)
```

## Xử lý sự kiện

### Thêm sự kiện mới

```dart
void addEvent(LunarEvent event) {
  setState(() {
    events.add(event);
  });
}
```

### Xóa sự kiện

```dart
void removeEvent(LunarEvent event) {
  setState(() {
    events.remove(event);
  });
}
```

### Lưu và đọc sự kiện

```dart
// Lưu sự kiện
Future<void> saveEvents() async {
  final prefs = await SharedPreferences.getInstance();
  final eventsJson = events.map((e) => e.toJson()).toList();
  await prefs.setString('events', jsonEncode(eventsJson));
}

// Đọc sự kiện
Future<void> loadEvents() async {
  final prefs = await SharedPreferences.getInstance();
  final eventsJson = prefs.getString('events');
  if (eventsJson != null) {
    final List<dynamic> decoded = jsonDecode(eventsJson);
    setState(() {
      events = decoded.map((e) => LunarEvent.fromJson(e)).toList();
    });
  }
}
```

### Ví dụ sử dụng đa ngôn ngữ

```dart
// Sử dụng tiếng Việt (mặc định)
LunarCalendar(
  initialDate: DateTime.now(),
  localization: LunarCalendarLocalization.vi,
)

// Sử dụng tiếng Anh
LunarCalendar(
  initialDate: DateTime.now(),
  localization: LunarCalendarLocalization.en,
)

// Tùy chỉnh ngôn ngữ khác
LunarCalendar(
  initialDate: DateTime.now(),
  localization: LunarCalendarLocalization(
    locale: 'fr',
    translations: {
      'month': 'Mois',
      'year': 'Année',
      'monday': 'Lun',
      'tuesday': 'Mar',
      // ... other translations
    },
  ),
)
```

### Danh sách các key translation có sẵn

| Key | Mô tả |
|-----|--------|
| month | Tên tháng |
| year | Tên năm |
| monday | Thứ hai |
| tuesday | Thứ ba |
| wednesday | Thứ tư |
| thursday | Thứ năm |
| friday | Thứ sáu |
| saturday | Thứ bảy |
| sunday | Chủ nhật |
| lunar | Âm lịch |
| solar | Dương lịch |
| today | Hôm nay |
| good_day | Ngày hoàng đạo |
| bad_day | Ngày hắc đạo |
| new_event | Sự kiện mới |
| edit_event | Sửa sự kiện |
| delete_event | Xóa sự kiện |
| event_title | Tên sự kiện |
| event_description | Mô tả sự kiện |
| save | Lưu |
| cancel | Hủy |
| confirm_delete | Xác nhận xóa |
| yearly_recurring | Lặp lại hàng năm |
| monthly_recurring | Lặp lại hàng tháng |
| set_reminder | Đặt nhắc nhở | 