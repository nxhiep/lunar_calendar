import 'package:flutter/material.dart';

import '../localization/lunar_calendar_localization.dart';
import '../models/lunar_event.dart';
import '../theme/lunar_calendar_theme.dart';
import '../utils/lunar_utils.dart';

class EventDialog extends StatefulWidget {
  final DateTime date;
  final LunarEvent? event;
  final LunarCalendarTheme theme;
  final LunarCalendarLocalization localization;

  const EventDialog({
    super.key,
    required this.date,
    required this.theme,
    required this.localization,
    this.event,
  });

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late bool _isLunar;
  late bool _isYearlyRecurring;
  late bool _isMonthlyRecurring;
  DateTime? _reminder;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _titleController = TextEditingController(text: event?.title);
    _descriptionController = TextEditingController(text: event?.description);
    _isLunar = event?.lunarDate != null;
    _isYearlyRecurring = event?.isYearlyRecurring ?? false;
    _isMonthlyRecurring = event?.isMonthlyRecurring ?? false;
    _reminder = event?.reminder;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNewEvent = widget.event == null;
    final lunarDate = LunarUtils.solarToLunar(widget.date);

    return Dialog(
      backgroundColor: widget.theme.backgroundColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                isNewEvent
                    ? widget.localization.get('new_event')
                    : widget.localization.get('edit_event'),
                style: TextStyle(
                  color: widget.theme.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề sự kiện
                    TextField(
                      controller: _titleController,
                      style: TextStyle(color: widget.theme.textColor),
                      decoration: InputDecoration(
                        labelText: widget.localization.get('event_title'),
                        labelStyle: TextStyle(color: widget.theme.subtextColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: widget.theme.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mô tả sự kiện
                    TextField(
                      controller: _descriptionController,
                      style: TextStyle(color: widget.theme.textColor),
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: widget.localization.get('event_description'),
                        labelStyle: TextStyle(color: widget.theme.subtextColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: widget.theme.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Chọn loại lịch
                    Row(
                      children: [
                        Radio<bool>(
                          value: false,
                          groupValue: _isLunar,
                          onChanged: (value) =>
                              setState(() => _isLunar = value!),
                          activeColor: widget.theme.primaryColor,
                        ),
                        Text(
                          widget.localization.get('solar'),
                          style: TextStyle(color: widget.theme.textColor),
                        ),
                        const SizedBox(width: 16),
                        Radio<bool>(
                          value: true,
                          groupValue: _isLunar,
                          onChanged: (value) =>
                              setState(() => _isLunar = value!),
                          activeColor: widget.theme.primaryColor,
                        ),
                        Text(
                          widget.localization.get('lunar'),
                          style: TextStyle(color: widget.theme.textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Lặp lại sự kiện
                    CheckboxListTile(
                      value: _isYearlyRecurring,
                      onChanged: (value) =>
                          setState(() => _isYearlyRecurring = value!),
                      title: Text(
                        widget.localization.get('yearly_recurring'),
                        style: TextStyle(color: widget.theme.textColor),
                      ),
                      activeColor: widget.theme.primaryColor,
                    ),
                    CheckboxListTile(
                      value: _isMonthlyRecurring,
                      onChanged: (value) =>
                          setState(() => _isMonthlyRecurring = value!),
                      title: Text(
                        widget.localization.get('monthly_recurring'),
                        style: TextStyle(color: widget.theme.textColor),
                      ),
                      activeColor: widget.theme.primaryColor,
                    ),

                    // Đặt nhắc nhở
                    ListTile(
                      title: Text(
                        widget.localization.get('set_reminder'),
                        style: TextStyle(color: widget.theme.textColor),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          _reminder != null ? Icons.alarm_on : Icons.alarm_add,
                          color: widget.theme.primaryColor,
                        ),
                        onPressed: _showReminderPicker,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: widget.theme.subtextColor,
                    ),
                    child: Text(widget.localization.get('cancel')),
                  ),
                  TextButton(
                    onPressed: _saveEvent,
                    style: TextButton.styleFrom(
                      foregroundColor: widget.theme.primaryColor,
                    ),
                    child: Text(widget.localization.get('save')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showReminderPicker() async {
    final now = DateTime.now();
    final initialTime = _reminder ?? now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialTime,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: widget.theme.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme:
                  ColorScheme.light(primary: widget.theme.primaryColor),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _reminder = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveEvent() {
    if (_titleController.text.isEmpty) return;

    final event = LunarEvent(
      title: _titleController.text,
      description: _descriptionController.text,
      solarDate: _isLunar ? null : widget.date,
      lunarDate: _isLunar ? LunarUtils.solarToLunar(widget.date) : null,
      isYearlyRecurring: _isYearlyRecurring,
      isMonthlyRecurring: _isMonthlyRecurring,
      reminder: _reminder,
    );

    Navigator.of(context).pop(event);
  }
}
