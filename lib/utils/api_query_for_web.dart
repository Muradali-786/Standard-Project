import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;



// https://ghousiabuilders.com/phpapi/genericApi2ForAccess.php?query=select%20*%20from%20Account3Name


Future<List> apiFetchForWeb({required String query}) async {
  List jsonResponse =[];

  //
  // var url = Uri.https(
  //     'ghousiabuilders.com',
  //     '/phpapi/genericApi2ForAccess.php',
  //     {'query': query});

  var url = Uri.https(
      'api.easysoftapp.com',
      '/PhpApi1/GenericAPI/genericAPI3.php',
      {'query': query});
  var response = await http.get(url ,headers: {
    'Accept': '*/*',
    'User-Agent': 'request',
  });

  if (response.statusCode == 200) {
   print('......200............${response.body}............................');
    jsonResponse = convert.jsonDecode(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

  return jsonResponse;
}

Future<void> apiPostForWeb({required String query}) async {


  //
  // var url = Uri.https(
  //     'ghousiabuilders.com',
  //     '/phpapi/genericApi2ForAccess.php',
  //     {'query': query});



  var url = Uri.https(
      'api.easysoftapp.com',
      '/PhpApi1/GenericAPI/genericAPI3.php',
      {'query': query});
  var response = await http.post(url ,headers : { "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"},encoding : Encoding.getByName('utf-8'));

  if (response.statusCode == 200) {
    print('......200............${response.body}............................');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
