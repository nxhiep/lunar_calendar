import 'dart:math';

import '../localization/lunar_calendar_localization.dart';
import '../models/lunar_date.dart';

class LunarUtils {
  static const double _juliusDaysIn1900 = 2415021.076998695;
  static const double _newMoonCycle = 29.530588853;

  /// Số ngày trong một chu kỳ (19 năm)
  static const int _lunarCycle = 19;

  /// Tính số ngày Julius từ ngày dd/mm/yyyy
  static int _jdFromDate(int dd, int mm, int yy) {
    int a = ((14 - mm) / 12).floor();
    int y = yy + 4800 - a;
    int m = mm + 12 * a - 3;
    int jd = dd +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;

    if (jd < 2299161) {
      jd = dd + ((153 * m + 2) / 5).floor() + 365 * y + (y / 4).floor() - 32083;
    }
    return jd;
  }

  /// Chuyển số ngày Julius sang ngày/tháng/năm
  static List<int> _jdToDate(int jd) {
    int a, b, c, d, e, m, day, month, year;

    if (jd > 2299160) {
      a = jd + 32044;
      b = ((4 * a + 3) / 146097).floor();
      c = a - ((b * 146097) / 4).floor();
    } else {
      b = 0;
      c = jd + 32082;
    }
    d = ((4 * c + 3) / 1461).floor();
    e = c - ((1461 * d) / 4).floor();
    m = ((5 * e + 2) / 153).floor();
    day = e - ((153 * m + 2) / 5).floor() + 1;
    month = m + 3 - 12 * (m / 10).floor();
    year = b * 100 + d - 4800 + (m / 10).floor();

    return [day, month, year];
  }

