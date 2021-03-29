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
            onPressed: () {
              // _newTaskAndDetailsList.add(_newTaskAndDetails());
              // _selectedDateAndTimeChipList.add(_selectedDateAndTimeChip());
              // HomeTasksListView(
              //   newTaskAndDetailsList: _newTaskAndDetailsList,
              //   selectedDateAndTimeChipList: _selectedDateAndTimeChipList,
              // );
              if (textEditingController.text == null ||
                  textEditingController.text == '') {
                Navigator.pop(context);
              } else {
                Lists newListName = Lists(listName: textEditingController.text);
                DatabaseHelper.instance.insertList(newListName);
                widget.updateListsList;
                Navigator.pop(context);
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
