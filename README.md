# Lunar Calendar Plus

Package Flutter hỗ trợ lịch âm-dương với tính năng hiển thị ngày và quản lý sự kiện.

![demo image from docs](https://raw.githubusercontent.com/Nghi-NV/lunar_calendar/refs/heads/main/docs/images/demo.png)

## Tính năng

### 1. Hiển thị Lịch
- Hiển thị song song cả ngày âm lịch và dương lịch
- Chế độ xem theo tháng
- Điều hướng giữa các tháng bằng nút hoặc vuốt
- Đánh dấu ngày hiện tại
- Tùy chọn hiển thị/ẩn ngày của tháng khác
- Nút quay về ngày hiện tại

### 2. Quản lý Sự kiện
- Hiển thị sự kiện theo ngày được chọn
- Hỗ trợ nhiều loại sự kiện với biểu tượng trực quan:
  - Sinh nhật (🎂)
  - Cuộc họp (👥)
  - Ngày lễ (🎉)
  - Nhắc nhở (🔔)
  - Công việc (✓)
  - Kỷ niệm (❤️)
- Hỗ trợ cả ngày âm lịch và dương lịch
- Tùy chọn lặp lại sự kiện theo năm hoặc tháng

### 3. Widget Chọn Ngày
- Widget LunarCalendarPicker cho phép chọn ngày dễ dàng
- Hỗ trợ hiển thị theo định dạng âm lịch hoặc dương lịch
- Tùy chỉnh text và icon hiển thị
- Bottom sheet picker tích hợp

## Cài đặt

Thêm dependency vào `pubspec.yaml`:

```yaml
dependencies:
  lunar_calendar_plus: ^1.0.0
```

## Sử dụng

### Khởi tạo Calendar Widget cơ bản

```dart
LunarCalendar(
  onDateSelected: (solarDate, lunarDate) {
    print('Ngày dương: $solarDate');
    print('Ngày âm: $lunarDate');
  },
)
```

### Sử dụng LunarCalendarPicker

```dart
// Hiển thị ngày dương lịch (mặc định)
LunarCalendarPicker(
  initialSolarDate: DateTime.now(),
  onDateSelected: (solarDate, lunarDate) {
    print('Ngày dương: $solarDate');
    print('Ngày âm: $lunarDate');
  },
);

// Hiển thị ngày âm lịch
LunarCalendarPicker(
  initialSolarDate: DateTime.now(),
  onDateSelected: (solarDate, lunarDate) {
    print('Ngày dương: $solarDate');
    print('Ngày âm: $lunarDate');
  },
  displayMode: 'lunar',
  showLunarDate: true,
);

// Tùy chỉnh hiển thị
LunarCalendarPicker(
  initialSolarDate: DateTime.now(),
  onDateSelected: (solarDate, lunarDate) {
    print('Ngày dương: $solarDate');
    print('Ngày âm: $lunarDate');
  },
  dateText: 'Chọn ngày',
  dateFormat: 'dd/MM/yyyy',
  icon: Icons.calendar_today,
  iconColor: Colors.blue,
);
```

### Thêm sự kiện

```dart
LunarCalendar(
  events: [
    LunarEvent(
      title: 'Sinh nhật',
      type: 'birthday',
      solarDate: DateTime(2024, 3, 15),
    ),
    LunarEvent(
      title: 'Giỗ ông',
      type: 'anniversary',
      lunarDate: LunarDate(day: 15, month: 7, year: 2024),
      isYearlyRecurring: true,
    ),
  ],
)
```

### Tùy chỉnh giao diện

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
| theme | LunarCalendarTheme? | Theme tùy chỉnh cho calendar |
| localization | LunarCalendarLocalization? | Cấu hình ngôn ngữ |
| onDateSelected | Function(DateTime, LunarDate)? | Callback khi chọn ngày |
| showOutsideDays | bool? | Hiển thị ngày của tháng khác |
| events | List<LunarEvent> | Danh sách sự kiện |
| maxWidth | double? | Chiều rộng tối đa của calendar |
| showTodayButton | bool | Hiển thị nút Today |

### LunarCalendarPicker
| Property | Type | Description |
|----------|------|-------------|
| initialSolarDate | DateTime | Ngày dương lịch ban đầu |
| onDateSelected | Function(DateTime, LunarDate) | Callback khi chọn ngày |
| theme | LunarCalendarTheme? | Theme tùy chỉnh |
| localization | LunarCalendarLocalization? | Cấu hình ngôn ngữ |
| showLunarDate | bool | Hiển thị ngày âm lịch |
| dateFormat | String? | Định dạng hiển thị ngày |
| textStyle | TextStyle? | Style cho text |
| icon | IconData? | Icon hiển thị |
| iconColor | Color? | Màu của icon |
| iconSpacing | double | Khoảng cách giữa icon và text |
| dateText | String? | Text hiển thị thay cho ngày |
| displayMode | String | Chế độ hiển thị ('solar' hoặc 'lunar') |

### LunarEvent
| Property | Type | Description |
|----------|------|-------------|
| title | String | Tiêu đề sự kiện |
| description | String? | Mô tả sự kiện |
| type | String? | Loại sự kiện (birthday, meeting, holiday, reminder, task, anniversary) |
| lunarDate | LunarDate? | Ngày âm lịch |
| solarDate | DateTime? | Ngày dương lịch |
| isYearlyRecurring | bool | Lặp lại hàng năm |
| isMonthlyRecurring | bool | Lặp lại hàng tháng |
| color | Color? | Màu sắc sự kiện |

## License

Package này được phát hành dưới [giấy phép MIT](LICENSE).
