import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ImageViewRoute extends CupertinoPageRoute {
  final String url;

  @override
  ImageViewRoute(this.url)
      : super(builder: (BuildContext context) => new ImageView(url: url));


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(
      opacity: animation,
      child: new ImageView(url: url),
    );
  }
}

class ImageView extends StatefulWidget {
  static String tag = 'image-view';
  final String url;

  ImageView({Key key, @required this.url}) : super(key: key);

  @override
  _ImageViewState createState() => new _ImageViewState(url);
}

class _ImageViewState extends State<ImageView> {
  String url;
  _ImageViewState(this.url);

  @override
  Widget build(BuildContext context) {
    this.url = this.url.replaceAll("_q.jpg", "_z.jpg");
    final image = CachedNetworkImageProvider(url);
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
            ),
            PhotoView(
              imageProvider: image,
            ),
          ],
        ),
      )
      );
  }
}
