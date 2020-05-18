
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageView extends StatefulWidget {
  final String imgURL;
  ImageView({this.imgURL});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.network(widget.imgURL,fit: BoxFit.cover,)),
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          GestureDetector(
            onTap: (){
              _save();
              Fluttertoast.showToast(
                  msg: 'Saving Image in Gallery',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white
              );
            },
            child: Stack(
              children: <Widget>[
                Container(
                  height:50,
                  width: MediaQuery.of(context).size.width/2,

                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white60,width: 1),
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff1c1b1b).withOpacity(0.8),
                  ),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width/2,
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white60,width: 1),
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF)
                          ]
                      )
                  ),

                  child: Column(children: <Widget>[
                    Text("Save Wall",style: TextStyle(
                        fontSize: 16,color:  Colors.white70
                    ),),
                    Text("Image will be saved in Gallery",style: TextStyle(
                        fontSize: 10,color:  Colors.white70
                    ),)
                  ],),
                ),
              ],
            ),
          ),
          SizedBox(height: 16,),

          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
              child: Text("Cancel",style: TextStyle(color: Colors.white),)),
          SizedBox(height: 50,)
          ],),
      )
      ],),
    );
  }
  _save() async {
  if(Platform.isAndroid){
    await Permission.storage.request();
  }
    await _askPermission();
    var response = await Dio().get(widget.imgURL,
        options: Options(responseType: ResponseType.bytes));
    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);

  }

  _askPermission() async {
    if (Platform.isIOS) {
      await Permission.photos.request();
    } else {
      await Permission.storage.status;
    }
  }


}

