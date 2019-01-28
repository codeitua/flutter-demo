import 'package:flickr_app/Model/ImageInfoModel.dart';
import 'package:dio/dio.dart';
import 'dart:convert';


class ImageInfoService {

  final dio = new Dio();
  final JsonDecoder _decoder = new JsonDecoder();

  Future<List<ImageInfoModel>> getImageInfo(String query, int page) async {
    List<ImageInfoModel> tempList = new List<ImageInfoModel>();
    String url = "https://api.flickr.com/services/rest/";
    var parameters = {
      "method":"flickr.photos.search",
      "text":query,
      "per_page": "80",
      "page":page,
      "api_key":"97289df76b0b4169b8674a87999547e6",
      "format":"json"};

    return await dio.get(url, data: parameters).then((response){
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 300) {
        throw new Exception("Error while fetching data");
      }
      var str = response.data.toString().replaceAll("jsonFlickrApi(", "");
      str = str.substring(0, str.length - 1);
      var decodedBody = _decoder.convert(str);
      if (decodedBody['stat'] == 'fail') {
        throw new Exception("Error while fetching data");
      }
      for (int i = 0; i < decodedBody['photos']['photo'].length; i++) {
        tempList.add(ImageInfoModel.fromJson(decodedBody['photos']['photo'][i]));
      }
      return tempList;
    },
    onError: (error) {
      throw DioErrorType.RESPONSE;
    }).timeout(Duration(seconds: 7), onTimeout: (){
      throw DioErrorType.RECEIVE_TIMEOUT;
    });
  }
}