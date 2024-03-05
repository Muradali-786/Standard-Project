import 'dart:convert';
import 'dart:io';

import 'package:com/config/validator.dart';
import 'package:com/pages/login/create_account_and_login_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:com/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// import 'package:provider/provider.dart';
import '../material/image_uploading.dart';

class CreateAccount extends StatefulWidget {
  final UserCredential userCredential;
  final int countryUserId;

  const CreateAccount(
      {Key? key, required this.userCredential, required this.countryUserId})
      : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  DateTime selectedDate = DateTime.now();
  bool loading = false;
  String status = '';
  String base64Image = "";
  String fileName = "";
  File? _image;
  bool obCheckForPass = true;
  bool obCheckForConPass = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController.text = widget.userCredential.user!.displayName!;
    super.initState();

    if (FirebaseAuth.instance.currentUser!.photoURL != null) {
      convertImageToBase64();
    }
  }

  void convertImageToBase64() async {
    var response =
        await http.get(Uri.parse(FirebaseAuth.instance.currentUser!.photoURL!));
    if (response.statusCode == 200) {
      setState(() {
        base64Image = base64Encode(response.bodyBytes);
        print(base64Image);
      });
    } else {
      print('Failed to load image. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Create Account",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              )),
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Welcome to your Account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              child: Container(
                width: 100,
                height: 100,
                child: (_image == null)
                    ? FirebaseAuth.instance.currentUser!.photoURL != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  FirebaseAuth.instance.currentUser!.photoURL!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                // top: 70,
                                left: 70,
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 25,
                                ),
                              )
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                                color: Colors.blue,
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 45,
                                )),
                          )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
              onTap: () async {
                _image = await imageUploadingToServer(
                    mainContext: context, status: 'Profile');
                base64Image = base64Encode(_image!.readAsBytesSync());
                setState(() {});
              },
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Container(
                      height: 50,
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.supervisor_account),
                          hintText: "Full Name",
                          labelText: "Full Name",
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.green,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Container(
                      height: 50,
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password cannot be empty';
                          } else if (!Validator.validatePassword(value)) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: obCheckForPass,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (obCheckForPass) {
                                      obCheckForPass = false;
                                    } else {
                                      obCheckForPass = true;
                                    }
                                  });
                                },
                                child: Icon(Icons.visibility)),
                            prefixIcon: Icon(Icons.lock_outline),
                            labelText: "Password",
                            hintText: "Password",
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 0),
                    child: Container(
                      height: 50,
                      child: TextFormField(
                        controller: confPasswordController,
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                        obscureText: obCheckForConPass,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (obCheckForConPass) {
                                      obCheckForConPass = false;
                                    } else {
                                      obCheckForConPass = true;
                                    }
                                  });
                                },
                                child: Icon(Icons.visibility)),
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: "Confirm Password",
                            labelText: "Confirm Password",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 40,
                          width: 130,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // background
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ) // foreground
                                  ),
                              onPressed: () async {
                                FirebaseAuth.instance.signOut();
                                GoogleSignIn().signOut();
                                Navigator.pop(context);
                              },
                              child: Text("Cancel")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 40,
                          width: 130,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // background
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ) // foreground
                                  ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Constants.onLoading(
                                      context, 'Please Wait........');
                                  SharedPreferencesKeys.prefs!.setInt(
                                      SharedPreferencesKeys.projectId, 0);
                                  SharedPreferencesKeys.prefs!
                                    ..setString(
                                        SharedPreferencesKeys.countryUserId,
                                        widget.countryUserId.toString())
                                    ..setString(SharedPreferencesKeys.email,
                                        widget.userCredential.user!.email!);
                                  SharedPreferencesKeys.prefs!.setString(
                                      SharedPreferencesKeys.nameOfPerson,
                                      nameController.text.toString());
                                  SharedPreferencesKeys.prefs!.setString(
                                      SharedPreferencesKeys.fromDate,
                                      '2010-01-01');
                                  SharedPreferencesKeys.prefs!.setString(
                                      SharedPreferencesKeys.toDate,
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now())
                                          .toString());

                                  await Provider.of<AuthenticationProvider>(
                                          context,
                                          listen: false)
                                      .uploadImage(base64Image,
                                          widget.countryUserId, context);

                                  Provider.of<AuthenticationProvider>(context,
                                          listen: false)
                                      .createAccountWithServer(
                                    context,
                                    nameController.text,
                                    passwordController.text,
                                    widget.userCredential.user!.email,
                                    base64Image,
                                    widget.countryUserId,
                                  );

                                  Constants.hideDialog(context);

                                  // Navigator.pop(context);
                                } else {
                                  print('form is not valid');
                                }
                              },
                              child: Text("Sign Up")),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
