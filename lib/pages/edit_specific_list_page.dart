import 'package:flutter/material.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/lists_model.dart';
import 'package:google_task/res.dart';
import 'package:google_task/sheets/menu_bottom_sheet.dart';

class EditSpecificListPage extends StatefulWidget {
  final Lists currentList;

  EditSpecificListPage({this.currentList});

  @override
  _EditSpecificListPageState createState() => _EditSpecificListPageState();
}

class _EditSpecificListPageState extends State<EditSpecificListPage> {
  TextEditingController textEditingController = TextEditingController();
  Lists _renamedList;

  @override
  void initState() {
    _setTheListNewName();
    super.initState();
  }

  _setTheListNewName() {
    setState(() {
      _renamedList = widget.currentList;
    });
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
            onPressed: () {
              // _newTaskAndDetailsList.add(_newTaskAndDetails());
              // _selectedDateAndTimeChipList.add(_selectedDateAndTimeChip());
              // HomeTasksListView(
              //   newTaskAndDetailsList: _newTaskAndDetailsList,
              //   selectedDateAndTimeChipList: _selectedDateAndTimeChipList,
              // );
              Lists renamedList = Lists(
                listName: _renamedList.listName,
                listStatus: true,
              );
              renamedList.listId = widget.currentList.listId;
              DatabaseHelper.instance.updateList(renamedList);
              // Navigator.pop(context);
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
        child: TextFormField(
          initialValue: _renamedList.listName,
        ),
      ),
    );
  }
}
