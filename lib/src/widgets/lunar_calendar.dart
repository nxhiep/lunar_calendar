import 'package:flutter/material.dart' hide DateUtils;

import '../localization/lunar_calendar_localization.dart';
import '../models/calendar_view.dart';
import '../models/lunar_event.dart';
import '../theme/lunar_calendar_theme.dart';
import '../utils/date_utils.dart';
import '../utils/event_utils.dart';
import '../utils/lunar_utils.dart';
import 'calendar_header.dart';
import 'day_cell.dart';

class LunarCalendar extends StatefulWidget {
  final LunarCalendarTheme? theme;

  final LunarCalendarLocalization? localization;

  final ValueChanged<DateTime>? onDateSelected;

  /// Có hiển thị ngày của tháng khác không
  final bool? showOutsideDays;

  final List<LunarEvent> events;

  final double? maxWidth;

  const LunarCalendar({
    super.key,
    this.theme,
    this.localization,
    this.onDateSelected,
    this.showOutsideDays,
    this.events = const [],
    this.maxWidth,
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
    _selectedDate = DateTime.now();
    _displayedMonth = DateTime.now();
    _currentView = CalendarView.month;
    _pageController = PageController(initialPage: _initialPage);
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

    return Material(
      color: theme.backgroundColor,
      child: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = widget.maxWidth != null
            ? constraints.maxWidth > widget.maxWidth!
                ? widget.maxWidth
                : constraints.maxWidth
            : constraints.maxWidth;
        final heightOfCell =
            (theme.fontSize + theme.subtextFontSize) * 1.25 + 10;
        final calendarHeight = 5 * heightOfCell + 5 * 8;

        return Column(
          children: [
            CalendarHeader(
              displayedMonth: _displayedMonth,
              currentView: _currentView,
              theme: theme,
              localization: localization,
              maxWidth: maxWidth,
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
                _pageController.jumpToPage(_initialPage);
              },
            ),

            if (_currentView.isMonth) ...[
              _buildWeekdayHeader(theme, localization, maxWidth),
              Container(
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
              ),
            ] else
              _buildYearView(theme, localization),

            // Event section
            if (_currentView.isMonth)
              ..._buildEventSection(theme, localization, maxWidth),
          ],
        );
      }),
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
    final widthOfCell = (maxWidth - 8 * 7) / 7;
    final childAspectRatio = widthOfCell / heightOfCell;

    return Container(
      width: maxWidth,
      height: calendarHeight,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: childAspectRatio,
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

  Widget _buildYearView(
    LunarCalendarTheme theme,
    LunarCalendarLocalization localization,
  ) {
    final months = DateUtils.monthsInYear(_displayedMonth.year);

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      shrinkWrap: true,
      itemCount: months.length,
      itemBuilder: (context, index) {
        final month = months[index];
        final events = EventUtils.getEventsForMonth(month, widget.events);

        return InkWell(
          onTap: () {
            setState(() {
              _displayedMonth = month;
              _currentView = CalendarView.month;
            });
          },
          borderRadius: BorderRadius.circular(theme.borderRadius),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(theme.borderRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateUtils.monthName(month, localization: localization),
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: theme.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (events.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.eventColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildEventSection(
    LunarCalendarTheme theme,
    LunarCalendarLocalization localization,
    double maxWidth,
  ) {
    final monthEvents = _getEventsForDate();
    if (monthEvents.isEmpty) return [];

    return [
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          border: Border(
            top: BorderSide(
              color: theme.primaryColor.withOpacity(0.1),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.star,
              color: theme.eventColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                monthEvents.first.title,
                style: TextStyle(
                  color: theme.textColor,
                  fontSize: theme.fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void _onDateTapped(DateTime date) {
    setState(() => _selectedDate = date);
    widget.onDateSelected?.call(date);
  }
}
