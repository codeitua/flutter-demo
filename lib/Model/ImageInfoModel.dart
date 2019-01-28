
class ImageInfoModel {
  final String id;
  final String secret;
  final String server;
  final String title;
  final int farm;

  ImageInfoModel({this.id, this.secret, this.server, this.farm, this.title});

  factory ImageInfoModel.fromJson(Map<dynamic, dynamic> json) {
    return ImageInfoModel(id: json['id'],
        secret: json['secret'],
        server: json['server'],
        farm: json['farm'],
        title: json['title']);
  }
}