import 'package:flutter/material.dart';
import 'package:google_task/res.dart';

class CreatListPage extends StatefulWidget {
  @override
  _CreatListPageState createState() => _CreatListPageState();
}

class _CreatListPageState extends State<CreatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            return Navigator.pop(context);
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
        child: TextFormField(),
      ),
    );
  }
}
