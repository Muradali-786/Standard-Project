import 'package:flutter/material.dart';

class ColumnSlider extends StatefulWidget {
  final double totalColumns;
  const ColumnSlider({Key? key, required this.totalColumns}) : super(key: key);
  @override
  _ColumnSliderState createState() => _ColumnSliderState();
}
class _ColumnSliderState extends State<ColumnSlider> {
  double? _totalColumns;
  @override
  void initState() {
    _totalColumns=widget.totalColumns;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        child: AlertDialog(
          title: Text('Total Columns'),
          content: Container(
            child: Slider(
              value: _totalColumns as double,
              min: 1,
              max: 8,
              divisions: 7,
              onChanged: (value) {
                setState(() {
                  _totalColumns = value;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Use the second argument of Navigator.pop(...) to pass
                // back a result to the page that opened the dialog
                Navigator.pop(context, _totalColumns);
              },
              child: Text('DONE'),
            )
          ],
        ),
      ),
    );
  }
}
