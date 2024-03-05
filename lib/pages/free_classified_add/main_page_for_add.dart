import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:com/pages/free_classified_add/ads_details_page.dart';
import 'package:com/pages/free_classified_add/create_category.dart';
import 'package:com/pages/free_classified_add/sql_file.dart';
import 'package:com/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'image_upload_to_server/image_upload_to_server.dart';

class MainPAgeForAdd extends StatefulWidget {
  final String title;
  final int projectID;

  const MainPAgeForAdd(
      {super.key, required this.title, required this.projectID});

  @override
  State<MainPAgeForAdd> createState() => _MainPAgeForAddState();
}

class _MainPAgeForAddState extends State<MainPAgeForAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            Center(
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateCategory(),
                          ));
                    },
                    child: Text('Post Your Ads'))),
            FutureBuilder<List>(
              future: getAddCategory1Data(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => snapshot.data![index]
                                  ['Category1Name'] !=
                              ''
                          ? ExpansionTile(
                              leading: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/ProjectImages/adsCategory1/${snapshot.data![index]['ID1']}.png')),
                              title:
                                  Text(snapshot.data![index]['Category1Name']),
                              children: [
                                FutureBuilder<List>(
                                  future: getAddCategory2Data(
                                      ID1: snapshot.data![index]['ID1']),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding: const EdgeInsets.only(
                                              left: 32.0, top: 8),
                                          child: snapshot.data![index]
                                                      ['Category2Name'] ==
                                                  ''
                                              ? SizedBox()
                                              : ListTile(
                                                  title: Text(
                                                      snapshot.data![index]
                                                          ['Category2Name']),
                                                  leading: CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/ProjectImages/adsCategory2/${snapshot.data![index]['ID2']}.png')),
                                                ),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ],
                            )
                          : const SizedBox());
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            FutureBuilder<List>(
              future: getAddCategory4Data(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(
                      '//////////////////////////////////////////////////////${snapshot.data!.last}');
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisExtent: 220),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () async {
                        int i = 0;
                        List list = [];
                        Constants.onLoading(context, 'Fetching Images.....');
                        while (true) {
                          Uint8List? images = await fetchImage(
                              i, '${snapshot.data![index]['ID4'].toString()}');

                          print(i);

                          if (images == null) {
                            break;
                          } else {
                            list.add(images);
                            i++;
                          }
                        }
                        Constants.hideDialog(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdsDetailsPage(
                                map: snapshot.data![index],
                                images: list,
                              ),
                            ));
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  'https://www.api.easysoftapp.com/PhpApi1/ClassifiedAds/${snapshot.data![index]['ID4'].toString()}/0.jpg',
                              height: 100,
                              width: double.infinity,
                              alignment: Alignment.center,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/easysoft_logo.jpg',
                                alignment: Alignment.center,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8),
                              child: Text(
                                'Rs ${snapshot.data![index]['Price'].toString()}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8),
                              child: Text(
                                '${snapshot.data![index]['AddTitle'].toString()}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w300),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8),
                              child: Text(
                                '${snapshot.data![index]['City'].toString()},${snapshot.data![index]['Country'].toString()}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
