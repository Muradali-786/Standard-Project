import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FlutterWeb extends StatefulWidget {
  FlutterWeb({Key? key}) : super(key: key);

  @override
  State<FlutterWeb> createState() => _FlutterWebState();
}

class _FlutterWebState extends State<FlutterWeb> {
  String apiUri =
      'https://api.easysoftapp.com/PhpApi1/GenericAPI/genericAPI1.php?query=';

  final String query = 'select * from Project;';

  Future<void> getDataFromApiForWeb(String query) async {
    final String finalApiUrl = apiUri + query;
    final response = await http.get(Uri.parse(finalApiUrl));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List list = json as List<dynamic>;
      debugPrint('-------------------------$list-----------------');
    } else {
      debugPrint(
          '-------------------------Api Response Error-----------------');
    }
  }

  fun() async {
    await getDataFromApiForWeb(query);
  }

  @override
  void initState() {
    fun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter for Web'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.amber,
      ),
    );
  }
}
