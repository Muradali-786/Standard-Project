// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';

class DropDownStyle1Image extends StatefulWidget {
  DropDownStyle1Image({Key? key, this.acc1TypeList, required this.map})
      : super(key: key);
  List? acc1TypeList = [];
  final map;

  @override
  DropDownStyle1State createState() => DropDownStyle1State(acc1TypeList!);
}

class DropDownStyle1State extends State<DropDownStyle1Image> {
  DropDownStyle1State(this.acc1TypeList);

  TextEditingController _searchController = TextEditingController();
  static List<String> lis = [];
  List acc1TypeList = [];
  String image1 = '';
  String searchValue = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Dropdown"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            children: [
              Container(
                height: 50,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: "Search",
                    hintText: "Search",
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.green,
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
                      String countryName = acc1TypeList[index]['CountryName'];
                      String image =
                          "assets/ProjectImages/CountryFlags/$countryName.png";

                      return ListTile(
                        onTap: () {
                          setState(() {
                            image1 = image;
                          });
                          DropDownInListClick(index, context);
                        },
                        title: Text(acc1TypeList[index]['CountryName']),
                        subtitle: Text(
                          acc1TypeList[index]['CountryCode'].toString(),
                        ),
                        trailing:
                            Text(acc1TypeList[index]["ClientID"].toString()),
                        leading: Container(
                          child: Image.asset(
                             image,
                            fit: BoxFit.cover,
                          ),
                          height: 34,
                          width: 44,
                          decoration: BoxDecoration(
                            //color: Colors.blue,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      );
                      // return InkWell(
                      //   onTap: () => DropDownInListClick(index, context),
                      //   child: Card(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Row(
                      //         children: [
                      //           SingleChildScrollView(
                      //             scrollDirection: Axis.horizontal,
                      //             child: SizedBox(
                      //               width:
                      //                   MediaQuery.of(context).size.width / 1.5,
                      //               child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   (){
                      //
                      //                    if (acc1TypeList.length<widget.acc1TypeList!.length) {
                      //                     debugPrint("in if");
                      //                      return RichText(
                      //                        text: Constants.searchMatch(acc1TypeList[index]['Title']
                      //                            .toString(), _searchController.text)
                      //                      );
                      //
                      //                    }else{
                      //                      return Text(acc1TypeList[index]['CountryName']
                      //                          .toString());
                      //                    }
                      //                   }() ,
                      //                   Text(
                      //                     acc1TypeList[index]['CountryCode']
                      //                         .toString(),
                      //                     style: TextStyle(
                      //                         fontSize: 13, color: Colors.grey),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //           Spacer(),
                      //           Column(
                      //             children: [
                      //               Text(acc1TypeList[index]["ID"].toString()),
                      //               Text(acc1TypeList[index]["ClientID"]
                      //                   .toString()),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getSearchList(String searchValue) {
    List<Map<dynamic, dynamic>> tempList = [];

    for (Map<dynamic, dynamic> element in widget.acc1TypeList!) {
      if (element['CountryName']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      }
    }
    acc1TypeList = tempList;
  }

  DropDownInListClick(int index, BuildContext context) {
    print('//////////////////////////////////$acc1TypeList');
    lis.insert(0, acc1TypeList[index]['CountryName'].toString());
    lis.add(acc1TypeList[index]['CountryCode'].toString());
    setState(() {});
    Navigator.pop(context, {
      "ID": acc1TypeList[index]['ID'].toString(),
      'CountryName': acc1TypeList[index]['CountryName'].toString(),
      'CountryCode': acc1TypeList[index]['CountryCode'].toString(),
      "ClientID": acc1TypeList[index]['ClientID'].toString(),
      "Image": image1,
      'DateFormat': acc1TypeList[index]['DateFormat'].toString(),
      'CurrencySign': acc1TypeList[index]['CurrencySigne'].toString(),
      'Code2': acc1TypeList[index]['Code2'].toString(),
    });
  }

  static DropDownButton(
      {String? title,
      String? id,
      String? subtitle,
      int? value,
      String? image = ''}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white),
      child: ListTile(
        //leading:image == "" ?
        leading: image == ''
            ? SizedBox()
            : Container(
                child: Image.asset(
                   image!,
                  fit: BoxFit.cover,
                ),
                height: 34,
                width: 44,
                decoration: BoxDecoration(
                  //color: Colors.blue,
                  shape: BoxShape.rectangle,
                ),
              ),
        trailing: Icon(
          Icons.arrow_downward,
          color: Colors.grey,
          size: 20,
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
