import 'package:flutter/material.dart';

/// Theme cho Lunar Calendar
class LunarCalendarTheme {
  /// Màu chủ đạo
  final Color primaryColor;

  /// Màu nền
  final Color backgroundColor;

  /// Màu text chính
  final Color textColor;

  /// Màu text phụ
  final Color subtextColor;

  /// Màu ngày được chọn
  final Color selectedDayColor;

  /// Màu text ngày được chọn
  final Color selectedDayTextColor;

  /// Màu text ngày được chọn phụ
  final Color selectedDaySubtextColor;

  /// Màu ngày hôm nay
  final Color todayColor;

  /// Màu text ngày hôm nay
  final Color todayTextColor;

  /// Màu ngày cuối tuần
  final Color weekendColor;

  /// Màu ngày ngoài tháng hiện tại
  final Color outsideDayColor;

  /// Màu ngày hoàng đạo
  final Color goodDayColor;

  /// Màu ngày hắc đạo
  final Color badDayColor;

  /// Màu sự kiện
  final Color eventColor;

  /// Font size cho text chính
  final double fontSize;

  /// Font size cho text phụ
  final double subtextFontSize;

  /// Border radius cho các item
  final double borderRadius;

  /// Padding cho các item
  final EdgeInsets cellPadding;

  /// Có hiển thị ngày của tháng khác không
  final bool showOutsideDays;

  const LunarCalendarTheme({
    this.primaryColor = const Color(0xFF1976D2),
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.subtextColor = Colors.black54,
    this.selectedDayColor = const Color(0xFF1976D2),
    this.selectedDayTextColor = Colors.white,
    this.selectedDaySubtextColor = Colors.black54,
    this.todayColor = const Color(0x331976D2),
    this.todayTextColor = const Color(0xFF1976D2),
    this.weekendColor = Colors.red,
    this.outsideDayColor = Colors.black38,
    this.goodDayColor = Colors.green,
    this.badDayColor = Colors.red,
    this.eventColor = const Color(0xFF1976D2),
    this.fontSize = 16,
    this.subtextFontSize = 10,
    this.borderRadius = 0,
    this.cellPadding = const EdgeInsets.all(0),
    this.showOutsideDays = false,
  });

  static const dark = LunarCalendarTheme(
    primaryColor: Colors.white,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    subtextColor: Colors.white70,
    selectedDayColor: Colors.orange,
    selectedDayTextColor: Colors.black,
    selectedDaySubtextColor: Colors.white70,
    todayColor: Colors.transparent,
    todayTextColor: Colors.orange,
    weekendColor: Colors.red,
    outsideDayColor: Colors.white38,
    goodDayColor: Colors.orange,
    badDayColor: Colors.red,
    eventColor: Colors.orange,
    fontSize: 16,
    subtextFontSize: 10,
    borderRadius: 0,
    cellPadding: EdgeInsets.zero,
    showOutsideDays: false,
  );

  LunarCalendarTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? textColor,
    Color? subtextColor,
    Color? selectedDayColor,
    Color? selectedDayTextColor,
    Color? selectedDaySubtextColor,
    Color? todayColor,
    Color? todayTextColor,
    Color? weekendColor,
    Color? outsideDayColor,
    Color? goodDayColor,
    Color? badDayColor,
    Color? eventColor,
    double? fontSize,
    double? subtextFontSize,
    double? borderRadius,
    EdgeInsets? cellPadding,
    bool? showOutsideDays,
  }) {
    return LunarCalendarTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      subtextColor: subtextColor ?? this.subtextColor,
      selectedDayColor: selectedDayColor ?? this.selectedDayColor,
      selectedDayTextColor: selectedDayTextColor ?? this.selectedDayTextColor,
      selectedDaySubtextColor:
          selectedDaySubtextColor ?? this.selectedDaySubtextColor,
      todayColor: todayColor ?? this.todayColor,
      todayTextColor: todayTextColor ?? this.todayTextColor,
      weekendColor: weekendColor ?? this.weekendColor,
      outsideDayColor: outsideDayColor ?? this.outsideDayColor,
      goodDayColor: goodDayColor ?? this.goodDayColor,
      badDayColor: badDayColor ?? this.badDayColor,
      eventColor: eventColor ?? this.eventColor,
      fontSize: fontSize ?? this.fontSize,
      subtextFontSize: subtextFontSize ?? this.subtextFontSize,
      borderRadius: borderRadius ?? this.borderRadius,
      cellPadding: cellPadding ?? this.cellPadding,
      showOutsideDays: showOutsideDays ?? this.showOutsideDays,
    );
  }

  /// Tạo theme từ theme của app
  static LunarCalendarTheme fromTheme(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return isDark ? dark : const LunarCalendarTheme();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LunarCalendarTheme &&
        other.primaryColor == primaryColor &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor &&
        other.subtextColor == subtextColor &&
        other.selectedDayColor == selectedDayColor &&
        other.selectedDayTextColor == selectedDayTextColor &&
        other.selectedDaySubtextColor == selectedDaySubtextColor &&
        other.todayColor == todayColor &&
        other.todayTextColor == todayTextColor &&
        other.weekendColor == weekendColor &&
        other.outsideDayColor == outsideDayColor &&
        other.goodDayColor == goodDayColor &&
        other.badDayColor == badDayColor &&
        other.eventColor == eventColor &&
        other.fontSize == fontSize &&
        other.subtextFontSize == subtextFontSize &&
        other.borderRadius == borderRadius &&
        other.cellPadding == cellPadding &&
        other.showOutsideDays == showOutsideDays;
  }

  @override
  int get hashCode {
    return Object.hash(
      primaryColor,
      backgroundColor,
      textColor,
      subtextColor,
      selectedDayColor,
      selectedDayTextColor,
      selectedDaySubtextColor,
      todayColor,
      todayTextColor,
      weekendColor,
      outsideDayColor,
      goodDayColor,
      badDayColor,
      eventColor,
      fontSize,
      subtextFontSize,
      borderRadius,
      cellPadding,
      showOutsideDays,
    );
  }
}
