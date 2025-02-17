import 'package:intl/intl.dart';

import '../localization/lunar_calendar_localization.dart';

class DateUtils {
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }

  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Lấy danh sách các ngày trong tháng
  static List<DateTime> daysInMonth(DateTime date) {
    final first = firstDayOfMonth(date);
    final daysBefore = first.weekday - 1; // Số ngày của tháng trước
    final firstToDisplay = first.subtract(Duration(days: daysBefore));

    final last = lastDayOfMonth(date);
    final daysAfter = 7 - last.weekday; // Số ngày của tháng sau
    final lastToDisplay = last.add(Duration(days: daysAfter));

    final daysToDisplay = <DateTime>[];
    for (var i = firstToDisplay;
        i.isBefore(lastToDisplay.add(const Duration(days: 1)));
        i = i.add(const Duration(days: 1))) {
      daysToDisplay.add(i);
    }

    return daysToDisplay;
  }

  /// Kiểm tra xem có phải là cùng ngày không
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Kiểm tra xem có phải là ngày hôm nay không
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }

  /// Kiểm tra xem có phải là ngày cuối tuần không
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  /// Lấy tên thứ trong tuần theo ngôn ngữ
  static String weekdayName(
    DateTime date, {
    bool short = true,
    required LunarCalendarLocalization localization,
  }) {
    String weekdayKey = short ? 'monday_short' : 'monday';
    switch (date.weekday) {
      case DateTime.monday:
        weekdayKey = short ? 'monday_short' : 'monday';
        break;
      case DateTime.tuesday:
        weekdayKey = short ? 'tuesday_short' : 'tuesday';
        break;
      case DateTime.wednesday:
        weekdayKey = short ? 'wednesday_short' : 'wednesday';
        break;
      case DateTime.thursday:
        weekdayKey = short ? 'thursday_short' : 'thursday';
        break;
      case DateTime.friday:
        weekdayKey = short ? 'friday_short' : 'friday';
        break;
      case DateTime.saturday:
        weekdayKey = short ? 'saturday_short' : 'saturday';
        break;
      case DateTime.sunday:
        weekdayKey = short ? 'sunday_short' : 'sunday';
    }

    return localization.get(weekdayKey);
  }

  /// Lấy tên tháng theo ngôn ngữ
  static String monthName(
    DateTime date, {
    bool short = true,
    required LunarCalendarLocalization localization,
  }) {
    final monthKey = 'month_${date.month}';
    return localization.get(monthKey);
  }

  /// Lấy danh sách các tháng trong năm
  static List<DateTime> monthsInYear(int year) {
    return List.generate(
      12,
      (index) => DateTime(year, index + 1, 1),
    );
  }

  /// Kiểm tra xem có phải là cùng tháng không
  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  /// Lấy số tuần trong tháng
  static int weeksInMonth(DateTime date) {
    final days = daysInMonth(date);
    return (days.length / 7).ceil();
  }

  /// Lấy ngày theo vị trí trong lưới calendar
  static DateTime? dayFromGridIndex(DateTime month, int index) {
    final days = daysInMonth(month);
    if (index < 0 || index >= days.length) return null;
    return days[index];
  }

  /// Lấy vị trí trong lưới calendar từ ngày
  static int? gridIndexFromDay(DateTime month, DateTime day) {
    final days = daysInMonth(month);
    for (var i = 0; i < days.length; i++) {
      if (isSameDay(days[i], day)) return i;
    }
    return null;
  }
}
