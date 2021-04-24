import 'package:flutter/material.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/lists_model.dart';
import 'package:google_task/res.dart';
import 'package:google_task/sheets/menu_bottom_sheet.dart';

class CreatListPage extends StatefulWidget {
  final Function updateListsList;

  CreatListPage({this.updateListsList});

  @override
  _CreatListPageState createState() => _CreatListPageState();
}

class _CreatListPageState extends State<CreatListPage> {
  TextEditingController textEditingController = TextEditingController();
  Lists lastList;
  int aListIdWithSelectedStatus;

  _getCreatedList() async {
    Future<Lists> lastCreatedList =
        DatabaseHelper.instance.getListsList().then((value) => value.last);
    lastList = await lastCreatedList;
    // DatabaseHelper.instance.updateAllList();
    // // DatabaseHelper.instance
    // //     .getListsList()
    // //     .then((value) => value.where((element) => element.listStatus == 1));
    // Future<Lists> aListWithSelectedStatus = DatabaseHelper.instance
    //     .getListsList()
    //     .then((value) => value.singleWhere(
    //           (element) => element.listStatus == 1,
    //         ));
    // aListIdWithSelectedStatus =
    //     await aListWithSelectedStatus.then((value) => value.listId);
    // print('aListIdWithSelectedStatus : $aListIdWithSelectedStatus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              builder: (build) => MenuBottomSheet(),
              backgroundColor: Colors.transparent,
              isScrollControlled: false,
            );
          },
          child: Icon(
            Icons.close,
            color: myTaskTextColor,
          ),
        ),
        title: Text(
          'Creat new list',
          style: TextStyle(color: myTaskTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // _newTaskAndDetailsList.add(_newTaskAndDetails());
              // _selectedDateAndTimeChipList.add(_selectedDateAndTimeChip());
              // HomeTasksListView(
              //   newTaskAndDetailsList: _newTaskAndDetailsList,
              //   selectedDateAndTimeChipList: _selectedDateAndTimeChipList,
              // );
              if (textEditingController.text == null ||
                  textEditingController.text == '') {
                /// TODO : need a Snackbar
                Navigator.pop(context);
              } else {
                DatabaseHelper.instance.updateAllList();
                Lists newList =
                    Lists(listName: textEditingController.text, listStatus: 1);
                DatabaseHelper.instance.insertList(newList);
                await _getCreatedList();
                lastList.listStatus = 1;
                // DatabaseHelper.instance.updateList(lastList);
                // Future<Lists> aListWithSelectedStatus = DatabaseHelper.instance
                //     .getListsList()
                //     .then((value) => value.singleWhere(
                //           (element) => element.listStatus == 1,
                //         ));
                // aListIdWithSelectedStatus =
                //     await aListWithSelectedStatus.then((value) => value.listId);
                // print('aListIdWithSelectedStatus : $aListIdWithSelectedStatus');
                // // MenuBottomSheet(newCreatedList: newList);
                // // widget.updateListsList;
                // Navigator.pop(context, aListIdWithSelectedStatus);
                Navigator.pop(context);
                print('newList.listId : ${lastList.listId}');
                showModalBottomSheet(
                  context: context,
                  builder: (build) => MenuBottomSheet(),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: false,
                );
              }
              // widget.updateListsList;
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) {
              //       return MenuBottomSheet();
              //     },
              //   ),
              // );
              // مثل فیلم باید فکر کنم از کالبک فانکشن ها استفاده بشه
            },
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: textSize18,
                color: saveButtonColor,
                fontFamily: 'Product Sans',
              ),
            ),
          ),
        ],
      ),
      body: Form(
        child: TextField(
          controller: textEditingController,
        ),
      ),
    );
  }
}
