import 'package:flutter/material.dart';

class ItemTreeView extends StatefulWidget {
  final List list;

  const ItemTreeView({required this.list, Key? key}) : super(key: key);

  @override
  State<ItemTreeView> createState() => _ItemTreeViewState();
}

class _ItemTreeViewState extends State<ItemTreeView> {
  Set<String> itemTypeList = {};
  Set<String> groupNameList = {};
  Set<Set> itemNameList = {};

  int itemTypeCount = 0;
  int groupNameCount = 0;
  int itemNameCount = 0;

  @override
  void initState() {
    super.initState();

    print('...........length..............${widget.list.length}');
    print('...........data..............${widget.list}');

    for (int count = 0; count < widget.list.length; count++) {
      itemTypeList.add(widget.list[count]['ItemType']);
      itemTypeCount++;
    }
    print('...........length..............${itemTypeList.length}');
    for (int countOFItem = 0;
        countOFItem < itemTypeList.length;
        countOFItem++) {
      for (int count = 0; count < widget.list.length; count++) {
        if (widget.list[count]['ItemType'] ==
            itemTypeList.elementAt(countOFItem)) {
          itemTypeCount++;
        }
      }
      // itemTypeList.add(widget.list[count]['ItemType']);

    }
  }

  getGroupName(String itemType) {
    groupNameList.clear();
    itemNameList.clear();
    groupNameCount = 0;
    for (int count = 0; count < widget.list.length; count++) {
      if (widget.list[count]['ItemType'] == itemType) {
        groupNameList.add(widget.list[count]['GroupName']);
        groupNameCount++;
      }
    }

    for (int count = 0; count < groupNameList.length; count++) {
      itemNameList.add({});
    }
  }

  getItemName(String groupName,int index) {
    itemNameList.elementAt(index).clear();
    for (int count = 0; count < groupNameList.length; count++) {
      for (int count = 0; count < widget.list.length; count++) {
        if (widget.list[count]['GroupName'] == groupName) {
          itemNameList.elementAt(index).add(widget.list[count]['ItemName']);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemTypeList.length,
      itemBuilder: (context, indexOfItemType) => ExpansionTile(
        onExpansionChanged: (value) {
          if (value) {
            getGroupName(itemTypeList.elementAt(indexOfItemType));
            setState(() {});
          }else{
            groupNameList.clear();
            itemNameList.clear();
          }
        },
        title: Text(
          '($itemTypeCount) ${itemTypeList.elementAt(indexOfItemType)}',
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: groupNameList.length,
            itemBuilder: (context, indexOfGroupName) => ExpansionTile(
              onExpansionChanged: (value) {
                if (value) {

                    getItemName(groupNameList.elementAt(indexOfGroupName),
                        indexOfGroupName);

                  setState(() {});
                }
              },
              title: Text(
                '     ()${groupNameList.elementAt(indexOfGroupName)}',
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: itemNameList.elementAt(indexOfGroupName).length,
                  itemBuilder: (context, indexOfItemName) => ExpansionTile(
                    onExpansionChanged: (value) {
                      // getGroupName(itemTypeList.elementAt(indexOfItemType));
                    },
                    title: Text(
                      '          ${itemNameList.elementAt(indexOfGroupName).elementAt(indexOfItemName)}',
                    ),
                    children: [],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
