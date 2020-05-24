import 'dart:typed_data';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/painting.dart';
import 'package:walls/widget/widget.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'imageView.dart';
import 'package:walls/views/home.dart';

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
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: 1,
        showElevation: true, // use this to remove appBar's elevation
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        curve: Curves.easeOutBack,
        onItemSelected:(index) => {
        if(index==0){
          Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              Home()
      ))
    }
    },
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

class ImageGridItem extends StatefulWidget {
  int index;
  ImageGridItem(int index){
    this.index = index;
  }

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> with SingleTickerProviderStateMixin{
  AnimationController controllerOne;
  Animation<Color> animationOne;
  Animation<Color> animationTwo;
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
      return Center( child:
        ShaderMask(
            shaderCallback: (rect){
              return LinearGradient(
                  tileMode: TileMode.mirror,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [animationOne.value,animationTwo.value]).createShader(rect,textDirection: TextDirection.ltr);
            },
            child: SizedBox(
              child: LoadingBlock()
            )
        ),
      );
    }else{
      return Image.memory(imgFile,fit : BoxFit.cover);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
    controllerOne = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    animationOne = ColorTween(begin: Colors.grey,end: Colors.white70).animate(controllerOne);
    animationTwo = ColorTween(begin: Colors.white70,end: Colors.grey).animate(controllerOne);
    controllerOne.forward();
    controllerOne.addListener((){
      if(controllerOne.status == AnimationStatus.completed){
        controllerOne.reverse();
      } else if(controllerOne.status == AnimationStatus.dismissed){
        controllerOne.forward();
      }
      this.setState((){});
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controllerOne.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GridTile(child: decideGridTileViewWidget());
  }

  }
class LoadingBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
            color: Colors.white,
          );
  }
}





