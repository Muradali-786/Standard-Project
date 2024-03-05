import 'package:flutter/material.dart';

class VerifyPhoneDialog extends StatelessWidget {
  const VerifyPhoneDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Would you like to verify phone number'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          ElevatedButton(onPressed: (){
            Navigator.pop(context,true);
          }, child: Text('Yes')),
          ElevatedButton(onPressed: (){
            Navigator.pop(context,false);
          }, child: Text('No'))
        ]
    )
        ],
      ),
    );
  }
}
