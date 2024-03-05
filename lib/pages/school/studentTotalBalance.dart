import 'package:flutter/material.dart';
import 'package:com/pages/school/SchoolSql.dart';
import 'package:com/pages/school/StudentLedger.dart';
import '../../shared_preferences/shared_preference_keys.dart';

class StudentTotalBalance extends StatefulWidget {
  final List listOFAllStudent;

  const StudentTotalBalance({Key? key, required this.listOFAllStudent})
      : super(key: key);

  @override
  State<StudentTotalBalance> createState() => _StudentTotalBalanceState();
}

class _StudentTotalBalanceState extends State<StudentTotalBalance> {
  String toDate =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String fromDate =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  TextEditingController _searchController = TextEditingController();
  IconData iconData = Icons.list;
  SchoolSQL _schoolSQL = SchoolSQL();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          /// tool bar //////////////////////////
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///                      Date     ///
                  ///                      search     ///
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: TextFormField(
                      //initialValue: args.dropdown_title,
                      //controller: passwordController,
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
                              style: BorderStyle.solid),
                        ),
                      ),
                      controller: _searchController,
                      onChanged: (value) {
                        //  getSearchList(searchValue: value);

                        if (value.length == 0) {
                          print("value is zero");
                        }
                        setState(() {});
                      },
                    ),
                  ),

                  ///                      filter     ///
                  IconButton(
                    onPressed: () {
                      showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(40.0, 50.0, 50.0, 0.0),
                        //position where you want to show the menu on screen
                        items: [
                          PopupMenuItem<String>(
                              child: const Text('All Records'), value: '1'),
                          PopupMenuItem<String>(
                              child: const Text('Greater Then Zero'),
                              value: '2'),
                          PopupMenuItem<String>(
                              child: const Text('Less then Zero'), value: '3'),
                        ],
                        elevation: 8.0,
                      ).then(
                        (value) async {
                          if (value == '1') {}
                          if (value == '2') {}
                          if (value == '3') {}
                        },
                      );
                    },
                    icon: Icon(Icons.filter_alt_outlined),
                  ),

                  ///                      views to show as list , grid , tree     ///
                  IconButton(
                    onPressed: () {
                      showMenu<IconData>(
                        context: context,
                        position: RelativeRect.fromLTRB(70.0, 235.0, 40.0, 0.0),
                        //position where you want to show the menu on screen
                        items: [
                          PopupMenuItem<IconData>(
                            child: const Icon(Icons.list),
                            value: Icons.list,
                          ),
                          PopupMenuItem<IconData>(
                            child: const Icon(Icons.grid_on),
                            value: Icons.grid_on,
                          ),
                          PopupMenuItem<IconData>(
                            child: const Icon(Icons.account_tree),
                            value: Icons.account_tree,
                          ),
                        ],
                        elevation: 8.0,
                      ).then((value) async {
                        if (value == null) {}
                        if (value == Icons.list) {
                          setState(() {
                            iconData = Icons.list;
                          });
                        }
                        if (value == Icons.grid_on) {
                          setState(() {
                            iconData = Icons.grid_on;
                          });
                        }
                        if (value == Icons.account_tree) {
                          setState(() {
                            iconData = Icons.account_tree;
                          });
                        }
                      });
                    },
                    icon: Icon(iconData),
                  ),

                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        size: 20,
                        color: Colors.grey,
                      )),
                ],
              ),
            ),
          ),
          ListView.builder(
            itemCount: widget.listOFAllStudent.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      List studentLedgerList =
                          await _schoolSQL.dataForAllStudentLedgerFeeDue(
                              widget.listOFAllStudent[index]['GRN'].toString());

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentLedger(
                              list: studentLedgerList,
                            ),
                          ));
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                    '${widget.listOFAllStudent[index]['GRN']} ,'),
                                Text(
                                    '${widget.listOFAllStudent[index]['StudentName']} ,'),
                                Text(widget.listOFAllStudent[index]['FahterName'])
                              ],
                            ),
                            SizedBox(
                              height: 20,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: popUpButtonForItemEdit(
                                    onSelected: (value) async {
                                  if (value == 0) {}
                                }),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                    '${widget.listOFAllStudent[index]['SectionName']} ,'),
                                Text(
                                    '${widget.listOFAllStudent[index]['ClassName']} ,'),
                                Text(widget.listOFAllStudent[index]['BranchName'])
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                widget.listOFAllStudent[index]['TotalBallance']
                                    .toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  ///  pop button for edit student details ////////////////////////////////////
  Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      icon: Icon(
        Icons.more_horiz,
        size: 20,
        color: Colors.grey,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('Edit')),
          // PopupMenuItem(value: 1, child: Text('Delete')),
        ];
      },
    );
  }
}
