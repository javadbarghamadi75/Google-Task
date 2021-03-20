import 'package:flutter/material.dart';
import 'package:google_task/res.dart';

class MoreBottomSheet extends StatefulWidget {
  @override
  _MoreBottomSheetState createState() => _MoreBottomSheetState();
}

class _MoreBottomSheetState extends State<MoreBottomSheet> {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sortBy(),
          _divider(),
          _renameList(),
          _deleteList(), //TODO : must be disabled on default list
          _deleteAllCompletedTasks(), //TODO : must be disabled when there is not any completed tasks
          _divider(),
          _copyRemindersToTasks(),
          _divider(),
          _theme(),
        ],
      ),
    );
  }

  _divider() {
    return Divider(
      color: chipBorderColor,
      height: 0,
    );
  }

  _sortBy() {
    return ListTile(
      title: Text(
        'Sort by',
        style: TextStyle(
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
      subtitle: Text(
        'My order',
        style: TextStyle(
          fontSize: textSize14,
          color: newTaskTextColor,
        ),
      ),
    );
  }

  _renameList() {
    return ListTile(
      title: Text(
        'Rename list',
        style: TextStyle(
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
    );
  }

  _deleteList() {
    return ListTile(
      title: Text(
        'Delete list',
        style: TextStyle(
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
      subtitle: Text(
        "Default list can't be deleted", //TODO : must be disabled on non-default list
        style: TextStyle(
          fontSize: textSize14,
          color: newTaskTextColor,
        ),
      ),
    );
  }

  _deleteAllCompletedTasks() {
    return ListTile(
      title: Text(
        'Delete all completed tasks',
        style: TextStyle(
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
    );
  }

  _copyRemindersToTasks() {
    return ListTile(
      title: Text(
        'Copy reminders to tasks',
        style: TextStyle(
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
    );
  }

  _theme() {
    return ListTile(
      title: Text(
        'Theme',
        style: TextStyle(
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
      subtitle: Text(
        'System default',
        style: TextStyle(
          fontSize: textSize14,
          color: newTaskTextColor,
        ),
      ),
    );
  }
}
