import 'package:flutter/material.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/lists_model.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
  // _buildDefaultList();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: scaffoldBackgroundColor,
  //   statusBarIconBrightness: Brightness.dark,
  // ));
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // _buildDefaultList();
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      ),
      title: 'Google Tasks Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
