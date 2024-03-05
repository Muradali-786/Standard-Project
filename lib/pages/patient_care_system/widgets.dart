


import 'package:flutter/material.dart';

Widget menuBtnForCareSystem({
  Function(int)? onSelected,
}) {
  return PopupMenuButton<int>(
    padding: EdgeInsets.only(left: 8, bottom: 5),
    icon: Icon(
      Icons.more_vert_rounded,
      size: 20,
      color: Colors.black,
    ),
    onSelected: onSelected,
    itemBuilder: (context) {
      return [
        PopupMenuItem(value: 1, child: Text('Edit')),

      ];
    },
  );
}

Future<void> showDialogForCashPatientCareSystem({
  required BuildContext context,
  required void Function()? onPressedPrint,
  required void Function()? onPressedCashRec,
  required void Function()? onPressedOtherExp,
  required void Function()? onPressedWhatsApp,
  required void Function()? onPressedBack,
}) async {
  await showDialog(
    context: context,
    builder: (context) => Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          child: Container(
            height: 270,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: onPressedPrint, child: Text('Print')),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: onPressedCashRec,
                        child: Text('Cash Receive')),
                  ),
                  SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: onPressedOtherExp,
                        child: Text('Other Charges'),
                      )),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: onPressedWhatsApp, child: Text('WhatsApp')),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: onPressedBack, child: Text('Go Back')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}