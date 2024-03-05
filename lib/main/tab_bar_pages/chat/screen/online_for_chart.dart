import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared_preferences/shared_preference_keys.dart';
import '../Controller/global_methods.dart';
import 'chat_screen.dart';
import '../Controller/provider.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // checkConnection() async {
  //   bool result = await InternetConnectionChecker().hasConnection;
  //   if (result == true) {
  //     GlobalState.isConnectionEnable = true;
  //     if (GlobalState.dataListen == null) {
  //       await fetchAllMessages();
  //     }
  //   } else {
  //     GlobalState.isConnectionEnable = false;
  //   }
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      FirebaseFirestore.instance
          .collection("chats")
          .doc(SharedPreferencesKeys.prefs!
              .getString(SharedPreferencesKeys.mobileNumber))
          .update({"statusOnline": true, "lastSeen": DateTime.now()});
    } else {
      FirebaseFirestore.instance
          .collection("chats")
          .doc(SharedPreferencesKeys.prefs!
              .getString(SharedPreferencesKeys.mobileNumber))
          .update({"statusOnline": false});
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    print(SharedPreferencesKeys.prefs!
        .getString(SharedPreferencesKeys.mobileNumber));
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.mobileNumber))
            .collection("personalChats")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot data = snapshot.data as QuerySnapshot;
            return data.docs.isEmpty
                ? const Center(child: Text("No Chats Found"))
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.docs.length,
                    separatorBuilder: (ctx, i) {
                      return const Divider();
                    },
                    itemBuilder: (ctx, i) {
                      MyProvider provider = Provider.of(context, listen: false);
                      provider.fetchMessagesUser(data.docs[i].get("number"));
                      return Consumer<MyProvider>(
                          builder: (context, provider, child) {
                        return ListTile(
                            title: Text(
                              data.docs[i].get("name"),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person),
                            ),
                            onTap: () async {
                              provider.getUnSeenMessagesList.clear();

                              getUnSeenMessages(
                                  "${snapshot.data!.docs[i].get("number")}");

                              firebaseInstance
                                  .doc(
                                      "${snapshot.data!.docs[i].get("number")}")
                                  .update({
                                "seenTime": DateTime.now(),
                              });
                              FirebaseFirestore.instance
                                  .collection("chats")
                                  .doc(
                                      "${snapshot.data!.docs[i].get("number")}")
                                  .collection("personalChats")
                                  .doc(SharedPreferencesKeys.prefs!.getString(
                                      SharedPreferencesKeys.mobileNumber))
                                  .update({
                                "isSeen": true,
                                "seenTime": DateTime.now(),
                                "status": "seen"
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen({
                                    "name": snapshot.data!.docs[i].get("name"),
                                    "number":
                                        snapshot.data!.docs[i].get("number"),
                                    "seenTime":
                                        snapshot.data!.docs[i].get("seenTime"),
                                    "isSeen":
                                        snapshot.data!.docs[i].get("isSeen"),
                                  }),
                                ),
                              );
                            },
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    provider.getUnSeenMessagesList.length
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green[400])),
                                provider.getUnSeenMessagesList.isEmpty
                                    ? const SizedBox(
                                        height: 0,
                                        width: 0,
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green[400],
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Text(
                                          "${provider.getUnSeenMessagesList.length}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ],
                            ));
                      });
                    },
                  );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
