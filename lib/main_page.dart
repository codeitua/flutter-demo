import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'image_view.dart';
import 'Service/ImageInfoService.dart';
import 'package:flickr_app/Model/ImageInfoModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Alert/MainPageAlerter.dart';

class MainPage extends StatefulWidget {

  static String tag = 'main-page';
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _filter = new TextEditingController();
  List<ImageInfoModel> _imageInfo = new List<ImageInfoModel>();
  ImageInfoService _serviceImage = new ImageInfoService();
  MainPageAlerter _alerter = new MainPageAlerter();
  ScrollController _controller = ScrollController();

  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search', style: TextStyle(color: Colors.red),);

  String _searchText = "";
  bool _isToRequest = false;
  int _currentPage = 1;
  bool _isLoaderRun = true;


  //  Initialization scope.

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _currentPage++;
      _requestImageInfo(true);
    }
  }

  _controllerListener() {
    if (_filter.text.isEmpty) {
      _resetAllStates();
    } else if (_filter.text != _searchText) {
      setState(() {
        _searchText = _filter.text;
      });
    }
  }

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    _filter.addListener(_controllerListener);
    super.initState();
  }

  // Building the app bar with the text field to query.

  _sourceStateBar() {
    this._searchIcon = new Icon(Icons.search);
    this._appBarTitle = new Text('Search', style: TextStyle(color: Colors.red),);
  }

  _resetAllStates() {
    setState(() {
      _searchText = "";
      _imageInfo.clear();
      _currentPage = 1;
      _isToRequest = false;
      _isLoaderRun = true;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          keyboardType: TextInputType.text,
          onEditingComplete: () {
            if (_filter.text.isNotEmpty) {
              _sourceStateBar();
              setState(() {
                _isToRequest = true;
              });
              _requestImageInfo(false);
            }
          },
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search, color: Colors.red,),
            hintText: 'Search...',
          ),
          autocorrect: false,
          autofocus: true,
          style: TextStyle(color: Colors.white,),
        );
      } else {
        _sourceStateBar();
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      backgroundColor: Color.fromRGBO(3, 52, 130, 1),
      leading: new IconButton(
        icon: _searchIcon,
        color: Colors.red,
        onPressed: _searchPressed,
      ),
    );
  }

  // Building the view of queried images.

  _requestImageInfo(bool addOption) {
    _serviceImage.getImageInfo(_searchText, _currentPage).then((result) {
      setState(() {
        _isLoaderRun = !(result.length < 15);
        addOption ? _imageInfo += result : _imageInfo = result;
      });
      if (_imageInfo.length == 0) {
        _alerter.massageOfNoDataGet(context);
        _filter.clear();
      }
    }, onError: (error) {
      switch (error){
        case DioErrorType.RESPONSE:
          _alerter.massageInternetConnection(context);
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          _alerter.massageServerTimeOut(context);
          break;
        default:
          _alerter.massageOfServerError(context);
          break;
      }
      _filter.clear();
    });
  }

  String _makeUrlForImage(ImageInfoModel model) {
    final farm = model.farm;
    final secret = model.secret;
    final server = model.server;
    final id = model.id;
    return 'http://farm$farm.staticflickr.com/$server/${id}_${secret}_q.jpg';
  }

  CustomScrollView _buildImagesView() {
    List<Widget> result = [];
    var optimalAmount = _imageInfo.length - (_imageInfo.length % 3);
    for (int i = 0; i < optimalAmount ; i++) {
      final url = _makeUrlForImage(_imageInfo[i]);
      result.add( Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.1, color: Colors.grey),
        ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(new ImageViewRoute(url,)
              );
            },
            child: Image.network(url, fit: BoxFit.fitHeight,),
            )
          ),
      );
    }
    return CustomScrollView(
      controller: _controller,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(0.0),
          sliver: SliverGrid.count(
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
            crossAxisCount: 2,
            children: result,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: _isLoaderRun ? 60 : 0,
                alignment: Alignment.center,
                child: SpinKitCircle(color: Colors.pink,),
              );
            },
            addAutomaticKeepAlives: true,
            childCount: 1,
          ),
        )
      ],
    );
  }

  // Building the empty view.

  Widget _buildEmptyView() {
    return Center(
      child: Image.asset("assets/flickrLogo.png", width: 150, height: 70,),
    );
  }

  // Scaffold widget.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        color: Colors.white,
        child: !_isToRequest ? _buildEmptyView() : _buildImagesView(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
