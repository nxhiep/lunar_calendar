import '../../lunar_calendar.dart';

/// Model biểu diễn ngày âm lịch
class LunarDate {
  /// Ngày âm lịch (1-30)
  final int day;

  /// Tháng âm lịch (1-12)
  final int month;

  /// Năm âm lịch
  final int year;

  /// Can chi của ngày (ví dụ: Giáp Tý)
  final String? canChi;

  /// Có phải tháng nhuận không
  final bool isLeapMonth;

  /// Constructor
  const LunarDate({
    required this.day,
    required this.month,
    required this.year,
    this.canChi,
    this.isLeapMonth = false,
  });

  /// Tạo LunarDate từ DateTime (dương lịch)
  static LunarDate fromSolar(DateTime solarDate) {
    return LunarUtils.solarToLunar(solarDate);
  }

  /// Chuyển đổi sang DateTime (dương lịch)
  DateTime toSolar() {
    final currentTimeZone = DateTime.now().timeZoneOffset.inHours;
    final date = LunarUtils.lunarToSolar(
      day,
      month,
      year,
      isLeapMonth ? 1 : 0,
      currentTimeZone.toDouble(),
    );
    return DateTime(date[2], date[1], date[0]);
  }

  LunarDate copyWith({
    int? day,
    int? month,
    int? year,
    String? canChi,
    bool? isLeapMonth,
  }) {
    return LunarDate(
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      canChi: canChi ?? this.canChi,
      isLeapMonth: isLeapMonth ?? this.isLeapMonth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LunarDate &&
        other.day == day &&
        other.month == month &&
        other.year == year &&
        other.isLeapMonth == isLeapMonth;
  }

  @override
  int get hashCode {
    return Object.hash(
      day,
      month,
      year,
      isLeapMonth,
    );
  }

  @override
  String toString() {
    final leapStr = isLeapMonth ? ' (nhuận)' : '';
    final canChiStr = canChi != null ? ' $canChi' : '';
    return '$day/$month$leapStr/$year$canChiStr';
  }

  factory LunarDate.fromJson(Map<String, dynamic> json) {
    return LunarDate(
      day: json['day'] as int,
      month: json['month'] as int,
      year: json['year'] as int,
      canChi: json['canChi'] as String?,
      isLeapMonth: json['isLeapMonth'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'month': month,
      'year': year,
      'canChi': canChi,
      'isLeapMonth': isLeapMonth,
    };
  }

  bool isValid() {
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 30) return false; // Tạm thời giới hạn 30 ngày/tháng
    return true;
  }
}
