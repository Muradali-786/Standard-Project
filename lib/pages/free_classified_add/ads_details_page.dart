import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../shared_preferences/shared_preference_keys.dart';

class AdsDetailsPage extends StatefulWidget {
  final Map<dynamic, dynamic> map;
  final List images;

  const AdsDetailsPage({super.key, required this.map, required this.images});

  @override
  State<AdsDetailsPage> createState() => _AdsDetailsPageState();
}

class _AdsDetailsPageState extends State<AdsDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height *.3,
                child: PageView.builder(
              itemCount: widget.images.length,
              itemBuilder: (context, index) => Container(
                color: Colors.grey,
                child: Image.memory(widget.images[index], fit: BoxFit.cover),
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Rs ${widget.map['Price'].toString()}', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),)),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('${widget.map['AddTitle'].toString()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('${widget.map['City'].toString()},${widget.map['Country'].toString()}',overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),)),
            ),
            Spacer(),

            ElevatedButton(onPressed: () async{
              await launchUrlString(
                  "whatsapp://send?phone=${SharedPreferencesKeys.prefs!
                      .getString(SharedPreferencesKeys
                      .mobileNumber)
                      .toString()}&text=${'Hi,'}");
            }, child: Text('WhatsApp'))
          ],
        )),
      ),
    );
  }
}
