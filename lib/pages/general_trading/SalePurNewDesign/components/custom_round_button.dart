import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  final String title;
  final Color buttonColor;
  final VoidCallback onTap;
  const CustomRoundButton({
    super.key,
    required this.title,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          height: 50,
          width: double.infinity,
          padding: EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: Color(0xffF0b086),
              ),
              Spacer(),
              Text(
                title,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRoundButton2 extends StatelessWidget {
  final double height;
  final String title;
  final Color buttonColor;
  final VoidCallback onTap;
  const CustomRoundButton2({
    super.key,
    this.height=50,
    required this.title,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(6)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}