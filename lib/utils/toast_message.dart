import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showToast(String message, {bool isError = false, bool isLoading = false}) {
  Color backgroundColor;
  Color textColor = Colors.white;
  IconData icon;
  if (isLoading) {
    backgroundColor = Colors.blue[800]!;
    icon = Icons.refresh;
  } else if (isError) {
    backgroundColor = Colors.red[800]!;
    icon = Icons.error_outline;
  } else {
    backgroundColor = Colors.green[800]!;
    icon = Icons.check_circle_outline;
  }
  Fluttertoast.showToast(
    
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    // backgroundColor: Colors.white,
    textColor: textColor,
    fontSize: 16.0,
    timeInSecForIosWeb: 1,
    webShowClose: true,
    // webBgColor: backgroundColor,
    webPosition: 'center',
   
  );
}
