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
import 'event_dialog.dart';

class LunarCalendar extends StatefulWidget {
  /// Theme của calendar
  final LunarCalendarTheme? theme;

  /// Ngôn ngữ của calendar
  final LunarCalendarLocalization? localization;

  /// Callback khi chọn ngày
  final ValueChanged<DateTime>? onDateSelected;

  /// Callback khi thêm sự kiện
  final ValueChanged<LunarEvent>? onEventAdded;

  /// Callback khi sửa sự kiện
  final ValueChanged<LunarEvent>? onEventEdited;

  /// Callback khi xóa sự kiện
  final ValueChanged<LunarEvent>? onEventDeleted;

  /// Có hiển thị ngày của tháng khác không
  final bool? showOutsideDays;

  /// Danh sách sự kiện cố định
  final List<LunarEvent> events;

  const LunarCalendar({
    super.key,
    this.theme,
    this.localization,
    this.onDateSelected,
    this.onEventAdded,
    this.onEventEdited,
    this.onEventDeleted,
    this.showOutsideDays,
    this.events = const [], // Default empty list
  });

  @override
  State<LunarCalendar> createState() => _LunarCalendarState();
}

class _LunarCalendarState extends State<LunarCalendar>
    with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  late CalendarView _currentView;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _currentView = CalendarView.month;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isAnimating) return;

    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 200) return; // Ignore slow swipes

    if (velocity < 0) {
      // Swipe left -> next month
      _nextMonth();
    } else {
      // Swipe right -> previous month
      _previousMonth();
    }
  }

  Future<void> _nextMonth() async {
    if (_isAnimating) return;
    _isAnimating = true;

    // Setup animation for next month
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    await _animationController.forward();

    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });

    _animationController.reset();
    _isAnimating = false;
  }

  Future<void> _previousMonth() async {
    if (_isAnimating) return;
    _isAnimating = true;

    // Setup animation for previous month
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    await _animationController.forward();

    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });

    _animationController.reset();
    _isAnimating = false;
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
      child: Column(
        children: [
          CalendarHeader(
            displayedMonth: _displayedMonth,
            currentView: _currentView,
            theme: theme,
            localization: localization,
            onMonthChanged: (date) {
              if (date.isBefore(_displayedMonth)) {
                _previousMonth();
              } else {
                _nextMonth();
              }
            },
            onViewChanged: (view) {
              setState(() => _currentView = view);
            },
            onTodayPressed: () {
              final now = DateTime.now();
              setState(() {
                _selectedDate = now;
                _displayedMonth = DateTime(now.year, now.month);
              });
            },
          ),

          if (_currentView.isMonth) _buildWeekdayHeader(theme, localization),

          // Calendar grid with gesture detection
          if (_currentView.isMonth)
            GestureDetector(
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildMonthView(theme, localization),
              ),
            )
          else
            _buildYearView(theme, localization),

          // Event section at bottom
          if (widget.events.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
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
                      widget.events.first.title,
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: theme.fontSize,
                      ),
                    ),
                  ),
                  Text(
                    localization.get('all_day'),
                    style: TextStyle(
                      color: theme.subtextColor,
                      fontSize: theme.subtextFontSize,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(
    LunarCalendarTheme theme,
    LunarCalendarLocalization localization,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                color: DateUtils.isWeekend(date)
                    ? theme.weekendColor
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
  ) {
    final days = DateUtils.daysInMonth(_displayedMonth);
    final rows = DateUtils.weeksInMonth(_displayedMonth);

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.9,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      shrinkWrap: true,
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        final lunarDate = LunarUtils.solarToLunar(date);
        final isCurrentMonth = date.month == _displayedMonth.month;
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

  void _onDateTapped(DateTime date) {
    setState(() => _selectedDate = date);
    widget.onDateSelected?.call(date);
  }

  Future<void> _showEventDialog(DateTime date, [LunarEvent? event]) async {
    final result = await showDialog<LunarEvent>(
      context: context,
      builder: (context) => EventDialog(
        date: date,
        event: event,
        theme: widget.theme ?? LunarCalendarTheme.fromTheme(Theme.of(context)),
        localization: widget.localization ?? LunarCalendarLocalization.vi,
      ),
    );

    if (result != null) {
      setState(() {
        if (event != null) {
          // Edit event
          widget.events.remove(event);
          widget.events.add(result);
          widget.onEventEdited?.call(result);
        } else {
          // Add new event
          widget.events.add(result);
          widget.onEventAdded?.call(result);
        }
        EventUtils.saveEvents(widget.events);
      });
    }
  }

  Future<void> _showEventList(DateTime date, List<LunarEvent> events) async {
    final theme =
        widget.theme ?? LunarCalendarTheme.fromTheme(Theme.of(context));
    final localization = widget.localization ?? LunarCalendarLocalization.vi;

    await showModalBottomSheet(
      context: context,
      backgroundColor: theme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(theme.borderRadius),
        ),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  DateUtils.formatDate(date),
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: theme.fontSize * 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  color: theme.primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                    _showEventDialog(date);
                  },
                ),
              ],
            ),
          ),

          // Event list
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(
                  event.title,
                  style: TextStyle(color: theme.textColor),
                ),
                subtitle: event.description?.isNotEmpty == true
                    ? Text(
                        event.description!,
                        style: TextStyle(color: theme.subtextColor),
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: theme.primaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                        _showEventDialog(date, event);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: theme.primaryColor,
                      onPressed: () => _showDeleteConfirmation(event),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(LunarEvent event) async {
    final theme =
        widget.theme ?? LunarCalendarTheme.fromTheme(Theme.of(context));
    final localization = widget.localization ?? LunarCalendarLocalization.vi;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          localization.get('delete_event'),
          style: TextStyle(color: theme.textColor),
        ),
        content: Text(
          localization.get('confirm_delete'),
          style: TextStyle(color: theme.textColor),
        ),
        backgroundColor: theme.backgroundColor,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: theme.subtextColor,
            ),
            child: Text(localization.get('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: theme.primaryColor,
            ),
            child: Text(localization.get('delete_event')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        widget.events.remove(event);
        EventUtils.saveEvents(widget.events);
        widget.onEventDeleted?.call(event);
      });
      if (mounted) Navigator.pop(context); // Close event list
    }
  }

  Widget _buildNavButton({required String text, required Color color}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 14,
      ),
    );
  }
}
