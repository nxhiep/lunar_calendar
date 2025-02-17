import 'package:flutter/material.dart' hide DateUtils;

import '../localization/lunar_calendar_localization.dart';
import '../models/calendar_view.dart';
import '../theme/lunar_calendar_theme.dart';
import '../utils/date_utils.dart';

class CalendarHeader extends StatelessWidget {
  /// Tháng hiện tại đang hiển thị
  final DateTime displayedMonth;

  /// Chế độ xem hiện tại (tháng/năm)
  final CalendarView currentView;

  /// Theme của calendar
  final LunarCalendarTheme theme;

  /// Localization của calendar
  final LunarCalendarLocalization localization;

  /// Callback khi chuyển tháng trước/sau
  final ValueChanged<DateTime>? onMonthChanged;

  /// Callback khi chuyển đổi chế độ xem
  final ValueChanged<CalendarView>? onViewChanged;

  /// Callback khi nhấn nút Today
  final VoidCallback? onTodayPressed;

  const CalendarHeader({
    super.key,
    required this.displayedMonth,
    required this.currentView,
    required this.theme,
    required this.localization,
    this.onMonthChanged,
    this.onViewChanged,
    this.onTodayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button & Year
          GestureDetector(
            onTap: () => onViewChanged?.call(currentView.next()),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: theme.primaryColor, size: 16),
                Text(
                  displayedMonth.year.toString(),
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: theme.fontSize,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Month
          Text(
            DateUtils.monthName(displayedMonth, localization: localization),
            style: TextStyle(
              color: theme.textColor,
              fontSize: theme.fontSize * 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getHeaderText() {
    if (currentView.isYear) {
      return '${localization.get('year')} ${displayedMonth.year}';
    }

    return '${DateUtils.monthName(displayedMonth, localization: localization)} ${displayedMonth.year}';
  }

  void _onPreviousMonth() {
    if (currentView.isYear) {
      onMonthChanged?.call(
        DateTime(displayedMonth.year - 1, displayedMonth.month),
      );
    } else {
      onMonthChanged?.call(
        DateTime(
          displayedMonth.year,
          displayedMonth.month - 1,
          displayedMonth.day,
        ),
      );
    }
  }

  void _onNextMonth() {
    if (currentView.isYear) {
      onMonthChanged?.call(
        DateTime(displayedMonth.year + 1, displayedMonth.month),
      );
    } else {
      onMonthChanged?.call(
        DateTime(
          displayedMonth.year,
          displayedMonth.month + 1,
          displayedMonth.day,
        ),
      );
    }
  }
}
