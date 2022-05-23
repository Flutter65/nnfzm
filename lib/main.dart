import 'package:flutter/material.dart';
import 'package:lunchbox2/views/home.dart';
import 'package:lunchbox2/views/recipe_view.dart';

void main(){
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title:'LunchBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan
      ),
      home: Home(),
    );
  }
}

