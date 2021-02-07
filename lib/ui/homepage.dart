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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network('https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        centerTitle: true
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.all(10.0),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      )
                    );
                  default:
                    if(snapshot.error) return Container();
                    return _createGifTable(context, snapshot);
                }
              }
            )
          )
        ],
      ),
    );
  }
}

Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
  return Container();
}