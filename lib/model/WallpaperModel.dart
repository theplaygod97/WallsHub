class WallpaperModel{
  String photographer;
  String photographerURL;
  int photographerID;
  SrcModel srcModel;

  WallpaperModel({
    this.srcModel,
    this.photographer,
    this.photographerID,
    this.photographerURL});

  factory WallpaperModel.fromMap(Map<String,dynamic> jsonData){
    return WallpaperModel(
      srcModel: SrcModel.fromMap(jsonData["src"]),
      photographerURL: jsonData["photographer_url"],
      photographerID: jsonData["photographer_id"],
      photographer: jsonData["photographer"]
    );
  }
}

class SrcModel{

  String original;
  String small;
  String portrait;
  SrcModel({this.original,this.portrait,this.small});

  factory SrcModel.fromMap(Map<String,dynamic> jsonData){
    return SrcModel(
      portrait: jsonData["portrait"],
      original: jsonData["original"],
      small: jsonData["small"]
    );
  }
}