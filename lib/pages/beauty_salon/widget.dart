import 'package:flutter/material.dart';

Widget menuBtnForBeauty({
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
        PopupMenuItem(value: 2, child: Text('List of all jobs')),
      ];
    },
  );
}

Widget menuBtnForPriceList({
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
        PopupMenuItem(value: 1, child: Text('Price List')),
        PopupMenuItem(value: 2, child: Text('Add Beautician')),
      ];
    },
  );
}

Widget menuBtnForBeautyOnlyEdit({
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

Widget menuBtnForDetails({
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
        PopupMenuItem(value: 2, child: Text('Details')),
      ];
    },
  );
}
