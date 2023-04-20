import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/ReportModel.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class Reports extends StatefulWidget {
  static const String id = 'reports';

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<ReportModel> _allReports = [];
  getReports() async {
    List<ReportModel> userPosts = await DatabaseServices.getReports();
    if (mounted) {
      setState(() {
        _allReports = userPosts;
        print("Count of Reports: ${_allReports.length}");
      });
      // ignore: avoid_print
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReports();
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
        body: FutureBuilder(
            future: movieReportsRef.get(),
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
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Text(
                    snapshot.data.docs[index]['messageReport'],
                    style: GoogleFonts.barlow(color: Colors.black),
                  );
                },
              );
            }));
  }
}
