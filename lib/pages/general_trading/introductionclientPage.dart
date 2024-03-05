import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/pages/beauty_salon/token_outside_client.dart';
import 'package:flutter/material.dart';
import 'package:com/pages/login/create_client.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main/tab_bar_pages/home/home_page_code_provider.dart';
import '../../main/tab_bar_pages/home/themedataclassforproject.dart';
import '../../shared_preferences/shared_preference_keys.dart';

class IntroductionClientPage extends StatefulWidget {
  final int clientID;
  final String projectName;
  final int projectID;

  const IntroductionClientPage(
      {Key? key,
      required this.projectID,
      required this.clientID,
      required this.projectName})
      : super(key: key);

  @override
  State<IntroductionClientPage> createState() => _IntroductionClientPageState();
}

class _IntroductionClientPageState extends State<IntroductionClientPage> {
  CollectionReference country =
      FirebaseFirestore.instance.collection('Country');

  Set<String> chairCatList = {};
  var chairAllData = [];

  Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
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
          PopupMenuItem(value: 0, child: Text('Edit Profile')),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeDataHomePageForProject>(context, listen: false)
              .backGroundColor,
      appBar: AppBar(
        backgroundColor:
            Provider.of<ThemeDataHomePageForProject>(context, listen: false)
                .borderTextAppBarColor,
        title: Text(
          '${widget.projectName}',
          maxLines: 2,
        ),
        centerTitle: true,
        actions: [
          popUpButtonForItemEdit(onSelected: (value) async {
            if (value == 0) {
              List snapList =
                  await Provider.of<DashboardProvider>(context, listen: false)
                      .getInfoAboutClientFromServer(widget.clientID, context);
              print(snapList);
              if (SharedPreferencesKeys.prefs!
                      .getString(SharedPreferencesKeys.email) ==
                  snapList[0]['Email']) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateClient(
                          listOFClient: snapList,
                          projectId: widget.projectID,
                          status: 'EDIT',
                          projectName: widget.projectName),
                    ));
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: AlertDialog(
                          content: Text('You are not owner of this profile'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('ok'))
                          ],
                        ),
                      );
                    });
              }
            }
          })
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: Provider.of<DashboardProvider>(context, listen: false)
              .getInfoAboutClientFromServer(widget.clientID, context),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                                height: 130,
                                width: 130,
                                imageUrl:
                                    'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${widget.clientID}',
                                alignment: Alignment.center,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                errorWidget: (context, url, error) => Container(
                                      color: Colors.grey,
                                    )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Center(
                          child: Text(
                            snapshot.data![0]['CompanyName'],
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Center(
                          child: Text(
                            snapshot.data![0]['BusinessDescriptions'],
                            maxLines: 5,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          title: Text(
                            snapshot.data![0]['CompanyAddress'],
                          ),
                          subtitle: Text(
                              '${snapshot.data![0]['Country']} , ${snapshot.data![0]['City']} ,  ${snapshot.data![0]['SubCity']}'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                          title: Text(
                            snapshot.data![0]['CompanyNumber'],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          final Uri _url = Uri.parse(
                              'https://${snapshot.data![0]['WebSite']}');
                          launchUrl(_url);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.web,
                              color: Colors.blue,
                            ),
                            title: Text(
                              snapshot.data![0]['WebSite'],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          final Uri _url = Uri.parse(
                              'https://www.facebook.com/${snapshot.data![0]['Facebook']}');
                          launchUrl(_url);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.facebook,
                              color: Colors.blue,
                            ),
                            title: Text(
                              snapshot.data![0]['Facebook'].toString(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TokenOutSideClient(
                                            clientID: widget.clientID,
                                          )));
                            },
                            child: Text('Get Token')),
                      ),
                      StreamBuilder(
                        stream: country
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                            .collection('CountryUser')
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                            .collection('Client')
                            .doc('${widget.clientID}')
                            .collection('Token')
                            .orderBy(
                              'TokenNo',
                            )
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            chairCatList.clear();

                            snapshot.data!.docs.forEach((element) {
                              chairCatList.add(element['ChairNo']);
                            });

                            return ListView.builder(
                              itemCount: chairCatList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, chairIndex) {
                                var chairAllData = snapshot.data!.docs.where(
                                    (element) =>
                                        chairCatList.elementAt(chairIndex) ==
                                        element['ChairNo']);

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Chair number :  ${chairCatList.elementAt(chairIndex)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      itemCount: chairAllData.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0, right: 4),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: 50,
                                                    child: Text(
                                                      '${chairAllData.elementAt(index)['TokenNo']}',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${chairAllData.elementAt(index)['CustomerName']}',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '${chairAllData.elementAt(index)['Status']}',
                                                          ),
                                                          Text(
                                                            '${chairAllData.elementAt(index)['BillAmount']}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
