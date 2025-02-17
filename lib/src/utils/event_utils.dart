import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/lunar_event.dart';

/// Tiện ích xử lý sự kiện trong lịch
class EventUtils {
  /// Key lưu trữ sự kiện trong SharedPreferences
  static const String _storageKey = 'lunar_calendar_events';

  /// Lưu danh sách sự kiện vào bộ nhớ
  static Future<void> saveEvents(List<LunarEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = events.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(eventsJson));
  }

  /// Đọc danh sách sự kiện từ bộ nhớ
  static Future<List<LunarEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_storageKey);
    if (eventsJson == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(eventsJson);
      return decoded.map((e) => LunarEvent.fromJson(e)).toList();
    } catch (e) {
      print('Error loading events: $e');
      return [];
    }
  }

  /// Lấy danh sách sự kiện cho một ngày cụ thể
  static List<LunarEvent> getEventsForDay(
    DateTime date,
    List<LunarEvent> events,
  ) {
    return events.where((event) => event.occursOn(date)).toList();
  }

  /// Lấy danh sách sự kiện cho một tháng
  static List<LunarEvent> getEventsForMonth(
    DateTime month,
    List<LunarEvent> events,
  ) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    return events.where((event) {
      if (event.solarDate != null) {
        final date = event.solarDate!;
        if (event.isYearlyRecurring) {
          return date.month == month.month;
        }
        if (event.isMonthlyRecurring) {
          return true;
        }
        return date.isAfter(firstDay.subtract(const Duration(days: 1))) &&
            date.isBefore(lastDay.add(const Duration(days: 1)));
      }

      if (event.lunarDate != null) {
        final date = event.lunarDate!.toSolar();
        if (event.isYearlyRecurring) {
          final currentYearDate =
              event.lunarDate!.copyWith(year: month.year).toSolar();
          return currentYearDate.month == month.month;
        }
        if (event.isMonthlyRecurring) {
          return true;
        }
        return date.isAfter(firstDay.subtract(const Duration(days: 1))) &&
            date.isBefore(lastDay.add(const Duration(days: 1)));
      }

      return false;
    }).toList();
  }

  /// Sắp xếp sự kiện theo thời gian
  static List<LunarEvent> sortEvents(List<LunarEvent> events) {
    return List<LunarEvent>.from(events)
      ..sort((a, b) {
        final dateA = a.solarDate ?? a.lunarDate?.toSolar();
        final dateB = b.solarDate ?? b.lunarDate?.toSolar();
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });
  }

  /// Lọc sự kiện theo loại (hàng năm, hàng tháng)
  static List<LunarEvent> filterEvents(
    List<LunarEvent> events, {
    bool? yearlyOnly,
    bool? monthlyOnly,
  }) {
    return events.where((event) {
      if (yearlyOnly == true) return event.isYearlyRecurring;
      if (monthlyOnly == true) return event.isMonthlyRecurring;
      return true;
    }).toList();
  }

  /// Tìm kiếm sự kiện theo tiêu đề
  static List<LunarEvent> searchEvents(
    List<LunarEvent> events,
    String query,
  ) {
    final searchQuery = query.toLowerCase();
    return events
        .where((event) =>
            event.title.toLowerCase().contains(searchQuery) ||
            (event.description?.toLowerCase().contains(searchQuery) ?? false))
        .toList();
  }

  /// Kiểm tra xem có sự kiện nào cần nhắc nhở không
  static List<LunarEvent> getDueReminders(
    List<LunarEvent> events,
    DateTime now,
  ) {
    return events
        .where((event) =>
            event.reminder != null &&
            event.reminder!.isAfter(now) &&
            event.reminder!.isBefore(now.add(const Duration(minutes: 5))))
        .toList();
  }
}
