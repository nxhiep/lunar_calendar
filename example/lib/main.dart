import 'package:flutter/material.dart';
import 'package:lunar_calendar_plus/lunar_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: MyHomePage(
        onThemeChanged: _toggleThemeMode,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final VoidCallback onThemeChanged;
  final bool isDarkMode;

  const MyHomePage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isVietnamese = true;

  @override
  Widget build(BuildContext context) {
    const testLunarDate = LunarDate(
      day: 1,
      month: 1,
      year: 2025,
      isLeapMonth: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Example'),
        actions: [
          // Switch theme
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeChanged,
          ),
          // Switch language
          IconButton(
            icon: Text(_isVietnamese ? 'VI' : 'EN'),
            onPressed: () {
              setState(() {
                _isVietnamese = !_isVietnamese;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          LunarCalendarPicker(
            initialSolarDate: DateTime(2025, 2, 14),
            maxWidth: 300,
            onDateSelected: (date, lunarDate) {
              print('Selected date: $date');
              print('Selected lunar date: $lunarDate');
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LunarCalendar(
              theme: widget.isDarkMode ? LunarCalendarTheme.dark : null,
              showOutsideDays: false,
              showTodayButton: true,
              localization: _isVietnamese
                  ? LunarCalendarLocalization.vi
                  : LunarCalendarLocalization.en,
              initialLunarDate: testLunarDate,
              onDateSelected: (date, lunarDate) {
                print('Selected date: $date');
                print('Selected lunar date: $lunarDate');
              },
              events: [
                LunarEvent(
                  title: 'Ngày Valentine',
                  solarDate: DateTime(2025, 2, 14),
                ),
                LunarEvent(
                  title: 'Ngày Valentine',
                  solarDate: DateTime(2025, 2, 14),
                ),
                LunarEvent(
                  title: 'Ngày Valentine',
                  solarDate: DateTime(2025, 2, 14),
                ),
                LunarEvent(
                  title: 'Ngày Valentine',
                  solarDate: DateTime(2025, 2, 14),
                ),
                LunarEvent(
                  title: 'Ngày Valentine',
                  solarDate: DateTime(2025, 2, 14),
                ),
                LunarEvent(
                  title: 'Ngày Valentine',
                  solarDate: DateTime(2025, 2, 14),
                ),
                LunarEvent(
                  title: 'Ngày Valentine',
                  solarDate: DateTime(2025, 2, 14),
                ),
                LunarEvent(
                  title: 'Ngày Valentine',
                  solarDate: DateTime(2025, 2, 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
