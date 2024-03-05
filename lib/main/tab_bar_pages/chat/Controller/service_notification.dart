import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../shared_preferences/shared_preference_keys.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  LocalNotificationService();

  // final localNotification = FlutterLocalNotificationsPlugin();

  // Future<void> intialize() async {
  //   AndroidInitializationSettings andriodSetting =
  //       const AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  //   InitializationSettings setting =
  //       InitializationSettings(android: andriodSetting);
  //
  //   await localNotification.initialize(setting,
  //       onSelectNotification: (value) {});
  // }

  // Future<NotificationDetails> notificationDetails() async {
  //   AndroidNotificationDetails details = const AndroidNotificationDetails(
  //     'channelId',
  //     'channelName',
  //     playSound: true,
  //     priority: Priority.high,
  //     importance: Importance.high,
  //     channelDescription: 'Here am i',
  //   );
  //
  //   return NotificationDetails(android: details);
  // }

  // Future<void> showNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  // }) async {
  //   var details = await notificationDetails();
  //   await localNotification.show(id, title, body, details);
  // }
}

Future<void> sendPushNotification(
    {required String number, required String body}) async {
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  FirebaseFirestore.instance
      .collection('chats')
      .doc(number)
      .get()
      .then((value) {
    print('........sending notification..........');

    var response = http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA4BmbhoI:APA91bEhp1Cm2XfZFygYhVshNc9hIIPLC8RjLI5BsUw8nuECLFFT-umamqimrZtKTn0hJJu3sWlY4vxDANl8N7WdYqOEeX_BDh-oj4OEmZB7Linakd6Q7KoYrT8JCBDbpjdYucq2EMjO'
        },
        body: jsonEncode({
          "priority": "high",
          'to': value.data()!['deviceToken'],
          "notification": {
            "body": body,
            "title": SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.nameOfPerson)
                .toString(),
            "android_channel_id": "channelId"
          }
        }));

    print(response);
  });
}
