import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State {

  List data;

  Future<String> getData() async{
    http.Response response = await http.get(
      Uri.encodeFull("https://travelo.live/partner/index.php/api_server/get_kategori/4"),
      headers: {
        "Accept":"application/json"
      }
    );
    setState((){
      data = json.decode(response.body);
    });
    return "Success!";
  }

  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Data from API 2"),
        backgroundColor: Colors.blueAccent,
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new Card(
            child: new Text(data[index]["jumlah"].toString()),
          );
        },
      ),
    );
  }
}