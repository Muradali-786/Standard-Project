import 'package:flutter/material.dart';

import 'custom_round_button.dart';

Future<void> ShowPrintPreviewAndWhatsAppShareDialog(
  BuildContext context, {
  required VoidCallback? onEditPress(),
  required VoidCallback? onPrintPreview(),
  required VoidCallback? onPrintPress(),
  required VoidCallback? onWhatsAppPress(),
}) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Adjust the radius as needed
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomRoundButton(
                      title: 'Edit',
                      buttonColor: Color(0xff2f5596),
                      onTap: onEditPress),
                  CustomRoundButton(
                    title: 'Print',
                    buttonColor: Colors.black,
                    onTap: onPrintPress,
                  ),
                  CustomRoundButton(
                    title: 'Print Preview',
                    buttonColor: Color(0xff7d8080),
                    onTap: onPrintPreview,
                  ),
                  CustomRoundButton(
                      title: "What's App",
                      buttonColor: Colors.green,
                      onTap: onWhatsAppPress),
                  CustomRoundButton(
                    title: 'Go Back',
                    buttonColor: Color(0xffc80000),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
