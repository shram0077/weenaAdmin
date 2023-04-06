import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Dashboard/dashboard.dart';
import 'package:admin/Screens/Post/Dramas/dramas.dart';
import 'package:admin/Screens/Login/checkUser.dart';
import 'package:admin/Screens/Post/Explorer/explorer.dart';
import 'package:admin/Screens/Post/NewMovies/newMovies.dart';
import 'package:admin/Screens/Post/Reccomends/Reccomends.dart';
import 'package:admin/Screens/Upload/upload.dart';
import 'package:admin/Screens/Users/UserProfile.dart';
import 'package:admin/Screens/Users/users.dart';
import 'package:admin/Services/Auth.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

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
    }
  }

  bool? isAdmin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthService.getScreenId();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
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
          title: StreamBuilder(
              stream: usersRef.doc(_auth.currentUser!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 300.0),
                    child: Center(child: circularProgressIndicator()),
                  );
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

                return Row(
                  children: [
                    Text(
                      'Welcome ${userModel.name}',
                      style: GoogleFonts.barlow(color: whiteColor),
                    ),
                    userModel.verification
                        ? Icon(CupertinoIcons.checkmark_seal_fill,
                            size: 16, color: verifiedColor)
                        : const SizedBox(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.topToBottom,
                                child: UserProfile(
                                  bio: userModel.bio,
                                  cityortown: userModel.cityorTown,
                                  country: userModel.country,
                                  coverPicture: userModel.coverPicture,
                                  displayName: userModel.name,
                                  email: userModel.name,
                                  profilePicture: userModel.profilePicture,
                                  username: userModel.username,
                                  verification: userModel.verification,
                                  visitedUserId: userModel.id,
                                )));
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, top: 8, bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: profileBGcolor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 78, 89, 123)
                                      .withOpacity(0.1),
                                  spreadRadius: 0.2,
                                  blurRadius: 0.2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl:
                                    MyEncriptionDecription.decryptWithAESKey(
                                        userModel.profilePicture),
                                fit: BoxFit.cover,
                                width: 45,
                                height: 45,
                              ),
                            ),
                          )),
                    )
                  ],
                );
              }),
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
                          AuthService.logout();
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
    return GestureDetector(
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
