import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Users/userInformation.dart';
import 'package:admin/Screens/Users/widget.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/PostConatiner.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palette_generator/palette_generator.dart';

class UserProfile extends StatefulWidget {
  final String visitedUserId;
  final String username;
  final String displayName;
  final String country;
  final String cityortown;
  final String profilePicture;
  final String coverPicture;
  final bool verification;
  final String bio;
  final String email;
  const UserProfile(
      {key,
      required this.visitedUserId,
      required this.username,
      required this.displayName,
      required this.profilePicture,
      required this.coverPicture,
      required this.verification,
      required this.bio,
      required this.country,
      required this.cityortown,
      required this.email});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _followersCount = 0;
  int _followingCount = 0;
  dynamic _profileSegmentedValue = 0;
  List<PostModel> _allPosts = [];
  List<PostModel> _drama = [];
  List<PostModel> _movie = [];
  List<PostModel> _series = [];
  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNumber(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNumber(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  getAllPosts() async {
    List<PostModel> userPosts =
        await DatabaseServices.getUserPosts(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _allPosts = userPosts;
        _drama = _allPosts.where((element) => element.type == 'Drama').toList();
        _movie = _allPosts.where((element) => element.type == 'Movie').toList();
      });
      // ignore: avoid_print
      print(userPosts.toList());
    }
  }

  // ignore: prefer_final_fields
  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'All',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
    1: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Movies",
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
    2: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Dramas",
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
    3: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Series",
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
  };

  Widget buildProfileWidgets(UserModell author) {
    switch (_profileSegmentedValue) {
      case 0:
        return GridView.builder(
            physics:
                const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: _allPosts.length,
            itemBuilder: (BuildContext ctx, index) {
              return PostConatiner(
                currentUserId: widget.visitedUserId,
                postModel: _allPosts[index],
                userModell: author,
              );
            });
        break;
      case 1:
        return GridView.builder(
            physics:
                const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: _movie.length,
            itemBuilder: (BuildContext ctx, index) {
              return PostConatiner(
                currentUserId: widget.visitedUserId,
                postModel: _movie[index],
                userModell: author,
              );
            });
        break;
      case 2:
        return GridView.builder(
            physics:
                const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: _drama.length,
            itemBuilder: (BuildContext ctx, index) {
              return PostConatiner(
                currentUserId: widget.visitedUserId,
                postModel: _drama[index],
                userModell: author,
              );
            });

        break;
      case 3:
        return GridView.builder(
            physics:
                const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: _series.length,
            itemBuilder: (BuildContext ctx, index) {
              return PostConatiner(
                currentUserId: widget.visitedUserId,
                postModel: _series[index],
                userModell: author,
              );
            });
        break;
      default:
        return const Center(
            child: Text('Something wrong',
                style: TextStyle(
                  fontSize: 25,
                )));
        break;
        ;
    }
  }

  PaletteGenerator? paletteGenerator;
  void _genrateColors() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(
            MyEncriptionDecription.decryptWithAESKey(widget.coverPicture)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.coverPicture.isNotEmpty) {
      _genrateColors();
    } else {}
    getAllPosts();
    getFollowersCount();
    getFollowingCount();
  }

  var key;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            centerTitle: false,
            backgroundColor: paletteGenerator != null
                ? paletteGenerator!.vibrantColor != null
                    ? paletteGenerator!.vibrantColor!.color
                    : appBarColor.withOpacity(0.8)
                : appBarColor.withOpacity(0.8),
            elevation: 0.5,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 5),
              child: Text(
                widget.username,
                style: GoogleFonts.barlow(),
              ),
            ),
            expandedHeight: 180,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {},
                child: widget.coverPicture.isEmpty
                    ? Container(
                        color: Color.fromARGB(138, 29, 29, 29),
                        height: 249,
                      )
                    : Container(
                        height: 249,
                        decoration: BoxDecoration(
                          color: appBarColor.withOpacity(0.7),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              MyEncriptionDecription.decryptWithAESKey(
                                  widget.coverPicture),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          )
        ],
        body: StreamBuilder(
          stream: usersRef.doc(widget.visitedUserId).snapshots(),
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
            return ListView(
              physics:
                  const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
              children: [
                Container(
                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 35, left: 5),
                                  child: normalAvatar(
                                      context,
                                      widget.profilePicture,
                                      widget.visitedUserId,
                                      key,
                                      120,
                                      120,
                                      12))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              onTap: showServices,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 6, bottom: 6, right: 8, left: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: moviePageColor,
                                  border:
                                      Border.all(color: whiteColor, width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    'Services',
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      displayName(userModel),
                      userNameProfile(userModel),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          followingandFollowers(
                              _followingCount, _followersCount),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: buildSocialButtons(userModel.id),
                          ),
                        ],
                      ),
                      userModel.bio.isEmpty
                          ? SizedBox()
                          : bio(userModel, context),
                      const SizedBox(
                        height: 3,
                      ),
                      location(userModel, context),
                      userModel.bio.isNotEmpty
                          ? const Divider()
                          : const SizedBox(),
                      _allPosts.length == 0
                          // ignore: prefer_const_constructors
                          ? Center(
                              child: Column(
                                children: [
                                  // ignore: prefer_const_constructors
                                  Icon(
                                    CupertinoIcons.camera_circle,
                                    size: 55,
                                    color: whiteColor,
                                  ),
                                  Text(
                                    'No posts yet',
                                    style: GoogleFonts.barlow(
                                        color: whiteColor,
                                        fontSize: 25,
                                        height: 1.5,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: CupertinoSlidingSegmentedControl(
                                groupValue: _profileSegmentedValue,
                                thumbColor: moviePageColor,
                                backgroundColor:
                                    Color.fromARGB(255, 74, 92, 113),
                                children: _profileTabs,
                                onValueChanged: (i) {
                                  setState(() {
                                    _profileSegmentedValue = i;
                                  });
                                },
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 5, right: 5),
                        child: buildProfileWidgets(userModel),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  showServices() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            ListTile(
              onTap: () async {
                try {
                  await auth.sendPasswordResetEmail(
                      email: MyEncriptionDecription.decryptWithAESKey(
                          widget.email));
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: 'Sent', backgroundColor: appcolor);
                } catch (e) {
                  Fluttertoast.showToast(
                      msg: 'Error!', backgroundColor: errorColor);
                }
              },
              leading: Icon(Icons.email_outlined),
              title: Text('Send forget password link'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: UserInformation(
                          visitedUserId: widget.visitedUserId,
                        )));
              },
              leading: Icon(Icons.info_outline),
              title: Text('Info'),
            ),
            const ListTile(
              leading: Icon(CupertinoIcons.trash),
              title: Text('remove permently'),
            ),
            const ListTile(
              leading: Icon(Icons.message_outlined),
              title: Text('Send a message'),
            ),
          ],
        );
      },
    );
  }
}
