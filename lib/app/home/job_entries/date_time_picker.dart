import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/job_entries/format.dart';
import 'package:my_time_tracker/app/home/job_entries/input_dropdown.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:provider/provider.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.onSelectDate,
    this.onSelectTime,
    @required this.enabled,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<TimeOfDay> onSelectTime;
  final bool enabled;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectDate(pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null && pickedTime != selectedTime) {
      onSelectTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle =
        CustomTextStyles.textStyleBold(fontSize: 19.0, color: Colors.black);
    final format = Provider.of<Format>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: InputDropdown(
            labelText: labelText,
            valueText: format.date(selectedDate),
            valueStyle: valueStyle,
            onPressed: enabled ? () =>_selectDate(context) : null,
          ),
        ),
        SizedBox(width: 30.0),
        Expanded(
          flex: 4,
          child: InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: enabled ? () => _selectTime(context) : null,
          ),
        ),
      ],
    );
  }
}
