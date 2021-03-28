import 'package:flutter/material.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/lists_model.dart';
import 'package:google_task/models/tasks_model.dart';
import 'package:google_task/pages/edit_specific_task_page.dart';
import 'package:google_task/res.dart';
import 'package:google_task/sheets/add_bottom_sheet.dart';
import 'package:google_task/sheets/menu_bottom_sheet.dart';
import 'package:google_task/sheets/more_bottom_sheet.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Tasks>> _tasksList;
  // Future<int> _list;
  // List<Lists> _listsList;
  // Lists _defaultList;
  final DateFormat _dateFormat = DateFormat('EEEE, d MMMM');
  //final TimeOfDayFormat _timeFormat = TimeOfDayFormat();

  @override
  void initState() {
    // _updateListsList();
    _updateTasksList();
    super.initState();
  }

  // _updateListsList() {
  //   setState(() {
  //     DatabaseHelper.instance.getListsList().then((value) {
  //       if (value == null) {
  //         _defaultList.listName = 'My Tasks';
  //         _list = DatabaseHelper.instance.insertList(_defaultList);
  //         MenuBottomSheet(list: _defaultList, futureInsertListsList: _list);
  //         print('step : creating default list');
  //       }
  //       MenuBottomSheet(futureGetListsList: _listsList);
  //       print('step : getting list of existing lists');
  //     });
  //   });
  // }

  // _updateListsList() async {
  //   _listsList = await DatabaseHelper.instance.getListsList();
  //   if (_listsList == null) {
  //     setState(() {
  //       _defaultList.listName = 'My Tasks';
  //       _list = DatabaseHelper.instance.insertList(_defaultList);
  //       MenuBottomSheet(list: _defaultList, futureInsertListsList: _list);
  //       print('step : creating default list');
  //     });
  //   }
  //   setState(() {
  //     if (_listsList != null) {}
  //     MenuBottomSheet(futureGetListsList: _listsList);
  //     print('step : getting list of existing lists');
  //   });
  // }

  _updateTasksList() {
    setState(() {
      _tasksList = DatabaseHelper.instance.getTasksList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _listView(),
      floatingActionButton: _floatingActionButton(context),
      floatingActionButtonLocation: _floatingActionButtonLocation(),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  _appBar() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(
          left: padding38,
          top: padding28,
        ),
        child: Text(
          'My Tasks',
          style: TextStyle(
            color: myTaskTextColor,
            fontSize: textSize34,
            fontFamily: 'Product Sans',
          ),
        ),
      ),
      backgroundColor: scaffoldBackgroundColor,
      toolbarHeight: toolbarHeight70,
      elevation: 0,
    );
  }

  _listView() {
    return FutureBuilder(
        future: DatabaseHelper.instance.getTasksList(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // final int completedTasksCount = snapshot.data
          //     .where((Tasks tasks) => tasks.taskStatus == 1)
          //     .toList()
          //     .length;

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext buildContext, int index) {
                return _task(snapshot.data[index]);
              });
        });
  }

  Widget _task(Tasks tasks) {
    return GestureDetector(
      onTap: () {
        print('task tapped');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return EditSpecificTaskPage();
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Checkbox(
              value: tasks.taskStatus == 0 ? false : true,
              onChanged: (value) {
                tasks.taskStatus = value ? 1 : 0;
                DatabaseHelper.instance.updateTask(tasks);
                _updateTasksList();
              },
            ),
            title: Text(
              tasks.taskName,
              style: TextStyle(
                decoration: (tasks.taskStatus == 0)
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(
              tasks.taskDetail,
              style: TextStyle(
                decoration: (tasks.taskStatus == 0)
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditSpecificTaskPage(
                  task: tasks,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print('chip tapped');
            },
            child: Chip(
              label: Text(
                  '${_dateFormat.format(tasks.taskDate)} | ${tasks.taskTime.format(context)}'),
              avatar: Icon(
                Icons.today,
                color: saveButtonColor,
                size: iconSize18,
              ),
              // label: (_chipTimeText == null)
              //     ? Text(_chipDateText)
              //     : Text(_chipDateText + ' | ' + _chipTimeText),
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
                  // _selectedDate = null;
                });
              },
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  // _showModalBottomSheet() {
  //   Future<void> showBottomSheet = showModalBottomSheet(
  //     context: context,
  //     builder: (build) => AddBottomSheet(),
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //   );
  //   showBottomSheet.then((value) => _onCloseModalBottomSheet(value));
  // }

  // _onCloseModalBottomSheet(void value) {}

  _floatingActionButton(BuildContext buildContext) {
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        context: buildContext,
        builder: (build) => AddBottomSheet(),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
      ).whenComplete(() => _updateTasksList()),
      child: Icon(
        Icons.add,
        size: iconSize42,
        color: saveButtonColor,
      ),
      backgroundColor: scaffoldBackgroundColor,
    );
  }

  _floatingActionButtonLocation() {
    return FloatingActionButtonLocation.centerDocked;
  }

  _bottomNavigationBar(BuildContext buildContext) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6,
      color: scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              showModalBottomSheet(
                context: buildContext,
                builder: (build) => MenuBottomSheet(),
                backgroundColor: Colors.transparent,
                // isScrollControlled: true,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: buildContext,
                builder: (build) => MoreBottomSheet(),
                backgroundColor: Colors.transparent,
                // isScrollControlled: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
