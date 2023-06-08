import 'package:admin/Constant/constant.dart';

import 'package:admin/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

class Reports extends StatefulWidget {
  static const String id = 'reports';

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Reports',
            style: GoogleFonts.barlow(color: whiteColor),
          ),
        ),
        body: Text('Soon'));
  }
}
