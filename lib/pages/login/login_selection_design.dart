import 'dart:io';

import 'package:com/config/screen_config.dart';
import 'package:com/pages/login/create_account_and_login_code_provider.dart';
import 'package:com/pages/login/firebase_auth_provider.dart';
import 'package:com/pages/login/passwordlogin_design.dart';
import 'package:com/pages/login/select_country%20_page__design.dart';
import 'package:com/pages/material/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import 'create_account_design.dart';
import 'gmaillogin_design.dart';
import 'numberlogin_design.dart';

class LoginSelection extends StatefulWidget {
  @override
  State<LoginSelection> createState() => _LoginSelectionState();
}

class _LoginSelectionState extends State<LoginSelection> {
  bool check = false;
  var loginBtnColor = Colors.black54;
  var createBtnColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    ScreenConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * .07,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * .02, right: width * .02, top: height * .02),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/easysoft_logo.jpg'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              InkWell(
                onLongPress: () {
                  Navigator.pushNamed(context, '/home_page');
                },
                onTap: () async {},
                child: Text(
                  "Login By:",
                  style: TextStyle(
                    color: Color(0xffbec64f),
                    fontSize: height * .04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: check,
                        onChanged: (value) {
                          setState(() {
                            check = value!;
                            if (check) {
                              loginBtnColor = Colors.black;
                            } else {
                              loginBtnColor = Colors.black54;
                            }
                          });
                        }),
                    TextButton(
                        onPressed: () async {
                          Uri uri = Uri.parse(
                              'https://easysoftapp.com/PrivacyPolicy/PrivacyPolicies.htm');
                          await launchUrl(uri);
                        },
                        child: Text('Privacy Policy'))
                  ],
                ),
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                      backgroundColor: loginBtnColor,
                      foregroundColor: Colors.white,
                      elevation: 8),
                  onPressed: () {
                    if (!kIsWeb && !Platform.isWindows) {
                      if (check) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return GmailLogin();
                            });
                      } else {
                        policyCheck(context);
                      }
                    } else {
                      noAvailableFeature(context);
                    }
                  },
                  icon: Icon(Icons.email),
                  label: Text(
                    'Gmail',
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                height: height * .03,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    backgroundColor: loginBtnColor,
                    foregroundColor: Colors.white,
                    elevation: 8),
                onPressed: () {
                  if (check) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Center(child: PasswordLogin()),
                          );
                        });
                  } else {
                    policyCheck(context);
                  }
                },
                icon: Icon(Icons.vpn_key),
                label: Text(
                  'Password',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                      backgroundColor: loginBtnColor,
                      foregroundColor: Colors.white,
                      elevation: 8),
                  onPressed: () async {
                    if (!kIsWeb && !Platform.isWindows) {
                      if (check) {
                        await showDialog<List>(
                          context: (context),
                          builder: (context) => NumberLogin(),
                        );
                      } else {
                        policyCheck(context);
                      }
                    } else {
                      noAvailableFeature(context);
                    }
                  },
                  icon: Icon(Icons.phone),
                  label: Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                height: height * .03,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    backgroundColor: Color(0xffbec64f),
                    foregroundColor: Colors.white,
                    elevation: 12),
                onPressed: () async {
                  if (!kIsWeb && !Platform.isWindows) {
                    if (check) {
                      showDialog<int>(
                        context: (context),
                        builder: (context) => Center(
                          child: SizedBox(
                            height: 150,
                            width: 300,
                            child: SelectCountryPage(),
                          ),
                        ),
                      ).then(
                        (countryClientId) {
                          Provider.of<FirebaseAuthProvider>(context,
                                  listen: false)
                              .signinWithEmail()
                              .then(
                            (UserCredential? userCredential) {
                              print(
                                  '......................................$userCredential');
                              if (userCredential!.user!.email != null) {
                                Provider.of<AuthenticationProvider>(context,
                                        listen: false)
                                    .checkEmailWithServer(
                                  userCredential.user!.email!,
                                  countryClientId!,
                                  context,
                                )
                                    .then(
                                  (value) {
                                    if (value == 1) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Center(
                                              child: SizedBox(
                                                height: 150,
                                                width: 300,
                                                child: Material(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            'Your Email is Already Exist. Would you like to login to this Account'),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  SharedPreferencesKeys
                                                                      .prefs!
                                                                      .setInt(
                                                                          SharedPreferencesKeys
                                                                              .projectId,
                                                                          0);
                                                                  Provider.of<FirebaseAuthProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .signinWithEmail()
                                                                      .then(
                                                                    (UserCredential?
                                                                        userCredential) {
                                                                      if (userCredential!
                                                                              .user!
                                                                              .email !=
                                                                          null) {
                                                                        Provider.of<AuthenticationProvider>(context, listen: false).loginWithMobileNoOrEmailWithServer(
                                                                            userCredential
                                                                                .user!.email!,
                                                                            countryClientId,
                                                                            userCredential:
                                                                                userCredential,
                                                                            "AcEmailAddress",
                                                                            context);
                                                                      }
                                                                    },
                                                                  );
                                                                },
                                                                child: Text(
                                                                    'Login')),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          8.0),
                                                              child:
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          'Cancel')),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                      Toast.buildErrorSnackBar(
                                          'Email already exist');
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return WillPopScope(
                                              onWillPop: () async {
                                                return false;
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: Center(
                                                  child: SizedBox(
                                                    height: 450,
                                                    child: CreateAccount(
                                                      userCredential:
                                                          userCredential,
                                                      countryUserId:
                                                          countryClientId,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  },
                                );
                              }
                            },
                          );
                        },
                      );
                    } else {
                      policyCheck(context);
                    }
                  } else {
                    noAvailableFeature(context);
                  }
                },
                icon: Icon(Icons.account_box),
                label: Text(
                  'Create Account',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

policyCheck(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text('Please check our privacy policy to proceed'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'))
      ],
    ),
  );
}
