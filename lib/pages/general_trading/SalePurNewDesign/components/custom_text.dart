import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title, value;
  const CustomText({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey),
          ),
          Text(": $value"),
        ],
      ),
    );
  }
}

class CustomText2 extends StatelessWidget {
  final String title, value;
  const CustomText2({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          ": $value",
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}