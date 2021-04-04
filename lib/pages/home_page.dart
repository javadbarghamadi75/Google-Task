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
  // final String
  //     selectedListName; //ino ezafe kardam ba null dar main ta check shavad heder ba in va titlesh

  // HomePage(this.selectedListName);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future<List<Tasks>> _tasksList;
  final DateFormat _dateFormat = DateFormat('EEEE, d MMMM');
  // TextEditingController _homePageTitleController = TextEditingController();
  static Lists selectedListFromMenu;
  var selectedList;

  @override
  void initState() {
    selectedList = _updateTasksList();
    super.initState();
  }

  _updateTasksList() {
    setState(() {
      DatabaseHelper.instance.getTasksList();
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
        child: (selectedListFromMenu == null)
            ? Text(
                'My Tasks',
                // controller: _homePageTitleController,
                style: TextStyle(
                  color: myTaskTextColor,
                  fontSize: textSize34,
                  fontFamily: 'Product Sans',
                ),
              )
            : Text(
                selectedListFromMenu.listName,
                // controller: _homePageTitleController,
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
        // TODO : these steps must be check for all pages!
        future: DatabaseHelper.instance.getTasksList(),
        builder: (BuildContext context, AsyncSnapshot<List<Tasks>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print('snapshot.connectionState : ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.done) {
            List<Tasks> filteredTasks = snapshot.data
                .where(
                    (element) => element.listId == selectedListFromMenu?.listId)
                .toList();
            if (filteredTasks != null && filteredTasks.length > 0) {
              print('data : ${snapshot.data.toString()}');
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  print('task status : ${snapshot.data[index].taskStatus}');
                  return _task(filteredTasks[index]);
                },
              );
            } else {
              return Center(
                child: Text('There is No Data!'),
              );
            }
          } else {
            return Text('Connection State : not Done!?');
          }
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
              print('taskStatus : ${theTask.taskStatus}');
              return EditSpecificTaskPage(
                theTask: theTask,
                updateTask: DatabaseHelper.instance.getTasksList,
                // theTaskName: theTask.taskName,
                // theTaskDetail: theTask.taskDetail,
                // theTaskDate: theTask.taskDate,
                // theTaskTime: theTask.taskTime,
              );
            },
          ),
        ).then((value) => this.setState(() {}));
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
            title: (theTask.taskName == null)
                ? null
                : Text(
                    theTask.taskName,
                    style: TextStyle(
                      decoration: (theTask.taskStatus == 0)
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    ),
                  ),
            subtitle: (theTask.taskDetail == null)
                ? null
                : Text(
                    theTask.taskDetail,
                    style: TextStyle(
                      decoration: (theTask.taskStatus == 0)
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    ),
                  ),
            // onTap: () => Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => EditSpecificTaskPage(
            //       theTask: theTask,
            //     ),
            //   ),
            // ),
          ),
          GestureDetector(
            onTap: () {
              print('chip tapped');
            },
            child: (theTask.taskDate == null || theTask.taskTime == null)
                ? null
                : Chip(
                    label: Text(
                        '${_dateFormat.format(DateTime.parse(theTask.taskDate))} | ${theTask.taskTime}'),
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
      ).then((value) => this.setState(() {})),
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
              ).then((value) => this.setState(() {
                    DatabaseHelper.instance.getListsList();
                    selectedListFromMenu = value;
                    print(selectedListFromMenu);
                  }));
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: buildContext,
                builder: (build) => MoreBottomSheet(
                  currentList: selectedListFromMenu,
                ),
                backgroundColor: Colors.transparent,
                // isScrollControlled: true,
              ).then((value) => this.setState(() {}));
            },
          ),
        ],
      ),
    );
  }
}
