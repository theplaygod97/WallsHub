import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:walls/widget/widget.dart';

import 'imageView.dart';

class Firebaseimgs extends StatelessWidget {



  Widget makeImagesGird(){
    List<dynamic> values;
    int itemCount = 6;
    var db = FirebaseDatabase.instance.reference().child("Data");
    db.once().then((DataSnapshot snapshot){
      values = snapshot.value;
      itemCount = values.length;
    });

    print(itemCount);
    return GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: itemCount,
        gridDelegate:
    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0, ),

        itemBuilder: (context,index){
            return GestureDetector(

           onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ImageView(
                imgURL : values[index]
              )
          ));
        },
        child: Container(
          child:ClipRRect(
            borderRadius: BorderRadius.circular(16),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ImageGridItem(index))
          ),
         ),
      );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BrandName(),
        elevation: 0.0,
      ),

      body: Container(padding: EdgeInsets.symmetric(horizontal: 16),
     
        child: makeImagesGird(),
      
      ),
    );
  }
}

class ImageGridItem extends StatefulWidget {
  int index;
  ImageGridItem(int index){
    this.index = index;
  }

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  Uint8List imgFile;
  StorageReference photosRef = FirebaseStorage.instance.ref().child("photos");
  int maxSize = 2 * 1024 * 1024;

  getImage(){
    photosRef.child("Img${widget.index}.jpg").getData(maxSize).then((data){
      this.setState(() {
        imgFile = data;
      });
    }).catchError((error){
    });
  }


  Widget decideGridTileViewWidget(){
    if(imgFile==null){
      return Center(child : Text("No Data"));
    }else{
      return Image.memory(imgFile,fit : BoxFit.cover);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();

  }

  @override
  Widget build(BuildContext context) {
    return GridTile(child: decideGridTileViewWidget());
  }

  }


