// ignore_for_file: unused_local_variable

import 'package:com/config/values.dart';
import 'package:flutter/material.dart';


class Toast {
  Toast._();
  static buildErrorSnackBar( String message) {
    var showSnackBar = ScaffoldMessenger.of(Values.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text("$message"),
      ),
    );
  }

  static buildLoadingSnackBar(String message) {

    var showSnackBar = ScaffoldMessenger.of(Values.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        duration: Duration(minutes: 1),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$message",),
            SizedBox(width: 30,),
            CircularProgressIndicator(color: Colors.blue,)
          ],
        ),
      ),
    );
  }

  static hidCurrentSnackBar() {
    ScaffoldMessenger.of(Values.navigatorKey.currentContext!).hideCurrentSnackBar();
  }
}

noAvailableFeature(BuildContext context){
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(
          'This feature is not available on this platform'),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('OK'))
      ],
    ),
  );
}