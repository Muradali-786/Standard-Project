import 'package:flutter/material.dart';

class CustomInputTextField extends StatelessWidget {
  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFieldSubmittedValue;
  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final bool obsecureText;
  final String hint;
  final Color cursorColor;
  final Widget? suffixWidget;
  final bool enable, autoFocus, isPasswordField, showPrefixIcon;
  const CustomInputTextField({
    Key? key,
    this.cursorColor = Colors.black,
    required this.myController,
    required this.focusNode,
    required this.onFieldSubmittedValue,

    required this.hint,
    required this.onValidator,
    required this.keyBoardType,
    this.isPasswordField = false,
    this.showPrefixIcon = true,
    this.obsecureText = false,
    this.suffixWidget,
    this.enable = true,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7),
      child: TextFormField(
        controller: myController,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmittedValue,
        validator: onValidator,
        keyboardType: keyBoardType,
        cursorColor: cursorColor,
        obscureText: obsecureText,
        obscuringCharacter: '*',
        enabled: enable,
        style: TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            suffixIcon: isPasswordField ? suffixWidget : null,
            suffixIconColor: Colors.grey,
            contentPadding: EdgeInsets.all(5),
            hintStyle: TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8))),
      ),
    );
  }
}
