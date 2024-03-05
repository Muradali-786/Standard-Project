import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared_preferences/shared_preference_keys.dart';


var firebaseInstance = FirebaseFirestore.instance
    .collection("chats")
    .doc(SharedPreferencesKeys.prefs!
        .getString(SharedPreferencesKeys.mobileNumber))
    .collection("personalChats");

fetchAllMessages() async {
  await firebaseInstance.snapshots().listen((event) {
    print(event.docs);
  });
}

getUnSeenMessages(uid) async {
  await FirebaseFirestore.instance
      .collection("chats")
      .doc(uid)
      .collection("personalChats")
      .doc(SharedPreferencesKeys.prefs!
          .getString(SharedPreferencesKeys.mobileNumber))
      .collection("privateChat")
      .get()
      .then((value) {
    value.docs.forEach((element) {
      if (element.get("status") == 'sent' || element.get("seenTime") == null) {
        FirebaseFirestore.instance
            .collection("chats")
            .doc(uid)
            .collection("personalChats")
            .doc(SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.mobileNumber))
            .collection("privateChat")
            .doc(element.id)
            .update({
          // "deliverTime": DateTime.now(),
          "status": "deliver",
          "seenTime": DateTime.now()
        });
      }
    });
  });

  await FirebaseFirestore.instance
      .collection("chats")
      .doc(SharedPreferencesKeys.prefs!
          .getString(SharedPreferencesKeys.mobileNumber))
      .collection("personalChats")
      .doc(uid)
      .collection("privateChat")
      .get()
      .then((value) {
    value.docs.forEach((element) {
      if (element.get("status") == 'sent' || element.get("seenTime") == null) {
        FirebaseFirestore.instance
            .collection("chats")
            .doc(uid)
            .collection("personalChats")
            .doc(SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.mobileNumber))
            .collection("privateChat")
            .doc(element.id)
            .update({
          // "deliverTime": DateTime.now(),
          "status": "deliver",
          "seenTime": DateTime.now()
        });
      }
    });
  });
}
