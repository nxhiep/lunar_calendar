/// Enum định nghĩa các chế độ xem của calendar
enum CalendarView {
  /// Chế độ xem theo tháng
  /// Hiển thị chi tiết các ngày trong một tháng
  month,

  /// Chế độ xem theo năm
  /// Hiển thị tổng quan 12 tháng trong năm
  year;

  String toDisplayString() {
    switch (this) {
      case CalendarView.month:
        return 'Tháng';
      case CalendarView.year:
        return 'Năm';
    }
  }

  CalendarView next() {
    switch (this) {
      case CalendarView.month:
        return CalendarView.year;
      case CalendarView.year:
        return CalendarView.month;
    }
  }

  bool get isMonth => this == CalendarView.month;

  bool get isYear => this == CalendarView.year;
}
