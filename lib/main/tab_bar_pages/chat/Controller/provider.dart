import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../../shared_preferences/shared_preference_keys.dart';
import 'global_methods.dart';

class MyProvider extends ChangeNotifier {
  var messages;
  var getUnSeenMessagesList = [];

  List<Contact> contacts = [];
  List dbSavedUsers = [];

  Future<List>  fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts();
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

    } else {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
    }

    return contacts;
  }

  Future<List>  fetchDBUsers() async {
   await FirebaseFirestore.instance.collection('chats').snapshots().listen((event) {
      event.docs.forEach((element) {
        dbSavedUsers.add(element.id);
      });
    });

    print(dbSavedUsers);

    return dbSavedUsers;
  }

  fetchMessagesUser(uid)  async{
    var seenTime;

   await firebaseInstance.doc(uid).get().then((event) {
     seenTime = DateTime.parse(event.get('seenTime').toDate().toString());
      firebaseInstance.doc(uid).collection("privateChat").get().then((value) {
        getUnSeenMessagesList.clear();
        value.docs.forEach((element) {
          if (element.get("isSentByMe") == false) {
            print("inside me");
            if (DateTime.parse(element.get("time").toDate().toString())
                    .compareTo(seenTime) >
                0) {
              getUnSeenMessagesList.add(element);
              notifyListeners();
            } else {
              print("No Message");
            }
          }
        });
      });
    });

    print('..........................$uid');
    FirebaseFirestore.instance
        .collection("chats")
        .doc(uid)
        .collection("personalChats").doc(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.mobileNumber)).collection("privateChat").get().then((value) {
      value.docs.forEach((element) {
        if (element.get("deliverTime") == null || element.get("deliverTime") ==  'sent' ) {
          FirebaseFirestore.instance
              .collection("chats")
              .doc(uid)
              .collection("personalChats").doc(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.mobileNumber)).collection("privateChat")
              .doc(element.id)
              .update({
            "deliverTime": DateTime.now(),
            'status'  :  "deliver"
          });
        }
      });
    });
  }

}



class SelectedMessages<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; //Data of the user
  SelectedMessages(this.data); //Constructor to assign the data
}
