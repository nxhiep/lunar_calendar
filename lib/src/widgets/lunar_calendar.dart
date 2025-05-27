import 'package:flutter/material.dart' hide DateUtils;

import '../localization/lunar_calendar_localization.dart';
import '../models/calendar_view.dart';
import '../models/lunar_date.dart';
import '../models/lunar_event.dart';
import '../theme/lunar_calendar_theme.dart';
import '../utils/date_utils.dart';
import '../utils/lunar_utils.dart';
import 'calendar_header.dart';
import 'day_cell.dart';

class LunarCalendar extends StatefulWidget {
  final LunarCalendarTheme? theme;

  final LunarCalendarLocalization? localization;

  final Function(DateTime solarDate, LunarDate lunarDate)? onDateSelected;

  /// Có hiển thị ngày của tháng khác không
  final bool? showOutsideDays;

  final List<LunarEvent> events;

  final double? maxWidth;

  /// Có hiển thị nút Today không
  final bool showTodayButton;

  /// Ngày dương lịch ban đầu được chọn
  final DateTime? initialSolarDate;

  /// Ngày âm lịch ban đầu được chọn
  final LunarDate? initialLunarDate;

  final bool enableDrag;

  final bool showEvents;

  const LunarCalendar({
    super.key,
    this.theme,
    this.localization,
    this.onDateSelected,
    this.showOutsideDays,
    this.events = const [],
    this.maxWidth,
    this.showTodayButton = true, // Mặc định là hiển thị
    this.initialSolarDate,
    this.initialLunarDate,
    this.enableDrag = true,
    this.showEvents = true,
  });

  @override
  State<LunarCalendar> createState() => _LunarCalendarState();
}

