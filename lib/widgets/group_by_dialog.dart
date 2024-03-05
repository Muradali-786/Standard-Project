import 'package:flutter/material.dart';

class GroupByDialog extends StatefulWidget {
  const GroupByDialog({Key? key}) : super(key: key);

  @override
  _GroupByDialogState createState() => _GroupByDialogState();
}

class _GroupByDialogState extends State<GroupByDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:Text("Group By Dialog"),
      content: Column(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context,"SUM");
          }, child: Text("SUM"))
        ],
      ),
    );
  }
}
