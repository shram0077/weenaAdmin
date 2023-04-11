import 'package:admin/Constant/constant.dart';
import 'package:admin/Screens/Dashboard/dashboard.dart';
import 'package:admin/Screens/Login/login.dart';
import 'package:admin/Screens/Post/Dramas/dramas.dart';
import 'package:admin/Screens/Post/Explorer/explorer.dart';
import 'package:admin/Screens/Post/NewMovies/newMovies.dart';
import 'package:admin/Screens/Post/Reccomends/Reccomends.dart';
import 'package:admin/Screens/Reports/reports.dart';
import 'package:admin/Screens/Upload/upload.dart';
import 'package:admin/Screens/Users/users.dart';
import 'package:admin/Services/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  static const String id = 'home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _selectedScreen = Dashboard();
  currentScreen(items) {
    switch (items.route) {
      case Dashboard.id:
        setState(() {
          _selectedScreen = Dashboard();
        });
        break;
      case Users.id:
        setState(() {
          _selectedScreen = Users();
        });
        break;
      case Reccomends.id:
        setState(() {
          _selectedScreen = Reccomends();
        });
        break;
      case Dramas.id:
        setState(() {
          _selectedScreen = Dramas();
        });
        break;
      case NewMovies.id:
        setState(() {
          _selectedScreen = NewMovies();
        });
        break;
      case Dramas.id:
        setState(() {
          _selectedScreen = Dramas();
        });
        break;
      case Explorer.id:
        setState(() {
          _selectedScreen = Explorer();
        });
        break;
      case Reports.id:
        setState(() {
          _selectedScreen = Reports();
        });
        break;
    }
  }

  bool? isAdmin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AuthService.getScreenId();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          actions: [
            Padding(
              padding: EdgeInsets.all(5),
              child: uploadButton(),
            )
          ],
        ),
        sideBar: SideBar(
          backgroundColor: appBarColor,
          activeBackgroundColor: moviePageColor,
          activeIconColor: whiteColor,
          activeTextStyle: const TextStyle(color: whiteColor),
          items: const [
            AdminMenuItem(
              title: 'Dashboard',
              route: Dashboard.id,
              icon: Icons.dashboard,
            ),
            AdminMenuItem(
              title: 'Users',
              route: Users.id,
              icon: Icons.person_3,
            ),
            AdminMenuItem(
              title: 'Reccomended',
              route: Reccomends.id,
              icon: Icons.recommend,
            ),
            AdminMenuItem(
              title: 'NewMovies',
              route: NewMovies.id,
              icon: Icons.new_label,
            ),
            AdminMenuItem(
              title: 'Dramas',
              route: Dramas.id,
              icon: Icons.video_collection,
            ),
            AdminMenuItem(
              title: 'Explorer',
              route: Explorer.id,
              icon: Icons.explore,
            ),
            AdminMenuItem(
                title: 'Reports', route: Reports.id, icon: Icons.report)
          ],
          selectedRoute: Home.id,
          iconColor: whiteColor,
          onSelected: (items) {
            currentScreen(items);
          },
          header: Container(
            height: 50,
            width: double.infinity,
            color: moviePageColor.withOpacity(0.6),
            child: const Center(
              child: Text(
                'Items',
                style: TextStyle(
                  color: whiteColor,
                ),
              ),
            ),
          ),
          footer: Container(
              height: 50,
              width: double.infinity,
              color: moviePageColor.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'version: 1.0.0',
                      style:
                          GoogleFonts.oswald(color: Colors.white, fontSize: 14),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            AuthService.logout(context);
                          });
                        },
                        icon: Icon(
                          Icons.logout,
                          color: whiteColor,
                          size: 18,
                        ))
                  ],
                ),
              )),
        ),
        body: _selectedScreen);
  }

  uploadButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Upload()));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: moviePageColor.withOpacity(0.8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Upload',
              style: GoogleFonts.barlow(),
            ),
            SizedBox(
              width: 3,
            ),
            Icon(
              CupertinoIcons.cloud_upload,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
