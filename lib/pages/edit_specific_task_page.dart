import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/lists_model.dart';
import 'package:google_task/models/subtasks_model.dart';
import 'package:google_task/models/tasks_model.dart';
import 'package:google_task/pages/edit_specific_subtask_page.dart';
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
  int _theTaskList;
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

  TextEditingController _enterSubTaskNameController = TextEditingController();
  // TextEditingController _taskDetailController = TextEditingController();
  //
  List<String> listNames = [];
  List<Lists> listOfLists;
  String _selectedList = '';
  List<String> subTasksList = [];

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

  Future<List<SubTasks>> _subTasksList;

  @override
  void initState() {
    _getSubTasksList();
    print(subTasksList.length);
    // setState(() {
    //   _selectedList = listNames[widget.theTask.listId];
    // });
    // _theTaskStatus = widget.theTask.taskStatus;
    // _theTaskName = widget.theTask.taskName;
    // _theTaskDetail = widget.theTask.taskDetail;
    // _theTaskDate = widget.theTask.taskDate;
    // _theTaskTime = widget.theTask.taskTime;
    _getListNames();
    _setTheTaskFields();
    _updateSubTasksList();
    _updateTask();
    super.initState();
  }

  _getSubTasksList() {
    DatabaseHelper.instance
        .getSubTasksList()
        .then((value) => value.forEach((element) {
              subTasksList.add(element.subTaskName);
            }));
  }

  _getListNames() async {
    await DatabaseHelper.instance.getListsList().then((value) => value.forEach(
          (element) {
            listNames.add(element.listName);
          },
        ));
    // listOfLists.forEach((element) {
    //   listNames.add(element.listName);
    // });
    print('listNames : $listNames');
  }

  _updateSubTasksList() {
    setState(() {
      _subTasksList = DatabaseHelper.instance.getSubTasksList();
    });
  }

  _setTheTaskFields() {
    setState(() {
      print('taskStatus set : ${widget.theTask.taskStatus}');
      _theTaskList = widget.theTask.listId;
      _theTaskStatus = widget.theTask.taskStatus;
      _theTaskName = widget.theTask.taskName;
      _theTaskDetail = widget.theTask.taskDetail;
      _theTaskDate = widget.theTask.taskDate;
      _theTaskTime = widget.theTask.taskTime;
    });
  }

  _updateTask() {
    setState(() {
      DatabaseHelper.instance.updateTask(theUpdatedTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        theUpdatedTask = Tasks(
          taskStatus: _theTaskStatus,
          taskName: _theTaskName,
          taskDetail: _theTaskDetail,
          taskDate: _theTaskDate,
          taskTime: _theTaskTime,
        );
        print('taskId ooo : ${theUpdatedTask.taskId}');
        // theUpdatedTask.taskStatus = _theTaskStatus;
        theUpdatedTask.taskId = widget.theTask.taskId;
        theUpdatedTask.listId = widget.theTask.listId;
        print('taskId ooo : ${theUpdatedTask.taskId}');
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
                DatabaseHelper.instance.deleteTask(widget.theTask.taskId);
                Navigator.pop(context);
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
            _subTasksListView(),
            _addSubTask(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: TextButton(
            onPressed: () {
              (_theTaskStatus == 1) ? _theTaskStatus = 0 : _theTaskStatus = 1;
              print('taskStatus ttt : $_theTaskStatus');
              // theUpdatedTask.taskId = widget.theTask.taskId;   ..  causing ui errorssssssssssss
              // theUpdatedTask.taskId = ;
              theUpdatedTask.taskStatus = _theTaskStatus;
              DatabaseHelper.instance.updateTask(theUpdatedTask);
              print('taskStatus zzz : ${theUpdatedTask.taskStatus}');
              // Navigator.pop(context);
              // _updateTask();
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
        underline: Container(),
        hint: Text('List'),
        items: listNames.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        // value: widget.theTask.listId,
        onChanged: (newValue) {
          setState(() {
            _selectedList = newValue;
          });
        },
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

  _subTasksListView() {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: DatabaseHelper.instance.getSubTasksList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SubTasks>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  if (snapshot.data[index].taskId == widget.theTask.taskId) {
                    print(
                        'snapshot.data[index] : ${snapshot.data[index].subTaskName}');
                    return _subTaskTile(snapshot.data[index]);
                  }
                  return Container();
                },
              );
            } else {
              return Container();
            }
          } else {
            return Text('Connection State : not Done!?');
          }
        },
      ),
    );
  }

  _subTaskTile(SubTasks theSubTask) {
    return ListTile(
      leading: Checkbox(
        value: theSubTask.subTaskStatus == 1 ? true : false,
        onChanged: (value) {
          theSubTask.subTaskStatus = value ? 1 : 0;
        },
      ),
      title: TextFormField(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditSpecificSubTaskPage(theSubTask: theSubTask),
              )).then((value) => this.setState(() {
                _updateSubTasksList();
              }));
        },
        readOnly: true,
        initialValue: theSubTask.subTaskName,
        decoration: InputDecoration.collapsed(hintText: null),
      ),
      trailing: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {},
      ),
    );
  }

  _addSubTask() {
    return Column(
      children: [
        ListTile(
          title: TextField(
            controller: _enterSubTaskNameController,
            maxLines: null,
            decoration: InputDecoration.collapsed(
              hintText: 'Enter title',
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            SubTasks createdSubTask = SubTasks(
              subTaskName: _enterSubTaskNameController.text,
              taskId: widget.theTask.taskId,
              subTaskStatus: 0,
            );
            DatabaseHelper.instance.insertSubTask(createdSubTask);
            _updateSubTasksList();
            _enterSubTaskNameController.text = '';
          },
          child: Text('Add subtasks'),
        ),
      ],
    );
  }
}
