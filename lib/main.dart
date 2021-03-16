import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_task/res.dart';
import 'home.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //fontFamily: 'Product Sans',
      ),
      home: Home(),
    );
  }
}
