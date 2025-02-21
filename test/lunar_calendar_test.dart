import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar_plus/lunar_calendar.dart';

void main() {
  group('LunarCalendar Widget Tests', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LunarCalendar(),
          ),
        ),
      );

      expect(find.byType(LunarCalendar), findsOneWidget);
      expect(find.byType(CalendarHeader), findsOneWidget);
    });

    testWidgets('shows events when provided', (WidgetTester tester) async {
      final events = [
        LunarEvent(
          title: 'Test Event',
          type: 'birthday',
          solarDate: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LunarCalendar(
              events: events,
            ),
          ),
        ),
      );

      expect(find.text('Test Event'), findsOneWidget);
      expect(find.byIcon(Icons.cake), findsOneWidget);
    });

    testWidgets('handles date selection', (WidgetTester tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LunarCalendar(
              onDateSelected: (date) {
                selectedDate = date;
              },
            ),
          ),
        ),
      );

      // Find and tap a day cell
      final dayCell = find.byType(DayCell).first;
      await tester.tap(dayCell);
      await tester.pump();

      expect(selectedDate, isNotNull);
    });

    testWidgets('shows/hides outside days', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LunarCalendar(
              showOutsideDays: false,
            ),
          ),
        ),
      );

      final theme = LunarCalendarTheme.fromTheme(ThemeData.light());
      final outsideDayFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Text && widget.style?.color == theme.outsideDayColor,
      );

      expect(outsideDayFinder, findsNothing);
    });

    testWidgets('shows today button when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LunarCalendar(
              showTodayButton: true,
            ),
          ),
        ),
      );

      expect(find.text('Hôm nay'), findsOneWidget);
    });

    testWidgets('respects max width constraint', (WidgetTester tester) async {
      const maxWidth = 300.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LunarCalendar(
              maxWidth: maxWidth,
            ),
          ),
        ),
      );

      final calendarFinder = find.byType(LunarCalendar);
      final calendarSize = tester.getSize(calendarFinder);

      expect(calendarSize.width, lessThanOrEqualTo(maxWidth));
    });
  });

  group('LunarEvent Tests', () {
    test('creates event with solar date', () {
      final event = LunarEvent(
        title: 'Test Event',
        solarDate: DateTime(2024, 3, 15),
      );

      expect(event.title, 'Test Event');
      expect(event.solarDate?.year, 2024);
      expect(event.solarDate?.month, 3);
      expect(event.solarDate?.day, 15);
    });

    test('creates event with lunar date', () {
      final event = LunarEvent(
        title: 'Test Event',
        lunarDate: LunarDate(
          day: 15,
          month: 7,
          year: 2024,
        ),
      );

      expect(event.title, 'Test Event');
      expect(event.lunarDate?.day, 15);
      expect(event.lunarDate?.month, 7);
      expect(event.lunarDate?.year, 2024);
    });
  });
}
