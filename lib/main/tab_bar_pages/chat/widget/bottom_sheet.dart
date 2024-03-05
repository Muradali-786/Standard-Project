import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/main/tab_bar_pages/chat/Controller/service_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../pages/material/image_uploading.dart';
import '../../../../shared_preferences/shared_preference_keys.dart';
import '../screen/show_all_contact_to_select.dart';

class BottomSheetView extends StatefulWidget {
  final String number;
  final bool? selectedText;
  final bool status;

  const BottomSheetView(
      {Key? key,
      required this.number,
      required this.status,
      required this.selectedText})
      : super(key: key);

  @override
  State<BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      var seenStatus = await FirebaseFirestore.instance
                          .collection("chats")
                          .doc(SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.mobileNumber))
                          .collection("personalChats")
                          .doc("${widget.number}")
                          .get();

                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              allowedExtensions: ['doc', 'pdf', 'excel'],
                              type: FileType.custom);
                      if (result != null) {
                        Navigator.pop(context);
                        File file = File(result.files.single.path!);
                        var urlDoc = '';
                        try {
                          var upload = await storageRef
                              .child('Data/doc')
                              .child('${DateTime.now().millisecondsSinceEpoch}')
                              .putFile(file);
                          var snap = await upload;
                          urlDoc = await snap.ref.getDownloadURL();

                          print(urlDoc);
                        } on FirebaseException catch (e) {
                          print(e);
                        }

                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("personalChats")
                            .doc(widget.number)
                            .collection("privateChat")
                            .add({
                          "time": DateTime.now(),
                          "isSentByMe": true,
                          "message": '',
                          'voice': '',
                          'image': '',
                          'doc': urlDoc,
                          "status": widget.status ? 'deliver' : "sent",
                          "sentTime": DateTime.now(),
                          "deliverTime": widget.status ? DateTime.now() : null,
                          "seenTime": seenStatus.data()!['isSeen']
                              ? DateTime.now()
                              : null,
                          "isReplyMessage":
                              widget.selectedText != null ? true : false,
                          "repliedMessage": widget.selectedText
                        });

                        ///  Person Contact
                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc(widget.number)
                            .collection("personalChats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("privateChat")
                            .add({
                          "time": DateTime.now(),
                          "isSentByMe": false,
                          "message": '',
                          'voice': '',
                          'image': '',
                          'doc': urlDoc,
                          "status": widget.status ? 'deliver' : "sent",
                          "sentTime": DateTime.now(),
                          "deliverTime": widget.status ? DateTime.now() : null,
                          "seenTime": seenStatus.data()!['isSeen']
                              ? DateTime.now()
                              : null,
                          "isReplyMessage":
                              widget.selectedText != null ? true : false,
                          "repliedMessage": widget.selectedText,
                          // "number" : isSentByMe ? widget.info['number'] :GlobalState.myNumber,
                        });

                        sendPushNotification(
                            number: widget.number, body: 'Document');
                      }
                    },
                    child: iconCreation(
                        Icons.insert_drive_file, Colors.indigo, "Document"),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  InkWell(
                      onTap: () async {
                        print(
                            '.................................................................');

                        var seenStatus = await FirebaseFirestore.instance
                            .collection("chats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("personalChats")
                            .doc("${widget.number}")
                            .get();

                        File ImageFile = await pickImageFromMedia(
                            ImageSource.camera,
                            imageFor: 'ImageChat');

                        Navigator.pop(context);

                        var urlImage = '';
                        try {
                          var upload = await storageRef
                              .child('Data/image')
                              .child('${DateTime.now().millisecondsSinceEpoch}')
                              .putFile(ImageFile);
                          var snap = await upload;

                          urlImage = await snap.ref.getDownloadURL();

                          print(urlImage);
                        } on FirebaseException catch (e) {
                          print(e);
                        }

                        print(
                            '............$urlImage.......${seenStatus.data()!['isSeen']}');

                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("personalChats")
                            .doc(widget.number)
                            .collection("privateChat")
                            .add({
                          "time": DateTime.now(),
                          "isSentByMe": true,
                          "message": '',
                          'voice': '',
                          'image': urlImage,
                          "status": widget.status ? 'deliver' : "sent",
                          "sentTime": DateTime.now(),
                          "deliverTime": widget.status ? DateTime.now() : null,
                          "seenTime": seenStatus.data()!['isSeen']
                              ? DateTime.now()
                              : null,
                          "isReplyMessage":
                              widget.selectedText != null ? true : false,
                          "repliedMessage": widget.selectedText
                        });

                        ///  Person Contact
                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc(widget.number)
                            .collection("personalChats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("privateChat")
                            .add({
                          "time": DateTime.now(),
                          "isSentByMe": false,
                          "message": '',
                          'voice': '',
                          'image': urlImage,
                          "status": widget.status ? 'deliver' : "sent",
                          "sentTime": DateTime.now(),
                          "deliverTime": widget.status ? DateTime.now() : null,
                          "seenTime": seenStatus.data()!['isSeen']
                              ? DateTime.now()
                              : null,
                          "isReplyMessage":
                              widget.selectedText != null ? true : false,
                          "repliedMessage": widget.selectedText,
                          // "number" : isSentByMe ? widget.info['number'] :GlobalState.myNumber,
                        });

                        sendPushNotification(
                            number: widget.number, body: 'Photo');
                      },
                      child: iconCreation(
                          Icons.camera_alt, Colors.pink, "Camera")),
                  const SizedBox(
                    width: 40,
                  ),
                  InkWell(
                      onTap: () async {
                        print(
                            '.................................................................');

                        var seenStatus = await FirebaseFirestore.instance
                            .collection("chats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("personalChats")
                            .doc("${widget.number}")
                            .get();

                        File ImageFile = await pickImageFromMedia(
                            ImageSource.gallery,
                            imageFor: 'ImageChat');

                        Navigator.pop(context);
                        var urlImage = '';
                        try {
                          var upload = await storageRef
                              .child('Data/image')
                              .child('${DateTime.now().millisecondsSinceEpoch}')
                              .putFile(ImageFile);
                          var snap = await upload;

                          urlImage = await snap.ref.getDownloadURL();

                          print(urlImage);
                        } on FirebaseException catch (e) {
                          print(e);
                        }

                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("personalChats")
                            .doc(widget.number)
                            .collection("privateChat")
                            .add({
                          "time": DateTime.now(),
                          "isSentByMe": true,
                          "message": '',
                          'voice': '',
                          'image': urlImage,
                          "status": widget.status ? 'deliver' : "sent",
                          "sentTime": DateTime.now(),
                          "deliverTime": widget.status ? DateTime.now() : null,
                          "seenTime": seenStatus.data()!['isSeen']
                              ? DateTime.now()
                              : null,
                          "isReplyMessage":
                              widget.selectedText != null ? true : false,
                          "repliedMessage": widget.selectedText
                        });

                        ///  Person Contact
                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc(widget.number)
                            .collection("personalChats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("privateChat")
                            .add({
                          "time": DateTime.now(),
                          "isSentByMe": false,
                          "message": '',
                          'voice': '',
                          'image': urlImage,
                          "status": widget.status ? 'deliver' : "sent",
                          "sentTime": DateTime.now(),
                          "deliverTime": widget.status ? DateTime.now() : null,
                          "seenTime": seenStatus.data()!['isSeen']
                              ? DateTime.now()
                              : null,
                          "isReplyMessage":
                              widget.selectedText != null ? true : false,
                          "repliedMessage": widget.selectedText,
                          // "number" : isSentByMe ? widget.info['number'] :GlobalState.myNumber,
                        });

                        sendPushNotification(
                            number: widget.number, body: 'Photo');
                      },
                      child: iconCreation(
                          Icons.insert_photo, Colors.purple, "Gallery")),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.audio);
                        if (result != null) {
                          Navigator.pop(context);
                          File file = File(result.files.single.path!);
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

                          var seenStatus = await FirebaseFirestore.instance
                              .collection("chats")
                              .doc(SharedPreferencesKeys.prefs!.getString(
                                  SharedPreferencesKeys.mobileNumber))
                              .collection("personalChats")
                              .doc("${widget.number}")
                              .get();

                          print(
                              '............$urlVoice.......${seenStatus.data()!['isSeen']}');

                          FirebaseFirestore.instance
                              .collection("chats")
                              .doc(SharedPreferencesKeys.prefs!.getString(
                                  SharedPreferencesKeys.mobileNumber))
                              .collection("personalChats")
                              .doc(widget.number)
                              .collection("privateChat")
                              .add({
                            "time": DateTime.now(),
                            "isSentByMe": true,
                            "message": '',
                            'voice': urlVoice,
                            "status": widget.status ? 'deliver' : "sent",
                            "sentTime": DateTime.now(),
                            "deliverTime":
                                widget.status ? DateTime.now() : null,
                            "seenTime": seenStatus.data()!['isSeen']
                                ? DateTime.now()
                                : null,
                            "isReplyMessage":
                                widget.selectedText != null ? true : false,
                            "repliedMessage": widget.selectedText
                          });

                          ///  Person Contact
                          FirebaseFirestore.instance
                              .collection("chats")
                              .doc(widget.number)
                              .collection("personalChats")
                              .doc(SharedPreferencesKeys.prefs!.getString(
                                  SharedPreferencesKeys.mobileNumber))
                              .collection("privateChat")
                              .add({
                            "time": DateTime.now(),
                            "isSentByMe": false,
                            "message": '',
                            'voice': urlVoice,
                            "status": widget.status ? 'deliver' : "sent",
                            "sentTime": DateTime.now(),
                            "deliverTime":
                                widget.status ? DateTime.now() : null,
                            "seenTime": seenStatus.data()!['isSeen']
                                ? DateTime.now()
                                : null,
                            "isReplyMessage":
                                widget.selectedText != null ? true : false,
                            "repliedMessage": widget.selectedText,
                            // "number" : isSentByMe ? widget.info['number'] :GlobalState.myNumber,
                          });

                          sendPushNotification(
                              number: widget.number, body: 'Audio');
                        }
                      },
                      child:
                          iconCreation(Icons.headset, Colors.orange, "Audio")),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  const SizedBox(
                    width: 40,
                  ),
                  InkWell(
                      onTap: () async {
                        var seenStatus = await FirebaseFirestore.instance
                            .collection("chats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("personalChats")
                            .doc("${widget.number}")
                            .get();

                        var numberInfo = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShowAllContact(),
                            ));

                        Navigator.pop(context);
                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("personalChats")
                            .doc(widget.number)
                            .collection("privateChat")
                            .add({
                          "time": DateTime.now(),
                          "isSentByMe": true,
                          "message": '${numberInfo[0]} \n ${numberInfo[1]}',
                          "status": widget.status ? 'deliver' : "sent",
                          "sentTime": DateTime.now(),
                          "deliverTime": widget.status ? DateTime.now() : null,
                          "seenTime": seenStatus.data()!['isSeen']
                              ? DateTime.now()
                              : null,
                          "isReplyMessage":
                              widget.selectedText != null ? true : false,
                          "repliedMessage": widget.selectedText
                        });

                        ///  Person Contact
                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc(widget.number)
                            .collection("personalChats")
                            .doc(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.mobileNumber))
                            .collection("privateChat")
                            .add({
                          "time": DateTime.now(),
                          "isSentByMe": false,
                          "message": '${numberInfo[0]}\n${numberInfo[1]}',
                          "status": widget.status ? 'deliver' : "sent",
                          "sentTime": DateTime.now(),
                          "deliverTime": widget.status ? DateTime.now() : null,
                          "seenTime": seenStatus.data()!['isSeen']
                              ? DateTime.now()
                              : null,
                          "isReplyMessage":
                              widget.selectedText != null ? true : false,
                          "repliedMessage": widget.selectedText,
                        });
                        sendPushNotification(
                            number: widget.number, body: 'Contact');
                        print(numberInfo);
                      },
                      child:
                          iconCreation(Icons.person, Colors.blue, "Contact")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget iconCreation(IconData icons, Color color, String text) {
  return Column(
    children: [
      CircleAvatar(
        radius: 30,
        backgroundColor: color,
        child: Icon(
          icons,
          // semanticLabel: "Help",
          size: 29,
          color: Colors.white,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          // fontWeight: FontWeight.w100,
        ),
      )
    ],
  );
}
