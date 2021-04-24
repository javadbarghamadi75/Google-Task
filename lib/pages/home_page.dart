import 'package:flutter/material.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/lists_model.dart';
import 'package:google_task/models/subtasks_model.dart';
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
  final DateFormat _dateFormat = DateFormat('EEEE, d MMMM');
  static Lists selectedListFromMenu;
  var selectedList;
  static Lists currentList;
  static String currentListName = '';
  static int currentListId;
  // List<SubTasks> subTasksList;
  Future<List<Tasks>> futureTasksList;
  List<Tasks> tasksList = [];
  int taskIndex = 0;
  Future<List<SubTasks>> futureSubTasksList;
  List<SubTasks> subTasksList = [];
  List<SubTasks> subTasksFilteredList = [];

  List<SubTasks> taleb = [];

  @override
  void initState() {
    _getTasksList();
    _getSubTasksList();
    // print('tasksList.length 2 : ${tasksList.length}');
    // print('subTasksList.length 2 : ${subTasksList.length}');
    setState(() {
      _buildDefaultList();
      _updateListsList();
      _updateTasksList();
      _getCurrentSelectedListName();
      // _getTasks();
      // _getSubTasks();
    });
    // _getTasks();
    _getSubTasks();
    super.initState();
  }

  _getTasksList() async {
    // futureTasksList =
    //     DatabaseHelper.instance.getTasksList().then((value) => value);
    // await futureTasksList.then((value) => tasksList.addAll(value));
    await DatabaseHelper.instance
        .getTasksList()
        .then((value) => tasksList.addAll(value));
    // print('tasksList.length 1 : ${tasksList.length}');
  }

  _getSubTasksList() async {
    // futureSubTasksList =
    //     DatabaseHelper.instance.getSubTasksList().then((value) => value);
    // await futureSubTasksList.then((value) => subTasksList.addAll(value));
    await DatabaseHelper.instance
        .getSubTasksList()
        .then((value) => subTasksList.addAll(value));
    // print('subTasksList.length 1 : ${subTasksList.length}');
    taleb.addAll(subTasksList.where((element) => element.taskId == 2));
    // print('subTasks of Task 2 : ${taleb[0].subTaskName}');
    // print('subTasks of Task 2 : ${taleb[1].subTaskName}');
  }

  // _getTasksList() async {
  //   // futureTasksList =
  //   //     DatabaseHelper.instance.getTasksList().then((value) => value);
  //   // await futureTasksList.then((value) => tasksList.addAll(value));
  //   await DatabaseHelper.instance
  //       .getTasksList()
  //       .then((value) => tasksList.addAll(value));
  //   // print('tasksList.length 1 : ${tasksList.length}');
  // }

  // _getSubTasksList() async {
  //   // futureSubTasksList =
  //   //     DatabaseHelper.instance.getSubTasksList().then((value) => value);
  //   // await futureSubTasksList.then((value) => subTasksList.addAll(value));
  //   await DatabaseHelper.instance
  //       .getSubTasksList()
  //       .then((value) => subTasksList.addAll(value));
  //   // print('subTasksList.length 1 : ${subTasksList.length}');
  //   taleb.addAll(subTasksList.where((element) => element.taskId == 2));
  //   // print('subTasks of Task 2 : ${taleb[0].subTaskName}');
  //   // print('subTasks of Task 2 : ${taleb[1].subTaskName}');
  // }

  _updateListsList() {
    DatabaseHelper.instance.getListsList();
  }

  _buildDefaultList() async {
    Future<int> result =
        DatabaseHelper.instance.getListsList().then((value) => value.length);
    int listsListLength = await result;
    if (listsListLength < 1 || listsListLength == null) {
      DatabaseHelper.instance.updateAllList();
      Lists defaultList = Lists(listName: 'My Tasks', listStatus: 1);
      DatabaseHelper.instance.insertList(defaultList);
    }
  }

  _getCurrentSelectedListName() async {
    Future<Lists> currentSelectedList = DatabaseHelper.instance
        .getListsList()
        .then(
            (value) => value.singleWhere((element) => element.listStatus == 1));
    currentList = await currentSelectedList;
    setState(() {
      currentList = currentList;
      currentListName = currentList.listName;
    });
  }

  _updateTasksList() {
    setState(() {
      DatabaseHelper.instance.getTasksList();
    });
  }

  _updateSubTasksList() {
    setState(() {
      DatabaseHelper.instance.getSubTasksList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('tasksList.length 3 : ${tasksList.length}');
    // print('subTasksList.length 3 : ${subTasksList.length}');
    _updateListsList();
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: tasksList.length,
          itemBuilder: (BuildContext buildContext, int index) {
            // taskIndex = index;
            print('index 1 : $index');
            return _taskItem(index);
          },
        ),
      ),
      // body: _listView(),
      floatingActionButton: _floatingActionButton(context),
      floatingActionButtonLocation: _floatingActionButtonLocation(),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  _appBar() {
    // print('currentList : $currentList');
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(
          left: padding38,
          top: padding28,
        ),
        child: Text(
          currentListName,
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

  // _getTasks() {
  //   return FutureBuilder<List<Tasks>>(
  //     future: DatabaseHelper.instance.getTasksList(),
  //     builder: (BuildContext context, AsyncSnapshot<List<Tasks>> taskSnapshot) {
  //       if (taskSnapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else if (taskSnapshot.connectionState == ConnectionState.done) {
  //         tasksList.addAll(taskSnapshot.data);
  //         tasksList = taskSnapshot.data;
  //         print('tasksListtttt : ${tasksList.length}');
  //       } else
  //         return Text('No Data');
  //     },
  //   );
  // }

  _taskItem(int index) {
    print('index 2 : $index');
    // subTasksFilteredList = [];
    // subTasksFilteredList.addAll(
    //   subTasksList
    //       .where(
    //         (element) => element.taskId == index + 1,
    //       )
    //       .toList(),
    // );
    // subTasksFilteredList.forEach((element) {
    //   print('subTasksFilteredList $index : ${element.subTaskName}');
    // });
    // taskIndex = index + 1;
    return Column(
      children: [
        FutureBuilder(
          future: DatabaseHelper.instance.getTasksList(),
          builder: (BuildContext buildContext,
              AsyncSnapshot<List<Tasks>> tasksSnapshot) {
            if (tasksSnapshot.connectionState == ConnectionState.waiting) {
              return Text("${tasksSnapshot.connectionState}");
            }
            if (tasksSnapshot.connectionState == ConnectionState.done) {
              print('taskIndex 3 : $taskIndex');
              taskIndex = tasksSnapshot.data[index].taskId;
              return ListTile(
                title: (tasksSnapshot.data[index].taskName == null)
                    ? Container(height: 0, width: 0)
                    : Text(
                        tasksSnapshot.data[index].taskName,
                        style: TextStyle(
                          decoration:
                              (tasksSnapshot.data[index].taskStatus == 0)
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                        ),
                      ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        // print(
                        //     'taskStatus : ${taskSnapshot.data[mainIndex].taskStatus}');
                        return EditSpecificTaskPage(
                          theTask: tasksSnapshot.data[index],
                          updateTask: DatabaseHelper.instance.getTasksList,
                        );
                      },
                    ),
                  ).then(
                    (value) => {
                      this.setState(() {}),
                      _updateListsList(),
                      _updateTasksList(),
                      // _bodyList(),
                      // _getTasksList(),
                      // _getSubTasksList(),
                      // print('mainIndex print clicked on back : $taskIndex'),
                    },
                  );
                  print('index : $index');
                  print(
                      'tasksList[index].taskId : ${tasksSnapshot.data[index].taskId}');
                  print(
                      'tasksList[index].taskName : ${tasksSnapshot.data[index].taskName}');
                },
              );
            }
            return Text('ridi');
          },
        ),
        FutureBuilder(
          future: DatabaseHelper.instance.getSubTasksList(),
          builder: (BuildContext buildContext,
              AsyncSnapshot<List<SubTasks>> subTasksSnapshot) {
            if (subTasksSnapshot.connectionState == ConnectionState.waiting) {
              return Text('${subTasksSnapshot.connectionState}');
            }
            if (subTasksSnapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: subTasksSnapshot.data
                      .where((element) => element.taskId == taskIndex)
                      .toList()
                      .length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    subTasksList.clear();
                    subTasksList.addAll(subTasksSnapshot.data
                        .where((element) => element.taskId == taskIndex));
                    return ListTile(
                      title: Text('${subTasksList[index].subTaskName}'),
                    );
                  });
            }
            return Text('ridii');
          },
        ),
        // ListView.builder(
        //   physics: NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   itemCount: subTasksFilteredList.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Padding(
        //       padding: EdgeInsets.only(left: padding24),
        //       child: FutureBuilder(
        //         future: DatabaseHelper.instance.getSubTasksList(),
        //         builder: (BuildContext buildContext,
        //             AsyncSnapshot<List<SubTasks>> subTasksSnapshot) {
        //           if (subTasksSnapshot.connectionState ==
        //               ConnectionState.waiting) {
        //             return Text('${subTasksSnapshot.connectionState}');
        //           }
        //           if (subTasksSnapshot.connectionState ==
        //               ConnectionState.done) {
        //             return ListTile(
        //               title: (subTasksSnapshot.data[index].subTaskName == null)
        //                   ? Container(width: 0.0, height: 0.0)
        //                   : Text(
        //                       subTasksList
        //                           .where(
        //                               (element) => element.taskId == taskIndex)
        //                           .toList()[index]
        //                           .subTaskName,
        //                     ),
        //               onTap: () {
        //                 print('index : $index');
        //                 print(
        //                     'subTasksList[index].taskId : ${subTasksSnapshot.data[index].taskId}');
        //                 print(
        //                     'subTasksList[index].taskId : ${subTasksSnapshot.data[index].subTaskId}');
        //                 print(
        //                     'subTasksList[index].taskName : ${subTasksSnapshot.data[index].subTaskName}');
        //               },
        //             );
        //           }
        //         },
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }

  // _taskItem(int index) {
  //   // subTasksFilteredList = [];
  //   subTasksFilteredList.addAll(
  //     subTasksList
  //         .where(
  //           (element) => element.taskId == index + 1,
  //         )
  //         .toList(),
  //   );
  //   subTasksFilteredList.forEach((element) {
  //     print('subTasksFilteredList $index : ${element.subTaskName}');
  //   });
  //   taskIndex = index + 1;
  //   return Column(
  //     children: [
  //       ListTile(
  //         title: (tasksList[index].taskName == null)
  //             ? Container(height: 0, width: 0)
  //             : Text(
  //                 tasksList[index].taskName,
  //                 style: TextStyle(
  //                   decoration: (tasksList[index].taskStatus == 0)
  //                       ? TextDecoration.none
  //                       : TextDecoration.lineThrough,
  //                 ),
  //               ),
  //         onTap: () {
  //           print('index : $index');
  //           print('tasksList[index].taskId : ${tasksList[index].taskId}');
  //           print('tasksList[index].taskName : ${tasksList[index].taskName}');
  //         },
  //       ),
  //       ListView.builder(
  //         physics: NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         itemCount: subTasksFilteredList.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return Padding(
  //             padding: EdgeInsets.only(left: padding24),
  //             child: ListTile(
  //               title: (subTasksFilteredList[index].subTaskName == null)
  //                   ? Container(width: 0.0, height: 0.0)
  //                   : Text(
  //                       subTasksList
  //                           .where((element) => element.taskId == taskIndex)
  //                           .toList()[index]
  //                           .subTaskName,
  //                     ),
  //               onTap: () {
  //                 print('index : $index');
  //                 print(
  //                     'subTasksList[index].taskId : ${subTasksFilteredList[index].taskId}');
  //                 print(
  //                     'subTasksList[index].taskId : ${subTasksFilteredList[index].subTaskId}');
  //                 print(
  //                     'subTasksList[index].taskName : ${subTasksFilteredList[index].subTaskName}');
  //               },
  //             ),
  //           );
  //           // ListTile(
  //           //   title: Text(subTasksFilteredList[index].subTaskName),
  //           // );
  //         },
  //       ),
  //     ],
  //   );
  // }

  // _taskItem(int index) {
  //   subTasksFilteredList = [];
  //   subTasksFilteredList.addAll(
  //     subTasksList
  //         .where(
  //           (element) => element.taskId == index + 1,
  //         )
  //         .toList(),
  //   );
  //   subTasksFilteredList.forEach((element) {
  //     print('subTasksFilteredList $index : ${element.subTaskName}');
  //   });
  //   return Column(
  //     children: [
  //       Column(
  //         children: [
  //           ListTile(
  //             leading: Checkbox(
  //               value: tasksList[index].taskStatus == 0 ? false : true,
  //               onChanged: (value) {
  //                 tasksList[index].taskStatus = value ? 1 : 0;
  //                 DatabaseHelper.instance.updateTask(tasksList[index]);
  //                 _updateTasksList();
  //               },
  //             ),
  //             title: (tasksList[index].taskName == null)
  //                 ? Container(height: 0, width: 0)
  //                 : Text(
  //                     tasksList[index].taskName,
  //                     style: TextStyle(
  //                       decoration: (tasksList[index].taskStatus == 0)
  //                           ? TextDecoration.none
  //                           : TextDecoration.lineThrough,
  //                     ),
  //                   ),
  //             subtitle: (tasksList[index].taskDetail == null)
  //                 ? Container(height: 0, width: 0)
  //                 : Text(
  //                     tasksList[index].taskDetail,
  //                     style: TextStyle(
  //                       decoration: (tasksList[index].taskStatus == 0)
  //                           ? TextDecoration.none
  //                           : TextDecoration.lineThrough,
  //                     ),
  //                   ),
  //             onTap: () {
  //               // print('task tapped');
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (_) {
  //                     // print(
  //                     //     'taskStatus : ${taskSnapshot.data[mainIndex].taskStatus}');
  //                     return EditSpecificTaskPage(
  //                       theTask: tasksList[index],
  //                       updateTask: DatabaseHelper.instance.getTasksList,
  //                     );
  //                   },
  //                 ),
  //               ).then(
  //                 (value) => {
  //                   this.setState(() {}),
  //                   _updateListsList(),
  //                   _updateTasksList(),
  //                   // _bodyList(),
  //                   // _getTasksList(),
  //                   // _getSubTasksList(),
  //                   // print('mainIndex print clicked on back : $taskIndex'),
  //                 },
  //               );
  //             },
  //           ),
  //           (tasksList[index].taskDate == null &&
  //                   tasksList[index].taskTime == null)
  //               ? Container()
  //               : GestureDetector(
  //                   onTap: () {
  //                     print('chip tapped');
  //                   },
  //                   child: (tasksList[index].taskDate == null &&
  //                           tasksList[index].taskTime == null)
  //                       ? Container()
  //                       : Chip(
  //                           label: Text(
  //                               '${_dateFormat.format(DateTime.parse(tasksList[index].taskDate))} | ${tasksList[index].taskTime}'),
  //                           avatar: Icon(
  //                             Icons.today,
  //                             color: saveButtonColor,
  //                             size: iconSize18,
  //                           ),
  //                           // label: (_chipTimeText == null)
  //                           //     ? Text(_chipDateText)
  //                           //     : Text(_chipDateText + ' | ' + _chipTimeText),
  //                           labelStyle: TextStyle(
  //                             fontSize: textSize14,
  //                             color: newTaskTextColor,
  //                           ),
  //                           backgroundColor: transparentColor,
  //                           shape: ContinuousRectangleBorder(
  //                             side: BorderSide(
  //                               color: chipBorderColor,
  //                             ),
  //                             borderRadius:
  //                                 BorderRadius.circular(smallCornerRadius),
  //                           ),
  //                           deleteIcon: Icon(
  //                             Icons.close,
  //                             size: 18,
  //                           ),
  //                           onDeleted: () {
  //                             setState(() {});
  //                           },
  //                         ),
  //                 ),
  //         ],
  //       ),
  //       // ListTile(
  //       //   onTap: () {
  //       //     // print('task tapped');
  //       //     Navigator.push(
  //       //       context,
  //       //       MaterialPageRoute(
  //       //         builder: (_) {
  //       //           // print(
  //       //           //     'taskStatus : ${taskSnapshot.data[mainIndex].taskStatus}');
  //       //           return EditSpecificTaskPage(
  //       //             theTask: tasksList[index],
  //       //             updateTask: DatabaseHelper.instance.getTasksList,
  //       //           );
  //       //         },
  //       //       ),
  //       //     ).then(
  //       //       (value) => {
  //       //         this.setState(() {}),
  //       //         _updateListsList(),
  //       //         _updateTasksList(),
  //       //         // _bodyList(),
  //       //         // _getTasksList(),
  //       //         // _getSubTasksList(),
  //       //         // print('mainIndex print clicked on back : $taskIndex'),
  //       //       },
  //       //     );
  //       //   },
  //       //   title: Text(tasksList[index].taskName),
  //       // ),
  //       ListView.builder(
  //         physics: NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         itemCount: subTasksFilteredList.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return Padding(
  //             padding: EdgeInsets.only(left: padding24),
  //             child: ListTile(
  //               leading: Checkbox(
  //                 value: subTasksFilteredList[index].subTaskStatus == 0
  //                     ? false
  //                     : true,
  //                 onChanged: (value) {
  //                   print(
  //                       "status : ${subTasksFilteredList[index].subTaskStatus}");
  //                   print(
  //                       'subTask index : ${subTasksFilteredList[index].subTaskName}');
  //                   subTasksFilteredList[index].subTaskStatus = value ? 1 : 0;
  //                   DatabaseHelper.instance
  //                       .updateSubTask(subTasksFilteredList[index]);
  //                   _updateSubTasksList();
  //                 },
  //               ),
  //               title: (subTasksFilteredList[index].subTaskName == null)
  //                   ? Container(width: 0.0, height: 0.0)
  //                   : Text(subTasksFilteredList[index].subTaskName),
  //               subtitle: (subTasksFilteredList[index].subTaskDetail == null)
  //                   ? Container(width: 0.0, height: 0.0)
  //                   : Text(subTasksFilteredList[index].subTaskDetail),
  //               onTap: () {},
  //             ),
  //           );
  //           // ListTile(
  //           //   title: Text(subTasksFilteredList[index].subTaskName),
  //           // );
  //         },
  //       ),
  //     ],
  //   );
  // }

  // _bodyList() {
  //   subTasksFilteredList = [];
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     itemCount: tasksList.length,
  //     itemBuilder: (BuildContext buildContex, int index) {
  //       taskIndex = index + 1;
  //       print('index body : $index');
  //       print('taskKndex body : $taskIndex');
  //       return ListTile(
  //         onTap: () {
  //           // print('task tapped');
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) {
  //                 // print(
  //                 //     'taskStatus : ${taskSnapshot.data[mainIndex].taskStatus}');
  //                 return EditSpecificTaskPage(
  //                   theTask: tasksList[index],
  //                   updateTask: DatabaseHelper.instance.getTasksList,
  //                 );
  //               },
  //             ),
  //           ).then(
  //             (value) => {
  //               this.setState(() {}),
  //               _updateListsList(),
  //               _updateTasksList(),
  //               // _bodyList(),
  //               // _getTasksList(),
  //               // _getSubTasksList(),
  //               // print('mainIndex print clicked on back : $taskIndex'),
  //             },
  //           );
  //         },
  //         title: Text(tasksList[index].taskName),
  //         subtitle: ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: subTasksList
  //               .where((element) => element.taskId == taskIndex)
  //               .length,
  //           itemBuilder: (BuildContext buildContext, int index) {
  //             subTasksFilteredList.addAll(
  //                 subTasksList.where((element) => element.taskId == taskIndex));
  //             subTasksFilteredList.forEach((element) {
  //               print('subTasksFilteredList $index : ${element.subTaskName}');
  //             });
  //             return Padding(
  //               padding: const EdgeInsets.only(left: padding28),
  //               child: ListTile(
  //                 title: Text(subTasksFilteredList[index].subTaskName),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // _bodyList() {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     itemCount: tasksList.length,
  //     itemBuilder: (BuildContext buildContex, int index) {
  //       taskIndex = index + 1;
  //       print('index body : $index');
  //       print('taskKndex body : $taskIndex');
  //       return Container(
  //         color: Colors.red,
  //         child: Column(
  //           children: [
  //             ListTile(
  //               onTap: () {
  //                 // print('task tapped');
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (_) {
  //                       // print(
  //                       //     'taskStatus : ${taskSnapshot.data[mainIndex].taskStatus}');
  //                       return EditSpecificTaskPage(
  //                         theTask: tasksList[index],
  //                         updateTask: DatabaseHelper.instance.getTasksList,
  //                       );
  //                     },
  //                   ),
  //                 ).then(
  //                   (value) => {
  //                     this.setState(() {}),
  //                     _updateListsList(),
  //                     _updateTasksList(),
  //                     // _bodyList(),
  //                     // _getTasksList(),
  //                     // _getSubTasksList(),
  //                     // print('mainIndex print clicked on back : $taskIndex'),
  //                   },
  //                 );
  //               },
  //               title: Text(tasksList[index].taskName),
  //             ),
  //             ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: subTasksList
  //                   .where((element) => element.taskId == taskIndex)
  //                   .toList()
  //                   .length,
  //               itemBuilder: (BuildContext buildContext, int index) {
  //                 subTasksFilteredList.addAll(
  //                     subTasksList.where((element) => element.taskId == index));
  //                 return Padding(
  //                   padding: const EdgeInsets.only(left: padding28),
  //                   child: ListTile(
  //                     title: Text(subTasksList[index].subTaskName),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // _talebWidget({int mainIndex}) {
  //   print('mainIndex from body : $mainIndex');
  //   // mainIndex = mainIndex + 1;
  //   // mainIndex = mainIndex + 1;
  //   return Column(
  //     children: [
  //       FutureBuilder(
  //           future: DatabaseHelper.instance.getTasksList(),
  //           builder: (BuildContext context,
  //               AsyncSnapshot<List<Tasks>> taskSnapshot) {
  //             if (taskSnapshot.connectionState == ConnectionState.waiting) {
  //               return Center(child: CircularProgressIndicator());
  //             } else if (taskSnapshot.connectionState == ConnectionState.done) {
  //               print(
  //                   'taskSnapshot.data.first.taskId : ${taskSnapshot.data.first.taskId}');
  //               return ListTile(
  //                   onTap: () {
  //                     // print('task tapped');
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (_) {
  //                           // print(
  //                           //     'taskStatus : ${taskSnapshot.data[mainIndex].taskStatus}');
  //                           return EditSpecificTaskPage(
  //                             theTask: taskSnapshot.data[mainIndex],
  //                             updateTask: DatabaseHelper.instance.getTasksList,
  //                           );
  //                         },
  //                       ),
  //                     ).then(
  //                       (value) => {
  //                         this.setState(() {}),
  //                         _updateListsList(),
  //                         _updateTasksList(),
  //                         _bodyList(),
  //                         _getTasksList(),
  //                         _getSubTasksList(),
  //                         print('mainIndex print clicked on back : $mainIndex'),
  //                       },
  //                     );
  //                   },
  //                   title: Text(taskSnapshot.data[mainIndex].taskName));
  //             }
  //             return Center(child: Text('return of builder'));
  //           }),
  //       FutureBuilder(
  //           future: DatabaseHelper.instance.getSubTasksList().then(
  //                 (value) => value.where((element) {
  //                   print('mainIndex in where : $mainIndex');
  //                   return element.taskId == mainIndex;
  //                 }).toList(),
  //               ),
  //           builder: (BuildContext context,
  //               AsyncSnapshot<List<SubTasks>> subTaskSnapshot) {
  //             if (subTaskSnapshot.connectionState == ConnectionState.waiting) {
  //               return Center(child: CircularProgressIndicator());
  //             } else if (subTaskSnapshot.connectionState ==
  //                 ConnectionState.done) {
  //               return ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: subTasksList
  //                       .where((element) => element.taskId == mainIndex)
  //                       .toList()
  //                       .length,
  //                   itemBuilder: (BuildContext buildContext, int index) {
  //                     return Padding(
  //                       padding: const EdgeInsets.only(left: padding28),
  //                       child: ListTile(
  //                         title: Text(subTaskSnapshot.data[index].subTaskName),
  //                       ),
  //                     );
  //                   });
  //             }
  //             return Center(child: Text('return of builder'));
  //           }),
  //     ],
  //   );
  // }

  // _task() {
  //   return ListTile();
  // }

  // _subTaskList() {
  //   return ListView(
  //     shrinkWrap: true,
  //   );
  // }

  // _task(Tasks task) {
  //   return ListTile(
  //     leading: Checkbox(
  //       value: true,
  //       onChanged: (value) {},
  //     ),
  //     title: (task.taskName == null)
  //         ? Container(width: 0.0, height: 0.0)
  //         : Text(task.taskName),
  //     subtitle: (task.taskDetail == null)
  //         ? Container(width: 0.0, height: 0.0)
  //         : Text(task.taskDetail),
  //     onTap: () {
  //       print('task tapped');
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) {
  //             print('taskStatus : ${task.taskStatus}');
  //             return EditSpecificTaskPage(
  //                 theTask: task,
  //                 updateTask: DatabaseHelper.instance.getTasksList);
  //           },
  //         ),
  //       ).then((value) => this.setState(() {}));
  //     },
  //   );
  // }

  _getSubTasks() {
    return FutureBuilder<List<SubTasks>>(
      future: DatabaseHelper.instance.getSubTasksList(),
      builder: (BuildContext context,
          AsyncSnapshot<List<SubTasks>> subTaskSnapshot) {
        if (subTaskSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (subTaskSnapshot.connectionState == ConnectionState.done) {
        } else
          return Text('No Data');
      },
    );
  }

  // _subTask(SubTasks subTask) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: padding24),
  //     child: ListTile(
  //       leading: Checkbox(
  //         value: true,
  //         onChanged: (value) {},
  //       ),
  //       title: (subTask.subTaskName == null)
  //           ? Container(width: 0.0, height: 0.0)
  //           : Text(subTask.subTaskName),
  //       subtitle: (subTask.subTaskDetail == null)
  //           ? Container(width: 0.0, height: 0.0)
  //           : Text(subTask.subTaskDetail),
  //       onTap: () {},
  //     ),
  //   );
  // }

  // _body() {
  //   for (int i = 1; i <= tasksList.length; i++) {
  //     for (int j = 1; j <= subTasksList.length; j++) {
  //       return ListView(
  //         children: [
  //           _task(tasksList[i]),
  //           _subTask(subTasksList[j]),
  //         ],
  //       );
  //     }
  //   }
  // }

  // _getTasksAndSubTasks() {
  //   return FutureBuilder<List<Tasks>>(
  //       future: DatabaseHelper.instance.getTasksList(),
  //       builder:
  //           (BuildContext context, AsyncSnapshot<List<Tasks>> taskSnapshot) {
  //         if (taskSnapshot.connectionState == ConnectionState.waiting) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //         if (taskSnapshot.connectionState == ConnectionState.done) {
  //           for (int i = 1; i <= taskSnapshot.data.length; i++) {
  //             return ListView(
  //               shrinkWrap: true,
  //               children: [
  //                 ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: taskSnapshot.data.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     print(taskSnapshot.data.first.taskName);
  //                     return _task(taskSnapshot.data[i]);
  //                   },
  //                 ),
  //                 FutureBuilder<List<SubTasks>>(
  //                     future: DatabaseHelper.instance.getSubTasksList(),
  //                     builder: (BuildContext context,
  //                         AsyncSnapshot<List<SubTasks>> subTaskSnapshot) {
  //                       if (subTaskSnapshot.connectionState ==
  //                           ConnectionState.waiting) {
  //                         return Center(
  //                           child: CircularProgressIndicator(),
  //                         );
  //                       }
  //                       if (taskSnapshot.connectionState ==
  //                           ConnectionState.done) {
  //                         return ListView.builder(
  //                           shrinkWrap: true,
  //                           itemCount: subTaskSnapshot.data.length,
  //                           itemBuilder: (BuildContext context, int index) {
  //                             print(subTaskSnapshot.data.first.subTaskName);
  //                             return _subTask(subTaskSnapshot.data[index]);
  //                           },
  //                         );
  //                       }
  //                       return Text('No Data');
  //                     }),
  //               ],
  //             );
  //           }
  //           // return ListView(
  //           //   shrinkWrap: true,
  //           //   children: [
  //           //     ListView.builder(
  //           //       shrinkWrap: true,
  //           //       itemCount: taskSnapshot.data.length,
  //           //       itemBuilder: (BuildContext context, int index) {
  //           //         print(taskSnapshot.data.first.taskName);
  //           //         return _task(taskSnapshot.data[index]);
  //           //       },
  //           //     ),
  //           //     FutureBuilder<List<SubTasks>>(
  //           //         future: DatabaseHelper.instance.getSubTasksList(),
  //           //         builder: (BuildContext context,
  //           //             AsyncSnapshot<List<SubTasks>> subTaskSnapshot) {
  //           //           if (subTaskSnapshot.connectionState ==
  //           //               ConnectionState.waiting) {
  //           //             return Center(
  //           //               child: CircularProgressIndicator(),
  //           //             );
  //           //           }
  //           //           if (taskSnapshot.connectionState ==
  //           //               ConnectionState.done) {
  //           //             return ListView.builder(
  //           //               shrinkWrap: true,
  //           //               itemCount: subTaskSnapshot.data.length,
  //           //               itemBuilder: (BuildContext context, int index) {
  //           //                 print(subTaskSnapshot.data.first.subTaskName);
  //           //                 return _subTask(subTaskSnapshot.data[index]);
  //           //               },
  //           //             );
  //           //           }
  //           //           return Text('No Data');
  //           //         }),
  //           //   ],
  //           // );
  //         }
  //         return Text('No Data');
  //       });
  // }

  // _getTasksAndSubTasks() {
  //   return FutureBuilder<List<Tasks>>(
  //       future: DatabaseHelper.instance.getTasksList(),
  //       builder:
  //           (BuildContext context, AsyncSnapshot<List<Tasks>> taskSnapshot) {
  //         if (taskSnapshot.connectionState == ConnectionState.waiting) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //         if (taskSnapshot.connectionState == ConnectionState.done) {
  //           return ListView(
  //             shrinkWrap: true,
  //             children: [
  //               ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: taskSnapshot.data.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   print(taskSnapshot.data.first.taskName);
  //                   return _task(taskSnapshot.data[index]);
  //                 },
  //               ),
  //               FutureBuilder<List<SubTasks>>(
  //                   future: DatabaseHelper.instance.getSubTasksList(),
  //                   builder: (BuildContext context,
  //                       AsyncSnapshot<List<SubTasks>> subTaskSnapshot) {
  //                     if (subTaskSnapshot.connectionState ==
  //                         ConnectionState.waiting) {
  //                       return Center(
  //                         child: CircularProgressIndicator(),
  //                       );
  //                     }
  //                     if (taskSnapshot.connectionState ==
  //                         ConnectionState.done) {
  //                       return ListView.builder(
  //                         shrinkWrap: true,
  //                         itemCount: subTaskSnapshot.data.length,
  //                         itemBuilder: (BuildContext context, int index) {
  //                           print(subTaskSnapshot.data.first.subTaskName);
  //                           return _subTask(subTaskSnapshot.data[index]);
  //                         },
  //                       );
  //                     }
  //                     return Text('No Data');
  //                   }),
  //             ],
  //           );
  //         }
  //         return Text('No Data');
  //       });
  // }

  // _getTasksAndSubTasks() {
  //   return FutureBuilder(builder:
  //       (BuildContext context, AsyncSnapshot<List<Tasks>> taskSnapshot) {
  //     if (taskSnapshot.connectionState == ConnectionState.waiting) {
  //       return Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     }
  //     if (taskSnapshot.connectionState == ConnectionState.done) {
  //       for (int i = 1; i <= taskSnapshot.data.length; i++) {
  //         return FutureBuilder(
  //             future: DatabaseHelper.instance.getSubTasksList(),
  //             builder: (BuildContext context,
  //                 AsyncSnapshot<List<SubTasks>> subTaskSnapshot) {
  //               if (subTaskSnapshot.connectionState ==
  //                   ConnectionState.waiting) {
  //                 return Center(
  //                   child: CircularProgressIndicator(),
  //                 );
  //               }
  //               if (subTaskSnapshot.connectionState == ConnectionState.done) {
  //                 for (int j = 1; j <= subTaskSnapshot.data.length; j++) {
  //                   return ListView.builder(
  //                     itemCount: ,
  //                       itemBuilder: (BuildContext buildContext, int index) {});
  //                 }
  //               }
  //             });
  //       }
  //     }
  //   });
  // }

  // _item({Tasks task, SubTasks subTask}) {
  //   return ListView(
  //     shrinkWrap: true,
  //     children: [
  //       ListTile(
  //         leading: Checkbox(
  //           value: true,
  //           onChanged: (value) {},
  //         ),
  //         title: (task.taskName == null)
  //             ? Container(width: 0.0, height: 0.0)
  //             : Text(task.taskName),
  //         subtitle: (task.taskDetail == null)
  //             ? Container(width: 0.0, height: 0.0)
  //             : Text(task.taskDetail),
  //         onTap: () {
  //           print('task tapped');
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) {
  //                 print('taskStatus : ${task.taskStatus}');
  //                 return EditSpecificTaskPage(
  //                     theTask: task,
  //                     updateTask: DatabaseHelper.instance.getTasksList);
  //               },
  //             ),
  //           ).then((value) => this.setState(() {}));
  //         },
  //       ),
  //       Padding(
  //         padding: EdgeInsets.only(left: padding24),
  //         child: ListTile(
  //           leading: Checkbox(
  //             value: true,
  //             onChanged: (value) {},
  //           ),
  //           title: (subTask.subTaskName == null)
  //               ? Container(width: 0.0, height: 0.0)
  //               : Text(subTask.subTaskName),
  //           subtitle: (subTask.subTaskDetail == null)
  //               ? Container(width: 0.0, height: 0.0)
  //               : Text(subTask.subTaskDetail),
  //           onTap: () {},
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // _listView() {
  //   return FutureBuilder<List<Tasks>>(
  //       // TODO : these steps must be check for all pages!
  //       future: DatabaseHelper.instance.getTasksList(),
  //       builder: (BuildContext context, AsyncSnapshot<List<Tasks>> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //         print('snapshot.connectionState : ${snapshot.connectionState}');
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           List<Tasks> filteredTasks = snapshot.data
  //               .where((element) => element.listId == currentList.listId)
  //               .toList();
  //           if (filteredTasks != null && filteredTasks.length > 0) {
  //             print('data : ${snapshot.data.toString()}');
  //             return ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: snapshot.data.length,
  //               itemBuilder: (BuildContext buildContext, int index) {
  //                 print('task status : ${snapshot.data[index].taskStatus}');
  //                 return _task(filteredTasks[index]);
  //               },
  //             );
  //           } else {
  //             return Center(
  //               child: Text('There is No Data!'),
  //             );
  //           }
  //         } else {
  //           return Text('Connection State : not Done!?');
  //         }
  //       });
  // }

  // _task(Tasks theTask) {
  //   return GestureDetector(
  //     onTap: () {
  //       print('task tapped');
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) {
  //             print('taskStatus : ${theTask.taskStatus}');
  //             return EditSpecificTaskPage(
  //               theTask: theTask,
  //               updateTask: DatabaseHelper.instance.getTasksList,
  //             );
  //           },
  //         ),
  //       ).then((value) => this.setState(() {}));
  //     },
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         ListTile(
  //           leading: Checkbox(
  //             value: theTask.taskStatus == 0 ? false : true,
  //             onChanged: (value) {
  //               theTask.taskStatus = value ? 1 : 0;
  //               DatabaseHelper.instance.updateTask(theTask);
  //               _updateTasksList();
  //             },
  //           ),
  //           title: (theTask.taskName == null)
  //               ? null
  //               : Text(
  //                   theTask.taskName,
  //                   style: TextStyle(
  //                     decoration: (theTask.taskStatus == 0)
  //                         ? TextDecoration.none
  //                         : TextDecoration.lineThrough,
  //                   ),
  //                 ),
  //           subtitle: (theTask.taskDetail == null)
  //               ? null
  //               : Text(
  //                   theTask.taskDetail,
  //                   style: TextStyle(
  //                     decoration: (theTask.taskStatus == 0)
  //                         ? TextDecoration.none
  //                         : TextDecoration.lineThrough,
  //                   ),
  //                 ),
  //         ),
  //         (theTask.taskDate == null && theTask.taskTime == null)
  //             ? Container()
  //             : GestureDetector(
  //                 onTap: () {
  //                   print('chip tapped');
  //                 },
  //                 child: (theTask.taskDate == null && theTask.taskTime == null)
  //                     ? Container()
  //                     : Chip(
  //                         label: Text(
  //                             '${_dateFormat.format(DateTime.parse(theTask.taskDate))} | ${theTask.taskTime}'),
  //                         avatar: Icon(
  //                           Icons.today,
  //                           color: saveButtonColor,
  //                           size: iconSize18,
  //                         ),
  //                         // label: (_chipTimeText == null)
  //                         //     ? Text(_chipDateText)
  //                         //     : Text(_chipDateText + ' | ' + _chipTimeText),
  //                         labelStyle: TextStyle(
  //                           fontSize: textSize14,
  //                           color: newTaskTextColor,
  //                         ),
  //                         backgroundColor: transparentColor,
  //                         shape: ContinuousRectangleBorder(
  //                           side: BorderSide(
  //                             color: chipBorderColor,
  //                           ),
  //                           borderRadius:
  //                               BorderRadius.circular(smallCornerRadius),
  //                         ),
  //                         deleteIcon: Icon(
  //                           Icons.close,
  //                           size: 18,
  //                         ),
  //                         onDeleted: () {
  //                           setState(() {});
  //                         },
  //                       ),
  //               ),
  //         Divider()
  //       ],
  //     ),
  //   );
  // }

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
              showModalBottomSheet<String>(
                context: buildContext,
                builder: (build) => MenuBottomSheet(
                    // updateHome: _getCurrentSelectedListName(),
                    ),
                backgroundColor: Colors.transparent,
                isScrollControlled: false,
              ).then((value) {
                this.setState(() {
                  currentListName = value;
                });
                print('currentListName : $value');
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () async {
              await showModalBottomSheet<Lists>(
                context: buildContext,
                builder: (build) => MoreBottomSheet(
                  currentList: selectedListFromMenu,
                ),
                backgroundColor: Colors.transparent,
              )
                  .then(
                    (value) => print('value : ${value.listId}'),
                  )
                  .whenComplete(() => _updateTasksList());
            },
          ),
        ],
      ),
    );
  }
}