  /// Tính ngày sóc thứ k kể từ điểm Sóc ngày 1/1/1900
  static double _getNewMoonDay(int k) {
    double T = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
    double t2 = T * T;
    double t3 = t2 * T;
    double dr = pi / 180;
    double jd1 =
        2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
    jd1 = jd1 + 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * t2) * dr);

    double M = 359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3;
    double mpr = 306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3;
    double F = 21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3;

    double c1 =
        (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M);
    c1 = c1 - 0.4068 * sin(mpr * dr) + 0.0161 * sin(dr * 2 * mpr);
    c1 = c1 - 0.0004 * sin(dr * 3 * mpr);
    c1 = c1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + mpr));
    c1 = c1 - 0.0074 * sin(dr * (M - mpr)) + 0.0004 * sin(dr * (2 * F + M));
    c1 = c1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + mpr));
    c1 = c1 +
        0.0010 * sin(dr * (2 * F - mpr)) +
        0.0005 * sin(dr * (2 * mpr + M));

    double delta;
    if (T < -11) {
      delta = 0.001 +
          0.000839 * T +
          0.0002261 * t2 -
          0.00000845 * t3 -
          0.000000081 * T * t3;
    } else {
      delta = -0.000278 + 0.000265 * T + 0.000262 * t2;
    }

    return jd1 + c1 - delta;
  }

  /// Tính tọa độ mặt trời
  static double _getSunLongitude(double jdn) {
    double T = (jdn - 2451545.0) / 36525;
    double t2 = T * T;
    double dr = pi / 180;
    double M =
        357.52910 + 35999.05030 * T - 0.0001559 * t2 - 0.00000048 * T * t2;
    double L0 = 280.46645 + 36000.76983 * T + 0.0003032 * t2;
    double DL = (1.914600 - 0.004817 * T - 0.000014 * t2) * sin(dr * M);
    DL = DL +
        (0.019993 - 0.000101 * T) * sin(dr * 2 * M) +
        0.000290 * sin(dr * 3 * M);
    double L = L0 + DL;
    L = L * dr;
    L = L - pi * 2 * (L / (pi * 2)).floor();
    return L;
  }

  /// Chuyển đổi ngày dương lịch sang âm lịch
  static LunarDate solarToLunar(DateTime solar, [int timeZone = 7]) {
    int dayNumber = _jdFromDate(solar.day, solar.month, solar.year);
    int k = ((dayNumber - _juliusDaysIn1900) / _newMoonCycle).floor();
    int monthStart = (_getNewMoonDay(k + 1) + 0.5 + timeZone / 24).floor();

    if (monthStart > dayNumber) {
      monthStart = (_getNewMoonDay(k) + 0.5 + timeZone / 24).floor();
    }

    int a11 = _getLunarMonth11(solar.year, timeZone);
    int b11 = a11;
    int lunarYear;
    if (a11 >= monthStart) {
      lunarYear = solar.year;
      a11 = _getLunarMonth11(solar.year - 1, timeZone);
    } else {
      lunarYear = solar.year + 1;
      b11 = _getLunarMonth11(solar.year + 1, timeZone);
    }

    int lunarDay = dayNumber - monthStart + 1;
    int diff = ((monthStart - a11) / 29.530588853).floor();
    int lunarLeap = 0;
    int lunarMonth = diff + 12;

    if (b11 - a11 > 365) {
      int leapMonthDiff = _getLeapMonthOffset(a11, timeZone);
      if (diff >= leapMonthDiff) {
        lunarMonth = diff + 11;
        if (diff == leapMonthDiff) {
          lunarLeap = 1;
        }
      }
    }

    if (lunarMonth > 12) {
      lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
      lunarYear -= 1;
    }

    return LunarDate(
      day: lunarDay,
      month: lunarMonth,
      year: lunarYear,
      isLeapMonth: lunarLeap == 1,
    );
  }

  /// Chuyển đổi ngày âm lịch sang dương lịch
  static DateTime lunarToSolar(LunarDate lunar, [int timeZone = 7]) {
    int a11, b11, off, leapOff, leapMonth, monthStart;

    if (lunar.month < 11) {
      a11 = _getLunarMonth11(lunar.year - 1, timeZone);
      b11 = _getLunarMonth11(lunar.year, timeZone);
    } else {
      a11 = _getLunarMonth11(lunar.year, timeZone);
      b11 = _getLunarMonth11(lunar.year + 1, timeZone);
    }

    int k = (0.5 + (a11 - _juliusDaysIn1900) / _newMoonCycle).floor();
    off = lunar.month - 11;
    if (off < 0) {
      off += 12;
    }

    if (b11 - a11 > 365) {
      leapOff = _getLeapMonthOffset(a11, timeZone);
      leapMonth = leapOff - 2;
      if (leapMonth < 0) {
        leapMonth += 12;
      }
      if (lunar.isLeapMonth && lunar.month != leapMonth) {
        return DateTime(0); // Invalid date
      } else if (lunar.isLeapMonth || off >= leapOff) {
        off += 1;
      }
    }

    monthStart = _getNewMoonDay(k + off).toInt();
    List<int> ret = _jdToDate(monthStart + lunar.day - 1);
    return DateTime(ret[2], ret[1], ret[0]);
  }

  static int _getLunarMonth11(int yy, [int timeZone = 7]) {
    double off = _jdFromDate(31, 12, yy) - 2415021.076998695;
    int k = (off / 29.530588853).floor();
    int nm = _getNewMoonDay(k).toInt();
    int sunLong = _getSunLongitude(nm + 0.5 + timeZone / 24).toInt();

    if (sunLong >= 9) {
      nm = _getNewMoonDay(k - 1).toInt();
    }
    return nm;
  }

  static int _getLeapMonthOffset(int a11, [int timeZone = 7]) {
    int k = ((a11 - _juliusDaysIn1900) / _newMoonCycle + 0.5).floor();
    int last = 0;
    int i = 1;
    int arc =
        _getSunLongitude(_getNewMoonDay(k + i) + 0.5 + timeZone / 24).toInt();

    do {
      last = arc;
      i++;
      arc =
          _getSunLongitude(_getNewMoonDay(k + i) + 0.5 + timeZone / 24).toInt();
    } while (arc != last && i < 14);

    return i - 1;
  }

  /// Lấy can chi của năm theo ngôn ngữ
  static String getYearCanChi(
      int year, LunarCalendarLocalization localization) {
    final can = localization.get('can').split(',');
    final chi = localization.get('chi').split(',');

    final canIndex = (year - 4) % 10;
    final chiIndex = (year - 4) % 12;

    return '${can[canIndex]} ${chi[chiIndex]}';
  }

  /// Lấy can chi của tháng theo ngôn ngữ
  static String getMonthCanChi(
    int month,
    int yearCan,
    LunarCalendarLocalization localization,
  ) {
    final can = localization.get('can').split(',');
    final chi = localization.get('month_chi').split(',');

    final canIndex = (yearCan * 2 + month - 1) % 10;
    return '${can[canIndex]} ${chi[month - 1]}';
  }

  /// Lấy can chi của ngày theo ngôn ngữ
  static String getDayCanChi(
    DateTime date,
    LunarCalendarLocalization localization,
  ) {
    final can = localization.get('can').split(',');
    final chi = localization.get('chi').split(',');

    final epoch = DateTime(1900, 1, 1);
    final days = date.difference(epoch).inDays;

    final canIndex = (days + 9) % 10;
    final chiIndex = (days + 1) % 12;

    return '${can[canIndex]} ${chi[chiIndex]}';
  }

  /// Kiểm tra năm nhuận âm lịch
  static bool isLeapYear(int year) {
    // Công thức tính năm nhuận âm lịch
    // Một chu kỳ 19 năm có 7 năm nhuận
    return [2, 5, 7, 10, 13, 15, 18].contains(year % _lunarCycle);
  }

  /// Lấy danh sách các giờ hoàng đạo trong ngày theo ngôn ngữ
  static List<String> getGoodHours(
    DateTime date,
    LunarCalendarLocalization localization,
  ) {
    final dayCanChi = getDayCanChi(date, localization);
    // TODO: Implement good hours calculation
    return [
      '${localization.get('hour_ty')} (23:00-1:00)',
      '${localization.get('hour_dan')} (3:00-5:00)',
      '${localization.get('hour_mao')} (5:00-7:00)',
    ];
  }

  /// Kiểm tra ngày hoàng đạo
  static bool isGoodDay(DateTime date) {
    final lunar = solarToLunar(date);
    // TODO: Implement good day calculation
    return lunar.day % 2 == 0; // Tạm thời return mẫu
  }

  /// Lấy tiết khí của ngày theo ngôn ngữ
  static String? getSolarTerm(
    DateTime date,
    LunarCalendarLocalization localization,
  ) {
    final terms = localization.get('solar_terms').split(',');
    // TODO: Implement solar term calculation
    return null;
  }

  /// Lấy ngày lễ âm lịch theo ngôn ngữ
  static String? getLunarFestival(
    LunarDate date,
    LunarCalendarLocalization localization,
  ) {
    final key = 'festival_${date.day}_${date.month}';
    return localization.get(key);
  }
}
