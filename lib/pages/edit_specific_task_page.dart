import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/tasks_model.dart';
import 'package:google_task/pages/home_page.dart';
import 'package:google_task/res.dart';
import 'package:intl/intl.dart';

class EditSpecificTaskPage extends StatefulWidget {
  final Tasks theTask;
  final Function updateTask;
  // final String theTaskName;
  // final String theTaskDetail;
  // final String theTaskDate;
  // final String theTaskTime;

  EditSpecificTaskPage({
    this.theTask,
    // this.theTaskName,
    // this.theTaskDetail,
    // this.theTaskDate,
    // this.theTaskTime,
    this.updateTask,
  });

  @override
  _EditSpecificTaskPageState createState() => _EditSpecificTaskPageState();
}

class _EditSpecificTaskPageState extends State<EditSpecificTaskPage> {
  //String _taskList;
  int _theTaskStatus;
  String _theTaskName = '';
  String _theTaskDetail = '';
  String _theTaskDate;
  String _theTaskTime;
  Tasks theUpdatedTask = Tasks();
  String _setTimeText = 'Set Time';
  DateTime _selectedDate;
  TimeOfDay _selectedTime = nowTime;
  String _chipDateText;
  String _chipTimeText;

  // TextEditingController _taskNameController = TextEditingController();
  // TextEditingController _taskDetailController = TextEditingController();

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
  void initState() {
    _setTheTaskFields();
    super.initState();
  }

  _setTheTaskFields() {
    setState(() {
      _theTaskStatus = widget.theTask.taskStatus;
      _theTaskName = widget.theTask.taskName;
      _theTaskDetail = widget.theTask.taskDetail;
      _theTaskDate = widget.theTask.taskDate;
      _theTaskTime = widget.theTask.taskTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        theUpdatedTask = Tasks(
          taskName: _theTaskName,
          taskDetail: _theTaskDetail,
          taskDate: _theTaskDate,
          taskTime: _theTaskTime,
        );
        theUpdatedTask.taskStatus = _theTaskStatus;
        theUpdatedTask.taskId = widget.theTask.taskId;
        DatabaseHelper.instance.updateTask(theUpdatedTask);
        widget.updateTask;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // DatabaseHelper.instance.deleteTask(widget.theTask.taskId);
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            _listDropDown(),
            _taskTitle(),
            _taskSubTitle(),
            _taskDateAndTime(),
            _addSubtask(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: TextButton(
            onPressed: () {
              (_theTaskStatus == 0) ? _theTaskStatus = 1 : _theTaskStatus = 0;
              DatabaseHelper.instance.updateTask(theUpdatedTask);
              widget.updateTask;
              // Navigator.pop(context);
            },
            child: (_theTaskStatus == 0)
                ? Text('Mark completed')
                : Text('Mark uncompleted'),
          ),
        ),
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

  _taskTitle() {
    return ListTile(
      title: TextFormField(
        // controller: _taskNameController,
        maxLines: null,
        initialValue: _theTaskName,
        onChanged: (value) {
          _theTaskName = value;
        },
        decoration: InputDecoration.collapsed(
          hintText: 'Enter title',
        ),
      ),
    );
  }

  _taskSubTitle() {
    return ListTile(
      leading: Icon(Icons.sort),
      title: TextFormField(
        // controller: _taskDetailController,
        maxLines: null,
        initialValue: _theTaskDetail,
        onChanged: (value) {
          _theTaskDetail = value;
        },
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
          ? TextFormField(
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
