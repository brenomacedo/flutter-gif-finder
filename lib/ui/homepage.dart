import 'package:flutter/material.dart';
import 'package:gif_finder/ui/gifpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null || _search.isEmpty)
      response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=SJ2m3lJnT1oBVCGCVtz2ypqnBC0C1PL5&limit=20&rating=g');
    else
      response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=SJ2m3lJnT1oBVCGCVtz2ypqnBC0C1PL5&q=$_search&limit=19&offset=$_offset&rating=g&lang=en');
    
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
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
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
                    if(snapshot.hasError) return Container();
                    return _createGifTable(context, snapshot);
                }
              }
            )
          )
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {

        if(_search == null || _search.isEmpty || index < snapshot.data["data"].length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return GifPage(snapshot.data["data"][index]);
                }
              ));
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 70.0),
                  Text("Carregar mais...", style: TextStyle(color: Colors.white, fontSize: 22.0))
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
      }
    );
  }

  int _getCount(List data) {
    if(_search == null || _search.isEmpty) return data.length;
    return data.length + 1;
  }

}