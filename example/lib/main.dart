import 'package:flutter/material.dart';
import 'package:lunar_calendar/lunar_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lunar Calendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isVietnamese = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunar Calendar Example'),
        actions: [
          // Nút chuyển đổi ngôn ngữ
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
      body: LunarCalendar(
        theme: null,
        showOutsideDays: false,
        localization: _isVietnamese
            ? LunarCalendarLocalization.vi
            : LunarCalendarLocalization.en,
        onDateSelected: (date) {
          print('Selected date: $date');
        },
        events: [
          LunarEvent(
            title: 'Ngày Valentine',
            solarDate: DateTime(2025, 2, 14),
          ),
          // Thêm các sự kiện khác...
        ],
      ),
    );
  }
}
