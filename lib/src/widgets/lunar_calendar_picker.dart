import 'package:flutter/material.dart';

import '../../lunar_calendar.dart';

enum LunarCalendarPickerMode {
  solar,
  lunar,
}

class LunarCalendarPicker extends StatefulWidget {
  /// Ngày dương lịch ban đầu
  final DateTime? initialSolarDate;

  /// Ngày âm lịch ban đầu
  final LunarDate? initialLunarDate;

  /// Callback khi chọn ngày
  final Function(DateTime solarDate, LunarDate lunarDate) onDateSelected;

  /// Theme của calendar
  final LunarCalendarTheme? theme;

  /// Localization của calendar
  final LunarCalendarLocalization? localization;

  /// Hiển thị cả ngày âm lịch
  final bool showLunarDate;

  /// Format hiển thị ngày
  final String? dateFormat;

  /// Style của text
  final TextStyle? textStyle;

  /// Icon hiển thị bên cạnh text
  final IconData? icon;

  /// Màu của icon
  final Color? iconColor;

  /// Khoảng cách giữa icon và text
  final double iconSpacing;

  /// Text hiển thị thay cho ngày
  final String? dateText;

  /// Mode hiển thị (solar: dương lịch, lunar: âm lịch)
  final LunarCalendarPickerMode displayMode;

  /// Có hiển thị nút Today không
  final bool showTodayButton;

  /// Có hiển thị ngày của tháng khác không
  final bool? showOutsideDays;

  final List<LunarEvent> events;

  final double? maxWidth;

  const LunarCalendarPicker({
    Key? key,
    required this.initialSolarDate,
    required this.onDateSelected,
    this.theme,
    this.localization,
    this.showLunarDate = true,
    this.dateFormat,
    this.textStyle,
    this.icon = Icons.calendar_today,
    this.iconColor,
    this.iconSpacing = 8.0,
    this.dateText,
    this.displayMode = LunarCalendarPickerMode.solar,
    this.showTodayButton = true,
    this.showOutsideDays,
    this.events = const [],
    this.maxWidth,
    this.initialLunarDate,
  }) : super(key: key);

  @override
  State<LunarCalendarPicker> createState() => _LunarCalendarPickerState();
}

class _LunarCalendarPickerState extends State<LunarCalendarPicker> {
  late DateTime? _selectedSolarDate;
  late LunarDate? _selectedLunarDate;

  @override
  void initState() {
    super.initState();
    _selectedSolarDate = widget.initialSolarDate ?? DateTime.now();
    _selectedLunarDate = widget.initialLunarDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        widget.theme ?? LunarCalendarTheme.fromTheme(Theme.of(context));
    final localization = widget.localization ?? LunarCalendarLocalization.vi;

    if (widget.dateText != null) {
      return TextButton(
        onPressed: () => _showDatePickerBottomSheet(context),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                size: 16,
                color: widget.iconColor ?? theme.primaryColor,
              ),
              SizedBox(width: widget.iconSpacing),
            ],
            Text(
              widget.dateText!,
              style: widget.textStyle ??
                  TextStyle(
                    color: theme.textColor,
                    fontSize: theme.fontSize,
                  ),
            ),
          ],
        ),
      );
    }

    String formattedDate;
    if (widget.displayMode == LunarCalendarPickerMode.lunar) {
      formattedDate = widget.dateFormat != null
          ? _formatDate(
              widget.dateFormat!,
              DateTime(_selectedLunarDate!.year, _selectedLunarDate!.month,
                  _selectedLunarDate!.day))
          : '${_selectedLunarDate!.day}/${_selectedLunarDate!.month}/${_selectedLunarDate!.year}';
    } else {
      formattedDate = widget.dateFormat != null
          ? _formatDate(widget.dateFormat!, _selectedSolarDate!)
          : '${_selectedSolarDate!.day}/${_selectedSolarDate!.month}/${_selectedSolarDate!.year}';
    }

    return TextButton(
      onPressed: () => _showDatePickerBottomSheet(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              size: 16,
              color: widget.iconColor ?? theme.primaryColor,
            ),
            SizedBox(width: widget.iconSpacing),
          ],
          Text(
            formattedDate,
            style: widget.textStyle ??
                TextStyle(
                  color: theme.textColor,
                  fontSize: theme.fontSize,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String format, DateTime date) {
    String result = format;
    result = result.replaceAll('dd', date.day.toString().padLeft(2, '0'));
    result = result.replaceAll('d', date.day.toString());
    result = result.replaceAll('MM', date.month.toString().padLeft(2, '0'));
    result = result.replaceAll('M', date.month.toString());
    result = result.replaceAll('yyyy', date.year.toString());
    result = result.replaceAll('yy', date.year.toString().substring(2));
    return result;
  }

  void _showDatePickerBottomSheet(BuildContext context) {
    final theme =
        widget.theme ?? LunarCalendarTheme.fromTheme(Theme.of(context));
    final localization = widget.localization ?? LunarCalendarLocalization.vi;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.backgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localization.get('select_date'),
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: theme.fontSize * 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: theme.textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: LunarCalendar(
                    theme: theme,
                    localization: localization,
                    initialSolarDate: _selectedSolarDate,
                    initialLunarDate: _selectedLunarDate,
                    showOutsideDays: widget.showOutsideDays,
                    events: widget.events,
                    maxWidth: widget.maxWidth,
                    showTodayButton: widget.showTodayButton,
                    onDateSelected: (solarDate, lunarDate) {
                      setState(() {
                        _selectedSolarDate = solarDate;
                        _selectedLunarDate = lunarDate;
                      });
                      Navigator.pop(context);
                      widget.onDateSelected(solarDate, lunarDate);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showCalendarPicker(
    BuildContext context, {
    DateTime? initialSolarDate,
    LunarDate? initialLunarDate,
    required Function(DateTime solarDate, LunarDate lunarDate) onDateSelected,
    LunarCalendarTheme? theme,
    LunarCalendarLocalization? localization,
    bool showOutsideDays = false,
    List<LunarEvent> events = const [],
    double? maxWidth,
    bool showTodayButton = true,
  }) async {
    final baseTheme = theme ?? LunarCalendarTheme.fromTheme(Theme.of(context));
    final lang = localization ?? LunarCalendarLocalization.vi;

    return showModalBottomSheet(
      context: context,
      backgroundColor: baseTheme.backgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.only(
            left: 16,
            top: 16,
            right: 4,
            bottom: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.get('select_date'),
                    style: TextStyle(
                      color: baseTheme.textColor,
                      fontSize: baseTheme.fontSize * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: baseTheme.textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: LunarCalendar(
                  theme: theme,
                  localization: localization,
                  initialSolarDate: initialSolarDate,
                  initialLunarDate: initialLunarDate,
                  showOutsideDays: showOutsideDays,
                  events: events,
                  maxWidth: maxWidth,
                  showTodayButton: showTodayButton,
                  onDateSelected: (solarDate, lunarDate) {
                    Navigator.pop(context);
                    onDateSelected(solarDate, lunarDate);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
