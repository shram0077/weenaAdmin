import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Dashboard/infoCard.dart';
import 'package:admin/Services/Database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  static const String id = 'dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _userCount = 0;
  int _moviesCount = 0;
  int _verifedUser = 3;
  getUsersCount() async {
    int count = await DatabaseServices.getUsersCount();
    if (mounted) {
      setState(() {
        _userCount = count;
        print(count);
      });
    }
  }

  getMoviesCount() async {
    int count = await DatabaseServices.getUsersCount();
    if (mounted) {
      setState(() {
        _moviesCount = count;
        print(count);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsersCount();
    getMoviesCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 6, bottom: 5),
                  child: Text(
                    "Dashboard",
                    style: GoogleFonts.barlow(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
            ],
          ),
          Expanded(
              child: ListView(
            children: [
              Row(
                children: [
                  InfoCard(
                    title: 'Users',
                    value: _userCount.toString(),
                    topColor: Colors.green,
                    icon: CupertinoIcons.person_3,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InfoCard(
                    title: 'Movies',
                    value: _moviesCount.toString(),
                    topColor: moviePageColor,
                    icon: CupertinoIcons.play,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const InfoCard(
                    title: 'Verifed Users',
                    value: '15',
                    topColor: verifiedColor,
                    icon: CupertinoIcons.check_mark,
                  ),
                ],
              )
            ],
          ))
        ],
      ),
    ));
  }
}
