import 'package:flutter/material.dart' hide DateUtils;

import '../models/lunar_date.dart';
import '../theme/lunar_calendar_theme.dart';
import '../utils/date_utils.dart';
import '../utils/lunar_utils.dart';

class DayCell extends StatelessWidget {
  /// Ngày dương lịch
  final DateTime date;

  /// Ngày âm lịch
  final LunarDate lunarDate;

  /// Ngày được chọn
  final DateTime? selectedDate;

  /// Có phải là ngày trong tháng hiện tại không
  final bool isCurrentMonth;

  /// Callback khi chọn ngày
  final ValueChanged<DateTime>? onDateSelected;

  /// Theme của calendar
  final LunarCalendarTheme theme;

  /// Danh sách sự kiện trong ngày
  final List<String> events;

  const DayCell({
    super.key,
    required this.date,
    required this.lunarDate,
    required this.theme,
    this.selectedDate,
    this.isCurrentMonth = true,
    this.onDateSelected,
    this.events = const [],
  });

  bool checkNeedShowMonth() {
    final isFirstDayOfLunarMonth = lunarDate.day == 1;
    if (theme.showOutsideDays) {
      if (isFirstDayOfLunarMonth) {
        return true;
      }
      return false;
    }

    final isFirstDayOfSolarMonth = date.day == 1;
    return isFirstDayOfSolarMonth || isFirstDayOfLunarMonth;
  }

  @override
  Widget build(BuildContext context) {
    final isSelected =
        selectedDate != null && DateUtils.isSameDay(date, selectedDate);
    final isToday = DateUtils.isToday(date);
    final isGoodDay = LunarUtils.isGoodDay(date);

    if (!isCurrentMonth && !theme.showOutsideDays) {
      return Container();
    }

    final shouldShowMonth = checkNeedShowMonth();

    return InkWell(
      onTap: isCurrentMonth || theme.showOutsideDays
          ? () => onDateSelected?.call(date)
          : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: theme.cellPadding,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: theme.fontSize + 10,
                    height: theme.fontSize + 10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? theme.selectedDayColor : null,
                      shape: BoxShape.circle,
                      border: isToday
                          ? Border.all(
                              color: theme.todayColor,
                              width: 1,
                            )
                          : null,
                    ),
                    child: Text(
                      date.day.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _getTextColor(isSelected, isToday, date),
                        fontSize: theme.fontSize,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                  Text(
                    shouldShowMonth
                        ? '${lunarDate.day}/${lunarDate.month}'
                        : lunarDate.day.toString(),
                    style: TextStyle(
                      color: _getSubtextColor(isSelected),
                      fontSize: theme.subtextFontSize,
                    ),
                  ),
                ],
              ),
            ),
            if (events.isNotEmpty)
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.eventColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getTextColor(bool isSelected, bool isToday, DateTime date) {
    if (!isCurrentMonth) return theme.outsideDayColor;
    if (isSelected) return theme.selectedDayTextColor;
    if (isToday) return theme.todayTextColor;
    if (date.weekday == 7) return theme.sundayColor;
    if (date.weekday == 6) return theme.saturdayColor;
    return theme.textColor;
  }

  Color _getSubtextColor(bool isSelected) {
    if (!isCurrentMonth) return theme.outsideDayColor;
    if (isSelected) return theme.selectedDaySubtextColor;
    return theme.subtextColor;
  }
}
