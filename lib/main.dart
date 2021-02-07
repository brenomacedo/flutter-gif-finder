import 'package:flutter/material.dart';
import 'package:gif_finder/ui/homepage.dart';

void main() {
  runApp(MaterialApp(
    title: "Gif finder",
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.white,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.white)
      )
    ),
  ));
}