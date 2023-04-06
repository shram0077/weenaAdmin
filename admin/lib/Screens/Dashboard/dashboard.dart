import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Dashboard/infoCard.dart';
import 'package:admin/Screens/Movies/moviePage.dart';
import 'package:admin/Screens/Upload/upload.dart';
import 'package:admin/Screens/Users/UserProfile.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/PostCard.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class Dashboard extends StatefulWidget {
  static const String id = 'dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<QuerySnapshot>? _posts;

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

  bool isExpanded = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  final _searchController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(60.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //let's add the navigation menu for this project
                    StreamBuilder(
                        stream:
                            usersRef.doc(_auth.currentUser!.uid).snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                          UserModell userModel =
                              UserModell.fromDoc(snapshot.data);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.push(
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
                                          profilePicture:
                                              userModel.profilePicture,
                                          username: userModel.username,
                                          verification: userModel.verification,
                                          visitedUserId: userModel.id,
                                        ))),
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
                                            color: const Color.fromARGB(
                                                    255, 78, 89, 123)
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
                                          imageUrl: MyEncriptionDecription
                                              .decryptWithAESKey(
                                                  userModel.profilePicture),
                                          fit: BoxFit.cover,
                                          width: 45,
                                          height: 45,
                                        ),
                                      ),
                                    )),
                              ),
                              Text(
                                MyEncriptionDecription.decryptWithAESKey(
                                    userModel.email),
                                style: GoogleFonts.barlow(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          );
                        }),

                    SizedBox(
                      height: 20.0,
                    ),
                    //Now let's start with the dashboard main rapports
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.person_3_fill,
                                        size: 28.0,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        "Users",
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "$_userCount Users",
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.film,
                                        size: 26.0,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        "Movies",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "$_moviesCount Movies",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        size: 26.0,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        "Creators",
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "3 Creators",
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.admin_panel_settings_outlined,
                                        size: 26.0,
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        "Admins",
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "2",
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Now let's set the article section
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "$_moviesCount Movies",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "in New Movies collection",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Container(
                          width: 300.0,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) {
                              if (v.isNotEmpty) {
                                setState(() {
                                  _posts = DatabaseServices.searchPosts(
                                    v,
                                  );
                                  _posts;
                                });
                              } else {
                                setState(() {
                                  _posts == null;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                  icon: Icon(Icons.close)),
                              hintText: "Type Movie Title",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    _posts == null
                        ? SizedBox()
                        : Center(
                            child: FutureBuilder(
                                future: _posts,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.data.docs.length == 0) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('No Movies found!',
                                              style: GoogleFonts.alef(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: circularProgressIndicator(),
                                    );
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        PostModel postModel = PostModel.fromDoc(
                                            snapshot.data.docs[index]);
                                        return buildPostCard(postModel);
                                      });
                                }),
                          ),

                    SizedBox(
                      height: 25.0,
                    ),

                    //let's set the filter section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.time,
                            color: Colors.grey.shade500,
                          ),
                          label: Text(
                            "access time: ${DateTime.now().toString()}",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    //Now let's add the mos papulare
                    Row(
                      children: [
                        Text(
                          'Most Papulare',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      //let's add the floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Upload())),
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
        backgroundColor: moviePageColor,
      ),
    );
  }

  buildPostCard(PostModel postModel) {
    return StreamBuilder(
        stream: usersRef.doc(postModel.userId).snapshots(),
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  decoration: BoxDecoration(
                      color: moviePageColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    subtitle: Flexible(
                      child: Text(
                        postModel.description,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.barlow(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 220, 220, 220)),
                      ),
                    ),
                    trailing: Text(
                      postModel.userId == _auth.currentUser!.uid
                          ? "Me"
                          : "by ${userModel.username}",
                      style: GoogleFonts.barlow(
                          color: whiteColor.withOpacity(0.9),
                          fontWeight: FontWeight.bold),
                    ),
                    leading: Container(
                      padding: EdgeInsets.all(2),
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        color: profileBGcolor,
                        borderRadius: BorderRadius.circular(3),
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: [
                          const BoxShadow(
                            color: appcolor,
                            spreadRadius: 0.1,
                            blurRadius: 0.1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: CachedNetworkImage(
                          imageUrl: postModel.thumbnail,
                          fit: BoxFit.cover,
                          width: 130,
                          height: 130,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          postModel.title,
                          style: GoogleFonts.barlow(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: whiteColor),
                        ),
                        postModel.verified
                            ? const Icon(
                                CupertinoIcons.star_circle,
                                size: 16,
                                color: appcolor,
                              )
                            : const SizedBox()
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: MoviePage(
                                postModel: postModel,
                              )));
                    },
                  ),
                ),
              ),
            ],
          );
        });
  }
}
