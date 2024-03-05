import 'package:com/pages/login/otp_enter_page.dart';
import 'package:com/pages/material/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../../widgets/constants.dart';
import 'create_account_and_login_code_provider.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  /////////////////////////////////////////
  //send request for otp to firebase server
  ////////////////////////////////////////
  sentRequestForOtp(String number, BuildContext context,
      {int? countryClientId, String? countryUserID, String? status}) async {
    print(number);
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 30),
        verificationFailed: (FirebaseAuthException error) {
          Toast.buildErrorSnackBar(error.toString());
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code

          Constants.hideDialog(context);
          final smsCode = await showDialog<String>(
            context: (context),
            builder: (context) => OtpEnterPage(
                countryUserID: countryUserID,
                countryClientID: countryClientId.toString()),
          );
          // print(verificationId);
          // print(resendToken)
          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode.toString());

          // Sign the user in (or link) with the credential
          try {
            print(
                'sign in with number to firebse .................................');
            await auth
                .signInWithCredential(credential)
                .then((UserCredential userCredential) {
              List list = [userCredential.user!.phoneNumber, countryClientId];
              if (countryClientId != null) {
                // Navigator.pop(context, list);
                if (status != 'Update') {
                  Provider.of<AuthenticationProvider>(context, listen: false)
                      .loginWithMobileNoOrEmailWithServer(
                          list[0], list[1], 'AcMobileNo', context,
                          userCredential: userCredential);
                } else {
                  print(
                      '........................................update to server .........................');
                  Provider.of<AuthenticationProvider>(context, listen: false)
                      .updateMobileNumberWithServer(
                          userCredential.user!.phoneNumber!,
                          SharedPreferencesKeys.prefs!.getString(
                              SharedPreferencesKeys.countryClientId)!,
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.countryUserId)!,
                          context,
                          'loginPage');
                }
              } else {
                Navigator.pop(context, userCredential.user!.phoneNumber);
              }
            });
          } on FirebaseAuthException catch (e) {
            Toast.buildErrorSnackBar(e.toString());
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        },
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          print(
              'conpelte verfiacation........................................');
          print('verification completed');
          print(phoneAuthCredential.smsCode);
          // Navigator.pop(context, number);
        },
      );
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      Toast.buildErrorSnackBar(e.toString());
    }
  }

  /////////////////////////////////
  //Firebase Email Choooser
  ////////////////////////////////
  Future<UserCredential?> signinWithEmail() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('...............$credential');

      // Once signed in, return the UserCredential
      return await auth.signInWithCredential(credential);
    } on PlatformException catch (e) {
      print("google sign in error");

      print('${e.message}..............................................');
      print(e.details);
    }
    return null;
  }
}
