import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';

class RenderMsg extends StatefulWidget {
  final QueryDocumentSnapshot queryData;

  const RenderMsg({Key? key, required this.queryData}) : super(key: key);

  @override
  State<RenderMsg> createState() => _RenderMsgState();
}

class _RenderMsgState extends State<RenderMsg> {
  // final record = Record();
  AudioPlayer? player;
  bool isPlaying = false;
  IconData playStopIcon = Icons.play_arrow;
  Duration durationAudio = Duration.zero;
  Duration positionAudio = Duration.zero;
  bool isSelectedtext = false;
  var selectedText;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key("${widget.queryData}"),
      dragStartBehavior: DragStartBehavior.start,
      confirmDismiss: (a) async {
        if (a == DismissDirection.startToEnd) {
          selectedText = widget.queryData.get('message');
          setState(() {
            isSelectedtext = true;
          });
        }
        return null;
      },
      onDismissed: (direction) {
        print(direction);
      },
      secondaryBackground: Container(color: Colors.red[100]),
      background: Container(color: Colors.transparent),
      child: Align(
        alignment: widget.queryData.get('isSentByMe')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: widget.queryData.get('isSentByMe') ? 2 : 7,
          ),
          decoration: BoxDecoration(
            color: widget.queryData.get('isSentByMe')
                ? const Color(0xFFDCF8C6)
                : Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
                color: Color(0x22000000),
                offset: Offset(1, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !widget.queryData.get("isReplyMessage")
                  ? Container(
                      width: 0,
                    )
                  : Container(
                      height: 50,
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
                                // width: MediaQuery.of(context).size.width - 76,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        ],
                                      ),
                                      Text(
                                        widget.queryData.get("repliedMessage"),
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
              Padding(
                  padding: EdgeInsets.only(
                      left: 5,
                      right: widget.queryData.get('isSentByMe') ? 20 : 10),
                  child: widget.queryData.get('message').toString() != ''
                      ? Text(
                          widget.queryData.get('message'),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        )
                      : widget.queryData.get('voice').toString() != ''
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: IconButton(
                                      onPressed: () async {
                                        player = AudioPlayer(
                                            playerId:
                                                widget.queryData.get('voice'));
                                        player!.onPlayerComplete
                                            .listen((event) {
                                          if (mounted) {
                                            setState(() {
                                              playStopIcon = Icons.play_arrow;
                                              isPlaying = false;
                                            });
                                          }
                                        });

                                        player!.onDurationChanged
                                            .listen((value) {
                                          if (mounted) {
                                            setState(() {
                                              durationAudio = value;
                                            });
                                          }
                                        });

                                        player!.onPositionChanged
                                            .listen((event) {
                                          if (mounted) {
                                            setState(() {
                                              positionAudio = event;
                                            });
                                          }
                                        });
                                        File file = await DefaultCacheManager()
                                            .getSingleFile(
                                                widget.queryData.get('voice'));
                                        setState(() {
                                          if (isPlaying) {
                                            player!.pause();
                                            isPlaying = false;
                                            playStopIcon = Icons.play_arrow;
                                          } else {
                                            player!.play(
                                                DeviceFileSource(file.path));
                                            isPlaying = true;
                                            playStopIcon = Icons.pause;
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        playStopIcon,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 8,
                                    child: ProgressBar(
                                      progress: positionAudio,
                                      total: durationAudio,
                                      onSeek: (duration) {
                                        print(
                                            'User selected a new time: $duration');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : widget.queryData.get('image').toString() != ''
                              ? CachedNetworkImage(
                                  imageUrl: widget.queryData.get('image'),
                                  height: 200,
                                  width: 200,
                                  alignment: Alignment.center,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/easysoft_logo.jpg',
                                    alignment: Alignment.center,
                                    height: 50,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    var file = await DefaultCacheManager()
                                        .getSingleFile(
                                            widget.queryData.get('doc'));

                                    // OpenFilex.open(file.path);
                                  },
                                  child: Icon(
                                    CupertinoIcons.doc_plaintext,
                                    size: 150,
                                    color: Colors.red,
                                  ))),
              Container(
                padding: const EdgeInsets.only(
                  left: 5,
                ),
                // alignment: Alignment.bottomRight,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('jm')
                          .format(widget.queryData.get('time').toDate()),
                      style: const TextStyle(fontSize: 10),
                    ),
                    widget.queryData.get('isSentByMe')
                        ? SizedBox(
                            height: 20,
                            // color: Colors.amber,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 15,
                                  color:
                                      widget.queryData.get("seenTime") == null
                                          ? Colors.grey
                                          : (widget.queryData.get("status") ==
                                                  'deliver')
                                              ? Colors.blue
                                              : Colors.grey,
                                ),
                                widget.queryData.get("status") == 'deliver'
                                    ? Positioned(
                                        top: 3,
                                        child: Icon(
                                          Icons.check,
                                          size: 15,
                                          color: widget.queryData
                                                      .get("seenTime") ==
                                                  null
                                              ? Colors.grey
                                              : (widget.queryData
                                                          .get("status") ==
                                                      'deliver')
                                                  ? Colors.blue
                                                  : Colors.grey,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
