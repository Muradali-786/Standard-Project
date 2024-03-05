import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';

class DueFeeDetails extends StatefulWidget {
  final List list;

  const DueFeeDetails({required this.list, Key? key}) : super(key: key);

  @override
  State<DueFeeDetails> createState() => _DueFeeDetailsState();
}

class _DueFeeDetailsState extends State<DueFeeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
          .backGroundColor,
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            color: Provider.of<ThemeDataHomePage>(context, listen: false)
                .borderTextAppBarColor,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Due Fee Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ListView.builder(
            itemCount: widget.list.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            widget.list[index]['DueDate'] != null
                                ? Text(
                                    '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.list[index]['DueDate'].toString().substring(0, 4)), int.parse(widget.list[index]['DueDate'].toString().substring(
                                          5,
                                          7,
                                        )), int.parse(widget.list[index]['DueDate'].toString().substring(8, 10)))).toString()} , ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                                : SizedBox(),
                            Text(widget.list[index]['FeeNarration'])
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                    '${widget.list[index]['TotaFeeDue'].toString()}  , '),
                                Text(widget.list[index]['TotalReceived']
                                    .toString()),
                              ],
                            ),
                            Text(widget.list[index]['TotalBalnce'].toString()),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
