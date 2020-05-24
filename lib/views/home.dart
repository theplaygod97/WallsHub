import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:walls/data/data.dart';
import 'package:walls/model/CategoriesModel.dart';
import 'package:walls/model/WallpaperModel.dart';
import 'package:walls/views/category.dart';
import 'package:walls/views/fimages.dart';
import 'package:walls/views/search.dart';
import 'package:walls/widget/widget.dart';
import 'package:walls/views/imageView.dart';
import 'package:http/http.dart' as http;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  List<CategoriesModel> categories = new List();
  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchController = new TextEditingController();

  getTrendingWalls() async{
    var response = await http.get("https://api.pexels.com/v1/curated?per_page=32&page=1",
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
    getTrendingWalls();
    categories = getCategories();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       title: BrandName(),
        elevation: 0.0,
      ),
      body:
      SingleChildScrollView(
        child: Container(child:  Column(
          children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xfff5f8fd),
              borderRadius:  BorderRadius.circular(30)
                  
            ),
            padding: EdgeInsets.symmetric(horizontal:  24),
            margin: EdgeInsets.symmetric(horizontal:  24),
            child: Row(
              children: <Widget>[
              Expanded(
              child : TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search Walls",
                  border: InputBorder.none

                ),
              ),
             ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(
                    builder: (context) => Search(
                      searchQuery: searchController.text,
                    )
                  ));
                },
                  child: Container(
                      child: Icon(Icons.search)),
              )
            ],),
          ),
          SizedBox(height: 16,),
          Container(
            height:  80,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){

                  return CategoryTile(
                    title: categories[index].categoriesName,
                    imgURL: categories[index].imgURL,
                  );
                }),
          ),
          wallPapersList(wallpapers: wallpapers,context: context)
        ],),),
      ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: 0,
          showElevation: true,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          curve: Curves.easeInOutBack,
          animationDuration: Duration(milliseconds: 200),
          // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            if(index==1){ Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    Firebaseimgs()
            ));}
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text('Home'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.favorite),
                title: Text("Dev's  Pick"),
                activeColor: Colors.purpleAccent
            ),
          ],
        ),

    );

  }
}


class CategoryTile extends StatelessWidget {
  final String imgURL,title;
  CategoryTile({@required this.imgURL,@required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(title == "Dev's ❤"){Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                Firebaseimgs()
                ));
        }
        else {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) =>
                  Categorize(
                    categoryName: title.toLowerCase(),
                  )
          ));
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ImageView()
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
                child: Image.network(imgURL,height: 50,width: 100,fit: BoxFit.cover,)),
          ),
          Container(

            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 50,width: 100,
            alignment: Alignment.center,
            child: Text(title,style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 16),),),
        ],),
      ),
    );

  }
}

