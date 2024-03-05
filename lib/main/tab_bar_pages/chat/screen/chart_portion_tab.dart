
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../shared_preferences/shared_preference_keys.dart';
import 'chat_screen.dart';
import 'online_for_chart.dart';


class ChatsScreen extends StatefulWidget {

 final List  contacts ;
 final List dbUser;
    ChatsScreen({required  this.contacts,required this.dbUser});
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// chart portion................................................................
          ChatsTab(),


          /// Contact ................................................................
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: widget.contacts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                itemCount: widget.contacts.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return widget.contacts[i].phones.isEmpty
                      ? Container()
                      : SizedBox(
                    height: 60,
                    child: ListTile(
                      onTap: () {
                        if (widget.dbUser.contains(
                            widget.contacts[i].phones[0].normalizedNumber)) {
                          FirebaseFirestore.instance
                              .collection("chats")
                              .doc(widget.contacts[i]
                              .phones[0]
                              .normalizedNumber)
                              .collection("personalChats")
                              .doc(SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys
                              .mobileNumber))
                              .set({
                            "name": SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys
                                .nameOfPerson),
                            "number": SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys
                                .mobileNumber),
                            "seenTime": DateTime.now(),
                            "isSeen": true,
                          });

                          FirebaseFirestore.instance
                              .collection("chats")
                              .doc(SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys
                              .mobileNumber))
                              .collection("personalChats")
                              .doc(widget.contacts[i]
                              .phones[0]
                              .normalizedNumber)
                              .set({
                            "name": widget.contacts[i].displayName,
                            "number": widget.contacts[i]
                                .phones[0]
                                .normalizedNumber,
                            "seenTime": null,
                            "isSeen": false,
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChatScreen({
                                    "name":
                                    widget.contacts[i].displayName,
                                    "number": widget.contacts[i]
                                        .phones[0]
                                        .normalizedNumber,
                                    "seenTime": DateTime.now(),
                                    "isSeen": true,
                                  })));
                        }
                      },
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        widget.contacts[i].displayName,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis),
                      ),
                      subtitle: Text(
                          widget.contacts[i].phones[0].number.toString()),
                      trailing: widget.dbUser.contains(
                          widget.contacts[i].phones[0].normalizedNumber)
                          ? const SizedBox()
                          : MaterialButton(
                        minWidth: 30,
                        onPressed: () {
                          //  launchWhatsapp(contacts[i].phones[0].normalizedNumber,"Our Application is Under Development phase ignore this Message its just for test1");
                        },
                        child: const Text(
                          "Invite",
                          style: TextStyle(color: Colors.blue),
                        ),
                        //  color: primaryColor,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}