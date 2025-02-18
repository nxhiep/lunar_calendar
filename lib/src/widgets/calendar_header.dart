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

  final double? maxWidth;

  const CalendarHeader({
    super.key,
    required this.displayedMonth,
    required this.currentView,
    required this.theme,
    required this.localization,
    this.onMonthChanged,
    this.onViewChanged,
    this.onTodayPressed,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      width: maxWidth,
      child: Row(
        children: [
          // Nút chọn tháng
          InkWell(
            onTap: () => _showMonthPicker(context),
            child: Row(
              children: [
                Text(
                  DateUtils.monthName(
                    displayedMonth,
                    localization: localization,
                  ),
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: theme.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: theme.textColor,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Nút chọn năm
          InkWell(
            onTap: () => _showYearPicker(context),
            child: Row(
              children: [
                Text(
                  displayedMonth.year.toString(),
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: theme.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: theme.textColor,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Nút Today
          TextButton(
            onPressed: onTodayPressed,
            style: TextButton.styleFrom(
              foregroundColor: theme.primaryColor,
            ),
            child: Text(localization.get('today')),
          ),
        ],
      ),
    );
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.backgroundColor,
      builder: (context) {
        return Container(
          height: 300,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = DateTime(displayedMonth.year, index + 1);
              final isSelected = month.month == displayedMonth.month;

              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onMonthChanged?.call(month);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? theme.selectedDayColor : null,
                    borderRadius: BorderRadius.circular(theme.borderRadius),
                  ),
                  child: Text(
                    DateUtils.monthName(
                      month,
                      localization: localization,
                      short: true,
                    ),
                    style: TextStyle(
                      color: isSelected
                          ? theme.selectedDayTextColor
                          : theme.textColor,
                      fontSize: theme.fontSize,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.backgroundColor,
          child: Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(16),
            child: YearPicker(
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              selectedDate: displayedMonth,
              onChanged: (date) {
                Navigator.pop(context);
                onMonthChanged?.call(date);
              },
            ),
          ),
        );
      },
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
