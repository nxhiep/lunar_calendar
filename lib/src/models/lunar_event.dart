import 'package:flutter/material.dart';

import 'lunar_date.dart';

class LunarEvent {
  /// Tiêu đề sự kiện
  final String title;

  /// Mô tả chi tiết về sự kiện
  final String? description;

  /// Ngày âm lịch của sự kiện
  final LunarDate? lunarDate;

  /// Ngày dương lịch của sự kiện
  final DateTime? solarDate;

  /// Sự kiện có lặp lại hàng năm không
  /// Ví dụ: ngày giỗ, sinh nhật âm lịch
  final bool isYearlyRecurring;

  /// Sự kiện có lặp lại hàng tháng không
  /// Ví dụ: ngày rằm, mùng một
  final bool isMonthlyRecurring;

  /// Màu sắc hiển thị của sự kiện
  final Color? color;

  /// Thời gian nhắc nhở sự kiện
  final DateTime? reminder;

  /// Loại sự kiện
  final String? type;

  /// Constructor
  const LunarEvent({
    required this.title,
    this.description,
    this.lunarDate,
    this.solarDate,
    this.isYearlyRecurring = false,
    this.isMonthlyRecurring = false,
    this.color,
    this.reminder,
    this.type,
  }) : assert(
          lunarDate != null || solarDate != null,
          'Phải có ít nhất một trong hai: ngày âm lịch hoặc dương lịch',
        );

  /// Copy với một số thuộc tính mới
  LunarEvent copyWith({
    String? title,
    String? description,
    LunarDate? lunarDate,
    DateTime? solarDate,
    bool? isYearlyRecurring,
    bool? isMonthlyRecurring,
    Color? color,
    DateTime? reminder,
    String? type,
  }) {
    return LunarEvent(
      title: title ?? this.title,
      description: description ?? this.description,
      lunarDate: lunarDate ?? this.lunarDate,
      solarDate: solarDate ?? this.solarDate,
      isYearlyRecurring: isYearlyRecurring ?? this.isYearlyRecurring,
      isMonthlyRecurring: isMonthlyRecurring ?? this.isMonthlyRecurring,
      color: color ?? this.color,
      reminder: reminder ?? this.reminder,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LunarEvent &&
        other.title == title &&
        other.lunarDate == lunarDate &&
        other.solarDate == solarDate &&
        other.isYearlyRecurring == isYearlyRecurring &&
        other.isMonthlyRecurring == isMonthlyRecurring &&
        other.type == type;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      lunarDate,
      solarDate,
      isYearlyRecurring,
      isMonthlyRecurring,
      type,
    );
  }

  @override
  String toString() {
    final date = lunarDate != null
        ? 'Âm lịch: $lunarDate'
        : 'Dương lịch: ${solarDate?.toString()}';
    return '$title ($date)';
  }

  factory LunarEvent.fromJson(Map<String, dynamic> json) {
    return LunarEvent(
      title: json['title'] as String,
      description: json['description'] as String?,
      lunarDate: json['lunarDate'] != null
          ? LunarDate.fromJson(json['lunarDate'] as Map<String, dynamic>)
          : null,
      solarDate: json['solarDate'] != null
          ? DateTime.parse(json['solarDate'] as String)
          : null,
      isYearlyRecurring: json['isYearlyRecurring'] as bool? ?? false,
      isMonthlyRecurring: json['isMonthlyRecurring'] as bool? ?? false,
      color: json['color'] != null ? Color(json['color'] as int) : null,
      reminder: json['reminder'] != null
          ? DateTime.parse(json['reminder'] as String)
          : null,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'lunarDate': lunarDate?.toJson(),
      'solarDate': solarDate?.toIso8601String(),
      'isYearlyRecurring': isYearlyRecurring,
      'isMonthlyRecurring': isMonthlyRecurring,
      'color': color?.value,
      'reminder': reminder?.toIso8601String(),
      'type': type,
    };
  }

  /// Kiểm tra xem sự kiện có diễn ra vào ngày được chỉ định không
  bool occursOn(DateTime date) {
    if (solarDate != null) {
      if (isYearlyRecurring) {
        return solarDate!.month == date.month && solarDate!.day == date.day;
      }
      if (isMonthlyRecurring) {
        return solarDate!.day == date.day;
      }
      return solarDate!.year == date.year &&
          solarDate!.month == date.month &&
          solarDate!.day == date.day;
    }

    if (lunarDate != null) {
      final eventSolarDate = lunarDate!.toSolar();
      if (isYearlyRecurring) {
        final currentYearLunarDate = lunarDate!.copyWith(year: date.year);
        final currentYearSolarDate = currentYearLunarDate.toSolar();
        return currentYearSolarDate.year == date.year &&
            currentYearSolarDate.month == date.month &&
            currentYearSolarDate.day == date.day;
      }
      if (isMonthlyRecurring) {
        return lunarDate!.day == LunarDate.fromSolar(date).day;
      }
      return eventSolarDate.year == date.year &&
          eventSolarDate.month == date.month &&
          eventSolarDate.day == date.day;
    }

    return false;
  }
}
