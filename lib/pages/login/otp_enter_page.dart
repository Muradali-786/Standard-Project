import 'dart:async';
import 'package:flutter/material.dart';
import '../../main/tab_bar_pages/home/Dashboard.dart';

class OtpEnterPage extends StatefulWidget {
  final String? countryClientID, countryUserID;

 const OtpEnterPage({Key? key, this.countryUserID, this.countryClientID})
      : super(key: key);

  @override
  _OtpEnterPageState createState() => _OtpEnterPageState();
}

class _OtpEnterPageState extends State<OtpEnterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController smsController = TextEditingController();
  int count = 150;
  bool check = true;

  /// declare a timer
  Timer? timer;

  @override
  void initState() {
    super.initState();

    //smsController.text =  widget.code!;
    if (count >= 0) {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          /// callback will be executed every 1 second, increament a count value
          /// on each callbac

          if (count == 0) {
            if (check) {
              // SharedPreferencesKeys.prefs!.setString(
              //     SharedPreferencesKeys.countryClientId,
              //     widget.countryClientID!);
              // SharedPreferencesKeys.prefs!.setString(
              //     SharedPreferencesKeys.countryUserId, widget.countryUserID!);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListWidget()));
              check = false;
            }
          } else {
            setState(() {
              count--;
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 30),
                child: Container(
                  height: 50,
                  child: TextFormField(
                    controller: smsController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.message),
                        hintText: "Code",
                        labelText: "Code",
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.green,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                width: 20,
                                style: BorderStyle.solid))),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(count.toString()),
                  ElevatedButton(
                      onPressed: () {
                        if (smsController.text.isNotEmpty) {
                          Navigator.pop(context, smsController.text);
                        }
                      },
                      child: Text("Confirm")),
                ],
              )
            ],
          )),
    );
  }
}
