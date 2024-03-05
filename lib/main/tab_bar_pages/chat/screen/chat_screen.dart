import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/main/tab_bar_pages/chat/widget/bottom_sheet.dart';
import 'package:com/main/tab_bar_pages/chat/widget/render_msg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../../shared_preferences/shared_preference_keys.dart';
import '../Controller/global_methods.dart';
import '../Controller/provider.dart';
import '../Controller/service_notification.dart';

class ChatScreen extends StatefulWidget {
  final Map info;

  // ignore: use_key_in_widget_constructors
  const ChatScreen(this.info);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  var selectedText;
  FocusNode focusNode = FocusNode();
  var colorsIconVoice = Colors.white;
  bool sendButton = false;
  bool show = false;
  bool status = false;
  static const Color primaryColor = Color(0xFF075E54);
  var lastSeen;
  bool isSelectedText = false;
  bool isAnySelected = false;
  List<SelectedMessages<String>>? selectedMessages;
  List midList = [];
  String currentAudioPath = '';
  final record = AudioRecorder();
  AudioPlayer? player;
  final storageRef = FirebaseStorage.instance.ref();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection("chats")
        .doc("${widget.info["number"]}")
        .collection("personalChats")
        .doc(SharedPreferencesKeys.prefs!
            .getString(SharedPreferencesKeys.mobileNumber))
        .update({
      "isSeen": false,
    });
    super.dispose();
  }

  /// text field for send message.....................................
  Widget renderTextBox(context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          !isSelectedText
              ? Container()
              : Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width,

                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Container(
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 5,
                            decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 76,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "you",
                                        style: TextStyle(
                                            color: Colors.green[400],
                                            fontWeight: FontWeight.w500),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedText = null;
                                            isSelectedText = false;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "$selectedText",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

          ///     textField for send msg .......................................
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: Card(
                  margin: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: !isSelectedText
                        ? BorderRadius.circular(25)
                        : const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                  ),
                  child: TextFormField(
                    controller: _controller,
                    // autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          sendButton = true;
                        });
                      } else {
                        setState(() {
                          sendButton = false;
                        });
                      }
                    },
                    //  style: TextStyle(fontSize: 17.0, color: Colors.grey),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Message",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: IconButton(
                        icon: Icon(
                          show ? Icons.keyboard : Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          if (!show) {
                            focusNode.unfocus();
                            focusNode.canRequestFocus = false;
                          }
                          setState(() {
                            show = !show;
                          });
                        },
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (builder) => BottomSheetView(
                                      number: widget.info['number'],
                                      status: status,
                                      selectedText: selectedText));
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),

              ///  Send Message btn .............................................
              Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    right: 2,
                    left: 2,
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF128C7E),
                    child: _controller.text.toString().length > 0
                        ? IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              if (_controller.text.isNotEmpty) {
                                var seenStatus = await FirebaseFirestore
                                    .instance
                                    .collection("chats")
                                    .doc(SharedPreferencesKeys.prefs!.getString(
                                        SharedPreferencesKeys.mobileNumber))
                                    .collection("personalChats")
                                    .doc("${widget.info["number"]}")
                                    .get();

                                FirebaseFirestore.instance
                                    .collection("chats")
                                    .doc(SharedPreferencesKeys.prefs!.getString(
                                        SharedPreferencesKeys.mobileNumber))
                                    .collection("personalChats")
                                    .doc(widget.info['number'])
                                    .collection("privateChat")
                                    .add({
                                  "time": DateTime.now(),
                                  "isSentByMe": true,
                                  "message": _controller.text,
                                  "status": status ? 'deliver' : "sent",
                                  "sentTime": DateTime.now(),
                                  "deliverTime": status ? DateTime.now() : null,
                                  "seenTime": seenStatus.data()!['isSeen']
                                      ? DateTime.now()
                                      : null,
                                  "isReplyMessage":
                                      selectedText != null ? true : false,
                                  "repliedMessage": selectedText
                                });

                                ///  Person Contact
                                FirebaseFirestore.instance
                                    .collection("chats")
                                    .doc(widget.info["number"])
                                    .collection("personalChats")
                                    .doc(SharedPreferencesKeys.prefs!.getString(
                                        SharedPreferencesKeys.mobileNumber))
                                    .collection("privateChat")
                                    .add({
                                  "time": DateTime.now(),
                                  "isSentByMe": false,
                                  "message": _controller.text,
                                  "status": status ? 'deliver' : "sent",
                                  "sentTime": DateTime.now(),
                                  "deliverTime": status ? DateTime.now() : null,
                                  "seenTime": seenStatus.data()!['isSeen']
                                      ? DateTime.now()
                                      : null,
                                  "isReplyMessage":
                                      selectedText != null ? true : false,
                                  "repliedMessage": selectedText,
                                  // "number" : isSentByMe ? widget.info['number'] :GlobalState.myNumber,
                                });

                                sendPushNotification(
                                    number: widget.info["number"],
                                    body: _controller.text.toString());

                                selectedText = null;

                                setState(() {
                                  isSelectedText = false;
                                });
                              }
                            },
                          )
                        : IconButton(
                            onPressed: () async {
                              bool isRecording = await record.isRecording();
                              if (isRecording) {
                                record.stop();

                                File file = File(currentAudioPath);
                                var urlVoice = '';
                                try {
                                  var upload = await storageRef
                                      .child('Data/audio')
                                      .child(
                                          '${DateTime.now().millisecondsSinceEpoch}')
                                      .putFile(file);
                                  var snap = await upload;

                                  urlVoice = await snap.ref.getDownloadURL();
                                } on FirebaseException catch (e) {
                                  print(e);
                                }

                                setState(() {
                                  colorsIconVoice = Colors.white;
                                });

                                var seenStatus = await FirebaseFirestore
                                    .instance
                                    .collection("chats")
                                    .doc(SharedPreferencesKeys.prefs!.getString(
                                        SharedPreferencesKeys.mobileNumber))
                                    .collection("personalChats")
                                    .doc("${widget.info["number"]}")
                                    .get();

                                FirebaseFirestore.instance
                                    .collection("chats")
                                    .doc(SharedPreferencesKeys.prefs!.getString(
                                        SharedPreferencesKeys.mobileNumber))
                                    .collection("personalChats")
                                    .doc(widget.info['number'])
                                    .collection("privateChat")
                                    .add({
                                  "time": DateTime.now(),
                                  "isSentByMe": true,
                                  "message": '',
                                  'voice': urlVoice,
                                  "status": status ? 'deliver' : "sent",
                                  "sentTime": DateTime.now(),
                                  "deliverTime": status ? DateTime.now() : null,
                                  "seenTime": seenStatus.data()!['isSeen']
                                      ? DateTime.now()
                                      : null,
                                  "isReplyMessage":
                                      selectedText != null ? true : false,
                                  "repliedMessage": selectedText
                                });

                                ///  Person Contact
                                FirebaseFirestore.instance
                                    .collection("chats")
                                    .doc(widget.info["number"])
                                    .collection("personalChats")
                                    .doc(SharedPreferencesKeys.prefs!.getString(
                                        SharedPreferencesKeys.mobileNumber))
                                    .collection("privateChat")
                                    .add({
                                  "time": DateTime.now(),
                                  "isSentByMe": false,
                                  "message": '',
                                  'voice': urlVoice,
                                  "status": status ? 'deliver' : "sent",
                                  "sentTime": DateTime.now(),
                                  "deliverTime": status ? DateTime.now() : null,
                                  "seenTime": seenStatus.data()!['isSeen']
                                      ? DateTime.now()
                                      : null,
                                  "isReplyMessage":
                                      selectedText != null ? true : false,
                                  "repliedMessage": selectedText,
                                });

                                sendPushNotification(
                                    number: widget.info["number"],
                                    body: 'Voice Message');

                                selectedText = null;

                                setState(() {
                                  isSelectedText = false;
                                });
                              } else {
                                if (await record.hasPermission()) {
                                  setState(() {
                                    colorsIconVoice = Colors.redAccent;
                                  });
                                  Directory tempDir =
                                      await getTemporaryDirectory();
                                  String tempPath = tempDir.path;
                                  currentAudioPath =
                                      '$tempPath/${DateTime.now().millisecondsSinceEpoch}';
                                  // Start recording
                                  // await record.start(
                                  //   path: currentAudioPath,
                                  //   encoder: AudioEncoder.aacLc, // by default
                                  //   bitRate: 128000, // by default
                                  // );
                                }
                              }
                            },
                            icon: Icon(Icons.mic, color: colorsIconVoice)),
                  )),
            ],
          ),
          // show ? emojiSelect() : Container(),
        ],
      ),
    );
  }

  dateFetch(date) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text("January 23, 2022"),
    );
  }

  checkStatusOnline() {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.info['number'])
        .snapshots()
        .listen((event) {
      setState(() {
        status = event.get("statusOnline");
        lastSeen = event.get("lastSeen");
      });
    });
  }

  /// POP UP Handler
  void handleClick(String value) {
    switch (value) {
      case 'info':
        break;
    }
  }

  deleteMessage(BuildContext context, midList) {
    TextButton(
      child: const Text("Remind me later"),
      onPressed: () {},
    );
    Widget cancelButton = TextButton(
      child: const Text(
        "CANCEL",
        style: TextStyle(color: primaryColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget launchButton = TextButton(
      child: const Text(
        "DELETE FOR ME",
        style: TextStyle(color: primaryColor),
      ),
      onPressed: () {
        for (var mid in selectedMessages!) {
          // mid.isSelected = !mid.isSelected;

          if (mid.isSelected) {
            firebaseInstance
                .doc(widget.info['number'])
                .collection('privateChat')
                .doc(mid.data)
                .delete();
          }
        }
        selectedMessages!.clear();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Message"),
      content: Text("Delete Message from ${widget.info['name']}?"),
      actions: [
        // remindButton,
        cancelButton,
        launchButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    selectedMessages = [];
    checkStatusOnline();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        FirebaseFirestore.instance
            .collection("chats")
            .doc("${widget.info["number"]}")
            .collection("personalChats")
            .doc(SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.mobileNumber))
            .update({
          "isSeen": false,
        });
        if (show) {
          setState(() {
            show = false;
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFECE5DD),
        appBar: isAnySelected
            ? AppBar(
                backgroundColor: primaryColor,
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        selectedMessages!.clear();
                        isAnySelected = false;
                      });
                    },
                    icon: const Icon(Icons.arrow_back_sharp)),

                // centerTitle: false,
                actions: [
                  IconButton(
                      onPressed: () {
                        deleteMessage(context, midList);
                      },
                      icon: const Icon(Icons.delete)),
                ],
              )
            : AppBar(
                backgroundColor: primaryColor,
                leading: IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("chats")
                          .doc("${widget.info["number"]}")
                          .collection("personalChats")
                          .doc(SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.mobileNumber))
                          .update({
                        "isSeen": false,
                      });

                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_sharp)),
                title: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FittedBox(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.info['name'],
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  margin: const EdgeInsets.only(
                                      right: 5, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          status ? Colors.green : Colors.red),
                                ),
                                Text(
                                  status
                                      ? 'Online'
                                      : lastSeen == null
                                          ? 'offline'
                                          : DateFormat('d MMM,')
                                              .add_jm()
                                              .format(lastSeen.toDate()),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
                // centerTitle: false,
                actions: <Widget>[
                  PopupMenuButton(
                    onSelected: handleClick,
                    itemBuilder: (BuildContext context) {
                      return {'info'}.map((String choice) {
                        return PopupMenuItem(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
        body: StreamBuilder(
            stream: firebaseInstance
                .doc(widget.info['number'])
                .collection("privateChat")
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot? data = snapshot.data;
                selectedMessages!.clear();
                if (selectedMessages!.isEmpty) {
                  for (int i = 0; i < data!.docs.length; i++) {
                    selectedMessages!
                        .add(SelectedMessages<String>(data.docs[i].id));
                  }
                }
                return Column(
                  children: [
                    Flexible(
                      child: data!.docs.isEmpty
                          ? const Center(
                              child: Text("No Chat Found"),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: data.docs.length,
                              itemBuilder: (ctx, index) {
                                return GestureDetector(
                                    onTap: () {
                                      if (selectedMessages!
                                          .any((item) => item.isSelected)) {
                                        setState(() {
                                          selectedMessages![index].isSelected =
                                              !selectedMessages![index]
                                                  .isSelected;
                                        });
                                      }
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        selectedMessages![index].isSelected =
                                            true;
                                        isAnySelected = true;
                                      });
                                    },
                                    child: Container(
                                        color: selectedMessages!.isEmpty
                                            ? Colors.transparent
                                            : selectedMessages![index]
                                                    .isSelected
                                                ? Colors.blue[100]
                                                : Colors.transparent,
                                        child: RenderMsg(
                                          queryData: data.docs[index],
                                        )));
                              }),
                    ),
                    // Divider(),
                    Container(
                      child: renderTextBox(context),
                    ),
                  ],
                );
              }

              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }),
      ),
    );
  }
}
