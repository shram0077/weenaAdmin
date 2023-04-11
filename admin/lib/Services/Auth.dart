import 'package:admin/Screens/Login/checkUser.dart';
import 'package:admin/Screens/Login/login.dart';
import 'package:admin/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<bool> login(String email, String password, context) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CheckUser())));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static void logout(ctx) async {
    try {
      _auth.signOut();
      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      Fluttertoast.showToast(msg: "@e");
    }
  }

  static Widget getScreenId() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return Login();
          }
        });
  }
}
