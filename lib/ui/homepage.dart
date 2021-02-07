import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null)
      response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=SJ2m3lJnT1oBVCGCVtz2ypqnBC0C1PL5&limit=20&rating=g');
    else
      response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=SJ2m3lJnT1oBVCGCVtz2ypqnBC0C1PL5&q=$_search&limit=20&offset=$_offset&rating=g&lang=en');
    
    return json.decode(response.body);

  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((val) {
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}