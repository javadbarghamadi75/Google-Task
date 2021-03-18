import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:google_task/res.dart';
import 'package:intl/intl.dart';

class AddBottomSheet extends StatefulWidget {
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
        left: padding24,
        top: padding24,
        right: padding24,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _newTaskTextField(),
          _addDetailsTextField(),
          _selectedDateAndTimeChip(),
          _buttonsRow(), //TODO : must check different ways to creat a task
        ],
      ),
    );
  }

  _newTaskTextField() {
    return Padding(
      padding: const EdgeInsets.only(
        // left: padding24,
        // top: padding24,
        // right: padding24,
        bottom: padding8,
      ),
      child: TextField(
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
    );
  }

  _addDetailsTextField() {
    return _addDetailsTextFieldVisibility
        ? Padding(
            padding: const EdgeInsets.only(
              // left: padding24,
              // right: padding24,
              bottom: padding8,
            ),
            child: TextField(
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
            ),
          )
        : Container();
  }

  _selectedDateAndTimeChip() {
    return (_selectedDate == null)
        ? Container()
        : Chip(
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
          );
  }

  _buttonsRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              // left: padding12,
              // bottom: padding8,
              ),
          child: Row(
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
        ),
        Padding(
          padding: const EdgeInsets.only(
              // left: padding24,
              // right: padding24,
              // bottom: padding8,
              ),
          child: TextButton(
            onPressed: () {
              print(_newTaskInput.text);
              print(_addDetailsInput.text);
              print(_chipDateText);
              print(_chipTimeText);
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
        ),
      ],
    );
  }
}
