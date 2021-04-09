/*
  * How to pass data back to previous screen? (flutter course)
  * CRUD bins from DB
  * App icon
  * Icon badge
  * Push notification (setting)
*/

import 'package:bin_day/screens/AddBinScreen.dart';
import 'package:bin_day/screens/WhatBinTodayScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => WhatBinTodayScreen(),
        AddBinScreen.routeName: (context) => AddBinScreen()
      },
    );
  }
}