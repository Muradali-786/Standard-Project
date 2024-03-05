import 'package:flutter/material.dart';

class DetailWidget extends StatefulWidget {

  final Widget data;

  DetailWidget(this.data);

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blue.shade200,
      child: Center(
        child: widget.data,
      ),
    );
  }
}
