
import 'package:flutter/material.dart';

Widget menuBTNForAddVehicle({Function(int)? onSelected}) {
  return PopupMenuButton<int>(
    padding: EdgeInsets.only(left: 8, bottom: 5),
    icon: Icon(
      Icons.more_vert_rounded,
      size: 20,
      color: Colors.white,
    ),
    onSelected: onSelected,
    itemBuilder: (context) {
      return [
        PopupMenuItem(value: 0, child: Text('Add/Edit Your Vehicle')),
      ];
    },
  );
}