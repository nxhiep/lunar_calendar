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

  @override
  Widget build(BuildContext context) {
    final isSelected =
        selectedDate != null && DateUtils.isSameDay(date, selectedDate);
    final isToday = DateUtils.isToday(date);
    final isWeekend = DateUtils.isWeekend(date);
    final isGoodDay = LunarUtils.isGoodDay(date);

    // Ẩn ngày nếu không hiển thị ngày ngoài tháng
    if (!isCurrentMonth && !theme.showOutsideDays) {
      return Container();
    }

    // Kiểm tra có phải ngày đầu tháng (dương hoặc âm)
    final isFirstDayOfSolarMonth = date.day == 1;
    final isFirstDayOfLunarMonth = lunarDate.day == 1;
    final shouldShowMonth = isFirstDayOfSolarMonth || isFirstDayOfLunarMonth;

    return InkWell(
      onTap: isCurrentMonth || theme.showOutsideDays
          ? () => onDateSelected?.call(date)
          : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: theme.cellPadding,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: isSelected
                      ? BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: _getTextColor(isSelected, isToday, isWeekend),
                        fontSize: theme.fontSize,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
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

            // Chỉ báo sự kiện
            if (events.isNotEmpty)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : theme.eventColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getTextColor(bool isSelected, bool isToday, bool isWeekend) {
    if (!isCurrentMonth) return theme.outsideDayColor;
    if (isSelected) return Colors.black; // Màu đen cho text khi được chọn
    if (isWeekend) return theme.weekendColor;
    if (isToday) return theme.todayTextColor;
    return theme.textColor;
  }

  Color _getSubtextColor(bool isSelected) {
    if (!isCurrentMonth) return theme.outsideDayColor;
    if (isSelected) return theme.selectedDayTextColor;
    return theme.subtextColor;
  }
}
