import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:google_task/res.dart';
import 'package:intl/intl.dart';

class EditSpecificSubTaskPage extends StatefulWidget {
  @override
  _EditSpecificSubTaskPageState createState() =>
      _EditSpecificSubTaskPageState();
}

class _EditSpecificSubTaskPageState extends State<EditSpecificSubTaskPage> {
  String _setTimeText = 'Set Time';
  DateTime _selectedDate;
  TimeOfDay _selectedTime = nowTime;
  String _chipDateText;
  String _chipTimeText;

  dynamic _showDatePicker(BuildContext buildContext) async {
    DateTime pickedDate = await showRoundedDatePicker(
      context: buildContext,
      initialDate: _selectedDate,
      firstDate: DateTime(todayDate.year - 10),
      lastDate: DateTime(todayDate.year + 10),
      height: MediaQuery.of(context).size.height * 0.35,
      textActionButton: _setTimeText,
      borderRadius: smallCornerRadius,
      styleDatePicker: MaterialRoundedDatePickerStyle(
        paddingDatePicker: EdgeInsets.zero,
        paddingActionBar: EdgeInsets.zero,
        paddingMonthHeader: EdgeInsets.only(top: padding14),
        textStyleButtonAction: TextStyle(
          color: newTaskTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTapActionButton: () {
        Navigator.pop(context);
        _showTimePicker(buildContext);
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
    _chipDateText = DateFormat('EEEE, d MMMM').format(_selectedDate).toString();
  }

  dynamic _showTimePicker(BuildContext buildContext) async {
    TimeOfDay pickedTime = await showRoundedTimePicker(
      context: buildContext,
      initialTime: _selectedTime,
      borderRadius: smallCornerRadius,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        print(_selectedTime);
        _setTimeText = _selectedTime.format(context);
      });
    }
    _chipTimeText = _selectedTime.format(context).toString();
    _showDatePicker(buildContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          _listDropDown(),
          _taskName(),
          _taskDetails(),
          _taskDateAndTime(),
          _addSubtask(),
        ],
      ),
    );
  }

  _listDropDown() {
    return ListTile(
      title: DropdownButton(
        items: null,
        onChanged: null,
        value: 'My Task',
      ),
    );
  }

  _taskName() {
    return ListTile(
      title: TextField(
        maxLines: null,
        decoration: InputDecoration.collapsed(
          hintText: 'Enter title',
        ),
      ),
    );
  }

  _taskDetails() {
    return ListTile(
      leading: Icon(Icons.sort),
      title: TextField(
        maxLines: null,
        decoration: InputDecoration.collapsed(
          hintText: 'Enter title',
        ),
      ),
    );
  }

  _taskDateAndTime() {
    return ListTile(
      leading: Icon(Icons.event_available),
      title: (_selectedDate == null)
          ? TextField(
              readOnly: true,
              maxLines: null,
              decoration: InputDecoration.collapsed(
                hintText: 'Add date/time',
              ),
              onTap: () {
                _showDatePicker(context);
              },
            )
          : GestureDetector(
              onTap: () {
                print('chip tapped');
                _showDatePicker(context);
              },
              child: Chip(
                label: (_chipTimeText == null)
                    ? Text(_chipDateText)
                    : Text(_chipDateText + ' | ' + _chipTimeText),
                labelStyle: TextStyle(
                  fontSize: textSize14,
                  color: newTaskTextColor,
                ),
                backgroundColor: transparentColor,
                shape: ContinuousRectangleBorder(
                  side: BorderSide(
                    color: chipBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(smallCornerRadius),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  size: 18,
                ),
                onDeleted: () {
                  setState(() {
                    _selectedDate = null;
                  });
                },
              ),
            ),
    );
  }

  _addSubtask() {
    return ListTile(
      leading: Icon(Icons.subdirectory_arrow_right),
      title: TextField(
        maxLines: null,
        decoration: InputDecoration.collapsed(
          hintText: 'Add subtasks',
        ),
      ),
    );
  }
}
