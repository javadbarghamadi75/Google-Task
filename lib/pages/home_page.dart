import 'package:flutter/material.dart';
import 'package:google_task/helpers/database_helper.dart';
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
  final DateFormat _dateFormat = DateFormat('EEEE, d MMMM');

  @override
  void initState() {
    _updateTasksList();
    super.initState();
  }

  _updateTasksList() {
    setState(() {
      _tasksList = DatabaseHelper.instance.getTasksList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(DatabaseHelper.instance.getTasksList());
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
    return FutureBuilder<List<Tasks>>(
        future: _tasksList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          print('snapshot.connectionState : ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data.length > 0) {
              print('snapshot.hasData : ${snapshot.hasData}');

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  print('${snapshot.data[index].listId}');
                  return _task(snapshot.data[index]);
                },
              );
            } else if (snapshot.hasData == false &&
                snapshot.data == null &&
                snapshot.data.length == 0) {
              print('snapshot.hasData : ${snapshot.hasData}');
              return Center(
                child: Text('There is No Data!'),
              );
            }
          }
          return Text('Connection State : not Done!?');
        });
  }

  _task(Tasks theTask) {
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
              value: theTask.taskStatus == 0 ? false : true,
              onChanged: (value) {
                theTask.taskStatus = value ? 1 : 0;
                DatabaseHelper.instance.updateTask(theTask);
                _updateTasksList();
              },
            ),
            title: Text(
              theTask.taskName,
              style: TextStyle(
                decoration: (theTask.taskStatus == 0)
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(
              theTask.taskDetail,
              style: TextStyle(
                decoration: (theTask.taskStatus == 0)
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditSpecificTaskPage(
                  task: theTask,
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
                  '${_dateFormat.format(theTask.taskDate)} | ${theTask.taskTime.format(context)}'),
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

  _floatingActionButton(BuildContext buildContext) {
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        context: buildContext,
        builder: (_) => AddBottomSheet(
          updateTasksList: _updateTasksList,
        ),
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
                isScrollControlled: false,
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
