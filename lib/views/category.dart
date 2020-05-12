import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:walls/data/data.dart';
import 'package:walls/model/WallpaperModel.dart';
import 'package:http/http.dart' as http;
import 'package:walls/widget/widget.dart';
class Categorize extends StatefulWidget {
  final String categoryName;

  Categorize({this.categoryName});

  @override
  _CategorizeState createState() => _CategorizeState();
}

class _CategorizeState extends State<Categorize> {
  List<WallpaperModel> wallpapers = new List();
  getSearchWalls(String query) async{
    var response = await http.get("https://api.pexels.com/v1/search?query=$query&per_page=15&page=1",
        headers:{
          "Authorization" : apiKey});

    //print(response.body.toString());

    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element){
      //print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {

    });
  }
  @override
  void initState() {
    getSearchWalls(widget.categoryName);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BrandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              wallPapersList(wallpapers: wallpapers,context: context)
            ],),),
      ),
    );
  }
}