class _LunarCalendarState extends State<LunarCalendar> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  late CalendarView _currentView;
  late PageController _pageController;
  static const _initialPage = 1200;

  @override
  void initState() {
    super.initState();

    // Sử dụng initialSolarDate nếu được cung cấp, nếu không thì sử dụng ngày hiện tại
    _selectedDate = widget.initialSolarDate ?? DateTime.now();

    // Nếu initialLunarDate được cung cấp, chuyển đổi nó thành ngày dương lịch và sử dụng
    if (widget.initialLunarDate != null) {
      try {
        // Chuyển đổi từ âm lịch sang dương lịch
        final solarDate = widget.initialLunarDate!.toSolar();

        if (solarDate.year > 0) {
          _selectedDate = solarDate;
        }
      } catch (e) {
        // Nếu có lỗi khi chuyển đổi, giữ nguyên giá trị mặc định
      }
    }

    // Hiển thị tháng chứa ngày được chọn
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _currentView = CalendarView.month;

    // Tính toán trang ban đầu dựa trên sự chênh lệch tháng
    final now = DateTime.now();
    final monthDiff = (_displayedMonth.year - now.year) * 12 +
        (_displayedMonth.month - now.month);
    _pageController = PageController(initialPage: _initialPage + monthDiff);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getMonthForPage(int page) {
    final monthDiff = page - _initialPage;
    return DateTime(
      DateTime.now().year,
      DateTime.now().month + monthDiff,
    );
  }

  List<LunarEvent> _getEventsForDate() {
    return widget.events.where((event) {
      if (event.solarDate != null) {
        return event.solarDate!.year == _selectedDate.year &&
            event.solarDate!.month == _selectedDate.month &&
            event.solarDate!.day == _selectedDate.day &&
            event.solarDate!.year == _displayedMonth.year &&
            event.solarDate!.month == _displayedMonth.month;
      }

      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme =
        widget.theme ?? LunarCalendarTheme.fromTheme(Theme.of(context));
    final theme = baseTheme.copyWith(
      showOutsideDays: widget.showOutsideDays ?? baseTheme.showOutsideDays,
    );
    final localization = widget.localization ?? LunarCalendarLocalization.vi;

    final monthEvents = _getEventsForDate();

    return LayoutBuilder(builder: (context, constraints) {
      final deviceWidth = constraints.maxWidth;

      final maxWidth = widget.maxWidth != null
          ? deviceWidth > widget.maxWidth!
              ? widget.maxWidth!
              : deviceWidth
          : deviceWidth;
      final heightOfCell = (theme.fontSize + theme.subtextFontSize) * 1.5 + 16;
      final displayedMonth = _displayedMonth;
      final days = DateUtils.daysInMonth(displayedMonth);

      final numberOfRows = days.length ~/ 7;
      final calendarHeight = numberOfRows * heightOfCell;

      return Material(
        color: theme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            CalendarHeader(
              displayedMonth: _displayedMonth,
              currentView: _currentView,
              theme: theme,
              localization: localization,
              maxWidth: maxWidth,
              showTodayButton: widget.showTodayButton,
              onMonthChanged: (date) {
                final monthDiff = (date.year - _displayedMonth.year) * 12 +
                    date.month -
                    _displayedMonth.month;
                _pageController.animateToPage(
                  _pageController.page!.round() + monthDiff,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              onViewChanged: (view) {
                setState(() => _currentView = view);
              },
              onTodayPressed: () {
                final now = DateTime.now();
                setState(() {
                  _selectedDate = now;
                  _displayedMonth = now;
                });

                widget.onDateSelected?.call(now, LunarUtils.solarToLunar(now));
                _pageController.jumpToPage(_initialPage);
              },
            ),
            if (widget.enableDrag)
              NotificationListener(
                onNotification: (notification) {
                  return true;
                },
                child: _buildWeekdayHeader(theme, localization, maxWidth),
              )
            else
              _buildWeekdayHeader(theme, localization, maxWidth),
            buildCalendar(
                calendarHeight, maxWidth, theme, localization, heightOfCell),
            // Event section
            if (widget.showEvents && _currentView.isMonth && monthEvents.isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Text(
                  localization.get('events'),
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: theme.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.enableDrag)
                NotificationListener(
                  onNotification: (notification) {
                    return true;
                  },
                  child: _buildEventSection(
                      theme, localization, maxWidth, monthEvents),
                )
              else
                _buildEventSection(theme, localization, maxWidth, monthEvents),
            ],
          ],
        ),
      );
    });
  }

  Widget buildCalendar(
      double calendarHeight,
      double maxWidth,
      LunarCalendarTheme theme,
      LunarCalendarLocalization localization,
      double heightOfCell) {
    return Container(
      height: calendarHeight,
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (page) {
          setState(() {
            _displayedMonth = _getMonthForPage(page);
          });
        },
        itemBuilder: (context, page) {
          final month = _getMonthForPage(page);
          return _buildMonthView(
            theme,
            localization,
            month,
            maxWidth,
            calendarHeight,
            heightOfCell,
          );
        },
      ),
    );
  }

  Widget _buildWeekdayHeader(
    LunarCalendarTheme theme,
    LunarCalendarLocalization localization,
    double maxWidth,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.primaryColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: List.generate(7, (index) {
          final date = DateTime(2024, 1, index + 1);
          return Expanded(
            child: Text(
              DateUtils.weekdayName(
                date,
                short: true,
                localization: localization,
              ),
              style: TextStyle(
                color: date.weekday == 7
                    ? theme.sundayColor
                    : date.weekday == 6
                        ? theme.saturdayColor
                        : theme.textColor,
                fontSize: theme.fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMonthView(
    LunarCalendarTheme theme,
    LunarCalendarLocalization localization,
    DateTime month,
    double maxWidth,
    double calendarHeight,
    double heightOfCell,
  ) {
    final days = DateUtils.daysInMonth(month);
    final widthOfCell = maxWidth / 7;

    return Container(
      width: maxWidth,
      height: calendarHeight,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: widthOfCell / heightOfCell,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        shrinkWrap: true,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final lunarDate = LunarUtils.solarToLunar(date);
          final isCurrentMonth = date.month == month.month;
          final events = widget.events.where((e) => e.occursOn(date)).toList();

          return DayCell(
            date: date,
            lunarDate: lunarDate,
            selectedDate: _selectedDate,
            isCurrentMonth: isCurrentMonth,
            theme: theme,
            events: events.map((e) => e.title).toList(),
            onDateSelected: (date) => _onDateTapped(date),
          );
        },
      ),
    );
  }

  Widget _buildEventSection(
    LunarCalendarTheme theme,
    LunarCalendarLocalization localization,
    double maxWidth,
    List<LunarEvent> events,
  ) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: events.length,
        separatorBuilder: (context, index) => Divider(
          color: theme.primaryColor.withOpacity(0.1),
          height: 16,
        ),
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getEventIcon(event.type),
                    color: theme.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    event.title,
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: theme.fontSize,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getEventIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'birthday':
        return Icons.cake;
      case 'meeting':
        return Icons.groups;
      case 'holiday':
        return Icons.celebration;
      case 'reminder':
        return Icons.notifications;
      case 'task':
        return Icons.task_alt;
      case 'anniversary':
        return Icons.favorite;
      default:
        return Icons.event_note;
    }
  }

  void _onDateTapped(DateTime date) {
    setState(() => _selectedDate = date);
    final lunarDate = LunarUtils.solarToLunar(date);
    widget.onDateSelected?.call(date, lunarDate);
  }
}
