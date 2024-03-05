import 'package:com/pages/beauty_salon/sql_file_beauty_salon.dart';
import 'package:com/pages/beauty_salon/widget.dart';
import 'package:flutter/material.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import 'add_beautician_screen.dart';
import 'add_bill_beauty_salon.dart';
import 'all_bill_list.dart';
import 'all_token_screen.dart';

class BeauticianMainScreen extends StatefulWidget {
  const BeauticianMainScreen({super.key});

  @override
  State<BeauticianMainScreen> createState() => _BeauticianMainScreenState();
}

class _BeauticianMainScreenState extends State<BeauticianMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Add new beautician'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBeauticianScreen(),
                      ));
                },
              ),
            ),
            FutureBuilder<List>(
              future: getAllBeautician(
                  clientId: SharedPreferencesKeys.prefs!
                      .getInt(SharedPreferencesKeys.clinetId)!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddBillBeautySalon(
                                      chairNo: '${snapshot.data![index]['ChairNo']}',
                                      beauticianID: snapshot.data![index]
                                              ['BeauticianID']
                                          .toString()),
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${snapshot.data![index]['BeauticianName']}', style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),),
                                          Text(
                                            'Seat No. ${snapshot.data![index]['ChairNo']}',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),

                                          Text('job'),
                                          Text('amount'),
                                        ],
                                      ),
                                      Spacer(),
                                      menuBtnForBeauty(onSelected: (value) {
                                        if (value == 1) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddBeauticianScreen(
                                                        data: snapshot.data![index]),
                                              ));
                                        }
                                        if (value == 2) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllBillList()));
                                        }
                                      })
                                    ],
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AllTokenList(),
                                              ));
                                        },
                                        child: Text(
                                          'Online Token : 5',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
