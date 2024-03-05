// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:com/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';

class DropDownStyle1 extends StatefulWidget {
  DropDownStyle1(
      {Key? key,
      this.index,
        this.titleFor= '',
      this.dropdown_title,
      this.acc1TypeList,
      required this.map})
      : super(key: key);
  final String? dropdown_title;
  final int? index;
  final String? titleFor;

  List<Map>? acc1TypeList = [];
  static String title = "Item";
  final map;

  // final String ? title;
  // final int ? id;
  // final String ? subtitle;

  @override
  DropDownStyle1State createState() => DropDownStyle1State(acc1TypeList!);
}

class DropDownStyle1State extends State<DropDownStyle1> {
  DropDownStyle1State(this.acc1TypeList);

  TextEditingController _searchController = TextEditingController();

  //VisibilityPage({Key? key,required this.columnName}) : super(key: key);
  static List<String> lis = [];
  List<Map> acc1TypeList = [];
  String searchValue = '';

  @override
  void initState() {
    //_searchController.text = widget.map['Title'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as DropDownStyle1;
    // print(args.dropdown_title);

    // print(args!.dropdown_title);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
            .borderTextAppBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.titleFor!),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: Provider.of<ThemeDataHomePage>(context, listen: false)
              .backGroundColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: TextFormField(
                    //initialValue: args.dropdown_title,
                    //controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      label: Text(
                        "Search",
                        style: TextStyle(color: Colors.black),
                      ),
                      hintText: "Search",
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 20,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    controller: _searchController,
                    onChanged: (value) {
                      searchValue = value;
                      getSearchList(value);

                      if (value.length == 0) {
                        print("value is zero");
                      }
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: acc1TypeList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            DropDownInListClick(index, context);
                            //Navigator.pop(context,acc1TypeList[index]['Title'].toString());
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          () {
                                            if (acc1TypeList.length <
                                                widget.acc1TypeList!.length) {
                                              debugPrint("in if");
                                              return RichText(
                                                  text: Constants.searchMatch(
                                                      acc1TypeList[index]
                                                              ['Title']
                                                          .toString(),
                                                      _searchController.text));
                                            } else {
                                              return Text(acc1TypeList[index]
                                                      ['Title']
                                                  .toString());
                                            }
                                          }(),
                                          Text(
                                            acc1TypeList[index]['SubTitle']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Text(
                                          acc1TypeList[index]["ID"].toString()),
                                      Text(acc1TypeList[index]["Value"]
                                          .toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getSearchList(String searchValue) {
    List<Map<dynamic, dynamic>> tempList = [];

    for (Map<dynamic, dynamic> element in widget.acc1TypeList!) {
      if (element['Title']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      }
    }
    acc1TypeList = tempList;
  }

  DropDownInListClick(int index, BuildContext context) {
    lis.insert(0, acc1TypeList[index]['Title'].toString());
    lis.add(acc1TypeList[index]['SubTitle'].toString());
    setState(() {});
    Navigator.pop(context, {
      "ID": acc1TypeList[index]['ID'].toString(),
      "Index": widget.index,
      'Title': acc1TypeList[index]['Title'].toString(),
      'SubTitle': acc1TypeList[index]['SubTitle'].toString(),
      "Value": acc1TypeList[index]['Value'].toString()
    });
  }

  static DropDownButton(
      {String? title, String? id, String? subtitle, int? value }) {
    return Container(
      height: 60,

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        trailing: Icon(
          Icons.arrow_downward,
          color: Colors.grey,
          size: 17,
        ),
        title: Text(title.toString()),
        //{"ID":null,'Title':"Account Group",'SubTitle':null,"Value":null}
        subtitle: Text(
          id.toString(),
        ),
      ),
    );
  }
}

/// select * from Account1Type
