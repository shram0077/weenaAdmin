import 'dart:async';

import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Services/Auth.dart';
import 'package:admin/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: usersRef.doc(_firebaseAuth.currentUser!.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 300.0),
                  child: Center(child: circularProgressIndicator()),
                );
                // ignore: unrelated_type_equality_checks
              } else if (snapshot == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(top: 300.0),
                  child: Center(child: circularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Snapshot Error',
                          style: GoogleFonts.alef(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: errorColor)),
                    ],
                  ),
                );
              }
              UserModell userModel = UserModell.fromDoc(snapshot.data);
              if (!userModel.admin) {
                AuthService.logout();
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Only Admin's can login");
                setState(() {});
              } else {
                Navigator.pushNamed(context, "/home", arguments: userModel);
                setState(() {});
              }
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    circularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Checking your account...',
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }));
  }
}
