import 'package:admin/Constant/constant.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Reports extends StatefulWidget {
  static const String id = 'reports';

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  getReportsID() {
    movieReportsRef.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
        id = doc.id;
      });
    });
  }

  String id = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getReportsID();
  }

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
        body: FutureBuilder<QuerySnapshot>(
          future: movieReportsRef.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: snapshot.data!.docs.map((doc) {
                      // your widget here(use doc data)
                      return streamReports(doc.id);
                    })?.toList() ??
                    [],
              );
            } else {
              // or your loading widget here
              return circularProgressIndicator();
            }
          },
        ));
  }

  Widget streamReports(String postID) {
    return StreamBuilder(
        stream: movieReportsRef
            .doc(postID)
            .collection('Reports')
            .orderBy('Timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
            // ignore: unrelated_type_equality_checks
          } else if (snapshot == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
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
          return ListView(
            shrinkWrap: true,
            children: List.generate(snapshot.data.docs.length, (index) {
              return Text(snapshot.data.docs[index]["messageReport"]);
            }),
          );
        });
  }
}
