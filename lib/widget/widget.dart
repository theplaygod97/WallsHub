import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walls/model/WallpaperModel.dart';
import 'package:walls/views/imageView.dart';


Widget BrandName(){
  return RichText(
    text: TextSpan(

      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
      children: <TextSpan>[

        TextSpan(text: 'Walls', style: TextStyle(color : Colors.black87)),
        TextSpan(text: 'Hub', style: TextStyle(color : Colors.blue)),
      ],
    ),
  );
}

Widget wallPapersList({List<WallpaperModel> wallpapers,context}){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpaper){
        return GridTile(

          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ImageView(
                  imgURL : wallpaper.srcModel.portrait,
                )
              ));
            },
            child: Hero(
              tag: wallpaper.srcModel.portrait,
              child: Container(
               child: ClipRRect(
                   borderRadius: BorderRadius.circular(16),
                   child: Image.network(wallpaper.srcModel.portrait,fit: BoxFit.cover,))
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}