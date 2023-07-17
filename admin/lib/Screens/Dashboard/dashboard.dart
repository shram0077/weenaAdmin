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
    int count = await DatabaseServices.getMoviesCount();
    if (mounted) {
      setState(() {
        _moviesCount = count;

        print(count);
      });
    }
  }

  List<PostModel> _series = [];

  List<PostModel> _newMovies = [];
  bool _resreshing = false;
  getNewovies() async {
    setState(() {
      _resreshing = true;
    });
    List<PostModel> mvs = await DatabaseServices.getNewMovies();
    if (mounted) {
      setState(() {
        _newMovies = mvs.toList();
        _series = mvs.where((element) => element.type == "Series").toList();
        _resreshing = false;
      });
    }
  }

  List<UserModell> _admin = [];
  int adminsCount = 0;
  getAdmins() async {
    List<UserModell> admins = await DatabaseServices.getAdmin();
    if (mounted) {
      setState(() {
        _admin = admins;
        adminsCount = _admin.length;
      });
    }
  }

  int _creatorsCunt = 0;
  List<UserModell> _creators = [];
  getCreatorsCount() async {
    List<UserModell> creators = await DatabaseServices.getCreatorsCount();
    if (mounted) {
      setState(() {
        _creators = creators;
        _creatorsCunt = _creators.length;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsersCount();
    getMoviesCount();
    getNewovies();
    getAdmins();
    getCreatorsCount();
  }

  bool isExpanded = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String orderItems = 'likes';
  @override
  final _searchController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(60.0),
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
                            return const Center(
                                child: LinearProgressIndicator(
                              backgroundColor: whiteColor,
                              color: moviePageColor,
                            ));
                          } else if (snapshot == ConnectionState.waiting) {
                            return const Center(
                                child: LinearProgressIndicator(
                              backgroundColor: whiteColor,
                              color: moviePageColor,
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

                    const SizedBox(
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
                                      const Icon(
                                        CupertinoIcons.person_3_fill,
                                        size: 28.0,
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      const Text(
                                        "Users",
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "$_userCount Users",
                                    style: const TextStyle(
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
                                      const Icon(
                                        CupertinoIcons.film,
                                        size: 26.0,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      const Text(
                                        "Movies",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "$_moviesCount Movies",
                                    style: const TextStyle(
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
                                      const Icon(
                                        Icons.people,
                                        size: 26.0,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      const Text(
                                        "Series",
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "${_series.length}",
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
                                      const Icon(
                                        Icons.admin_panel_settings_outlined,
                                        size: 26.0,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      const Text(
                                        "Admins",
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "$adminsCount",
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
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "$_moviesCount Movies",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Text(
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
                                  icon: const Icon(Icons.close)),
                              hintText: "Type Movie Title",
                              prefixIcon: const Icon(Icons.search),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    _posts == null
                        ? const SizedBox()
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
                                        return buildPostCard(
                                          postModel,
                                        );
                                      });
                                }),
                          ),

                    const SizedBox(
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
                    const SizedBox(
                      height: 40.0,
                    ),
                    //Now let's add the mos papulare
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Most Papular',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        DropdownButton(
                            borderRadius: BorderRadius.circular(8),
                            hint: Text("Order by"),
                            items: [
                              DropdownMenuItem(
                                value: "Timestamp",
                                child: Text("Date"),
                              ),
                              DropdownMenuItem(
                                value: "likes",
                                child: Text("Likes"),
                              ),
                              DropdownMenuItem(
                                value: "views",
                                child: Text("Views"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                orderItems = value.toString();
                                print(orderItems);
                              });
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
                          stream: newMoviesRef
                              .orderBy(orderItems, descending: true)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: LinearProgressIndicator(
                                backgroundColor: whiteColor,
                                color: moviePageColor,
                              ));
                            } else if (snapshot == ConnectionState.waiting) {
                              return const Center(
                                  child: LinearProgressIndicator(
                                backgroundColor: whiteColor,
                                color: moviePageColor,
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
                            return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  var title =
                                      snapshot.data.docs[index]['title'];
                                  var thumbnail =
                                      snapshot.data.docs[index]['thumbnail'];
                                  var video =
                                      snapshot.data.docs[index]['video'];
                                  var postuid =
                                      snapshot.data.docs[index]['postuid'];
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              thumbnail,
                                            )),
                                        color: Colors.amber,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          title,
                                          style: GoogleFonts.lato(
                                              color: whiteColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                    ),
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
            .push(MaterialPageRoute(builder: (context) => const Upload())),
        child: const Icon(
          Icons.add,
          color: whiteColor,
        ),
        backgroundColor: moviePageColor,
      ),
    );
  }
}
