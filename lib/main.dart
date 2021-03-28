import 'package:flutter/material.dart';
import 'package:google_task/res.dart';
// import 'package:flutter/services.dart';
// import 'package:google_task/res.dart';
import 'helpers/database_helper.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: scaffoldBackgroundColor,
  //   statusBarIconBrightness: Brightness.dark,
  // ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
