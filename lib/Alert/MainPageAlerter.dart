import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

class MainPageAlerter {

  final alertStyle = AlertStyle(
                      animationType: AnimationType.shrink,
                      isOverlayTapDismiss: true,
                      isCloseButton: false,
                      animationDuration: Duration(milliseconds: 300),
                      alertBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      titleStyle: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    );

  void massageOfNoDataGet(BuildContext context) {
    Alert(
        context: context,
        title: "FlickR",
        style: alertStyle,
        type: AlertType.info,
        desc: "There are no images at your request.").show();
  }

  void massageOfServerError(BuildContext context) {
    Alert(
        context: context,
        title: "FlickR",
        style: alertStyle,
        type: AlertType.error,
        desc: "Error: Server is not responding.").show();
  }

  void massageInternetConnection(BuildContext context) {
    Alert(
        context: context,
        title: "FlickR",
        style: alertStyle,
        type: AlertType.warning,
        desc: "Warning: Check your Internet connection.").show();
  }

  void massageServerTimeOut(BuildContext context) {
    Alert(
        context: context,
        title: "FlickR",
        style: alertStyle,
        type: AlertType.error,
        desc: "Error: Response TimeOut.").show();
  }
}