import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/tasks_model.dart';
import 'package:google_task/res.dart';
import 'package:intl/intl.dart';

class AddBottomSheet extends StatefulWidget {
  final Function updateTasksList;

  AddBottomSheet({this.updateTasksList});

  @override
  _AddBottomSheetState createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  bool _addDetailsTextFieldVisibility = false;
  String _setTimeText = 'Set Time';
  DateTime _selectedDate;
  TimeOfDay _selectedTime = nowTime;
  String _chipDateText;
  String _chipTimeText;
  final TextEditingController _newTaskInput = TextEditingController();
  final TextEditingController _addDetailsInput = TextEditingController();
  final DateFormat _dateFormat = DateFormat('EEEE, d MMMM');

  dynamic _showDatePicker(BuildContext buildContext) async {
    DateTime pickedDate = await showRoundedDatePicker(
      context: buildContext,
      initialDate: todayDate,
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
  void dispose() {
    _newTaskInput.dispose();
    _addDetailsInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(smallCornerRadius),
          topLeft: Radius.circular(smallCornerRadius),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _newTaskTextField(),
          // _addDetailsTextField(),
          _newTaskAndDetails(), //TODO : check for bugs
          _selectedDateAndTimeChip(),
          _buttonsRow(), //TODO : must check different ways to creat a task
        ],
      ),
    );
  }

  Widget _newTaskAndDetails() {
    return ListTile(
      title: TextField(
        controller: _newTaskInput,
        textInputAction: TextInputAction.done,
        textAlignVertical: TextAlignVertical.center,
        maxLines: 3,
        minLines: 1,
        autofocus: true,
        style: TextStyle(
          fontSize: textSize18,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration.collapsed(
          hintText: 'New task',
          hintStyle: TextStyle(
            fontSize: textSize18,
            fontFamily: 'Product Sans',
            color: newTaskTextColor,
          ),
        ),
      ),
      subtitle: _addDetailsTextFieldVisibility
          ? TextField(
              controller: _addDetailsInput,
              textInputAction: TextInputAction.done,
              textAlignVertical: TextAlignVertical.center,
              maxLines: 1,
              minLines: 1,
              style: TextStyle(
                fontSize: textSize14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration.collapsed(
                hintText: 'Add details',
                hintStyle: TextStyle(
                  fontSize: textSize14,
                  fontFamily: 'Product Sans',
                  color: newTaskTextColor,
                ),
              ),
            )
          : null,
    );
  }

  Widget _selectedDateAndTimeChip() {
    return (_selectedDate == null)
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(
              left: padding16,
              right: padding16,
            ),
            child: Chip(
              avatar: Icon(
                Icons.today,
                color: saveButtonColor,
                size: iconSize18,
              ),
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
          );
  }

  Widget _buttonsRow() {
    return Padding(
      padding: const EdgeInsets.only(
        left: padding16,
        right: padding16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                constraints: BoxConstraints.tightForFinite(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.sort,
                  color: saveButtonColor,
                ),
                onPressed: () {
                  setState(() {
                    _addDetailsTextFieldVisibility =
                        !_addDetailsTextFieldVisibility;
                  });
                },
              ),
              IconButton(
                constraints: BoxConstraints.tightFor(width: 3 * padding24),
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.today,
                  color: saveButtonColor,
                ),
                onPressed: () {
                  _showDatePicker(context);
                },
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              print(_newTaskInput.text);
              print(_addDetailsInput.text);
              print(_chipDateText);
              print(_chipTimeText);
              Tasks newTask = Tasks(
                listId: 1,
                taskStatus: 0,
                taskName: _newTaskInput.text,
                taskDetail: _addDetailsInput.text,
                //taskDate: DateTime.parse(_chipDateText),
                taskDate: _selectedDate,
                taskTime: TimeOfDay(
                  hour: int.parse(_chipTimeText.split(":")[0]),
                  minute: int.parse(_chipTimeText.split(":")[1]),
                ),
              );
              DatabaseHelper.instance.insertTask(newTask);
              widget.updateTasksList;
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: textSize18,
                color: saveButtonColor,
                fontFamily: 'Product Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
