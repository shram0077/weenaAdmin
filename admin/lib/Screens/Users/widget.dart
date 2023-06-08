import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/linksModel.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Users/UserProfile.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

searchResult(_users) {
  return FutureBuilder(
      future: _users,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: circularProgressIndicator(),
          );
        }
        if (snapshot.data.docs.length == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No users found!',
                    style: GoogleFonts.alef(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    )),
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: circularProgressIndicator(),
          );
        }
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              UserModell user = UserModell.fromDoc(snapshot.data.docs[index]);
              return Column(
                children: [
                  Card(
                    margin: const EdgeInsets.only(
                        left: 6, right: 6, bottom: 10, top: 8),
                    child: ListTile(
                      tileColor: moviePageColor,
                      // ignore: prefer_const_constructors
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserProfile(
                                    email: snapshot.data.docs[index]['email'],
                                    bio: snapshot.data.docs[index]['bio'],
                                    username: snapshot.data.docs[index]
                                        ['username'],
                                    displayName: snapshot.data.docs[index]
                                        ['name'],
                                    country: snapshot.data.docs[index]
                                        ['country'],
                                    cityortown: snapshot.data.docs[index]
                                        ['cityorTown'],
                                    coverPicture: snapshot.data.docs[index]
                                        ['coverPicture'],
                                    profilePicture: snapshot.data.docs[index]
                                        ['profilePicture'],
                                    verification: snapshot.data.docs[index]
                                        ['verification'],
                                    visitedUserId: snapshot.data.docs[index]
                                        ['id'],
                                  )));
                        },
                        icon: const Icon(
                          CupertinoIcons.eye,
                          color: whiteColor,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data.docs[index]['username'],
                        style: GoogleFonts.roboto(
                            color: whiteColor.withOpacity(0.9),
                            fontWeight: FontWeight.w500),
                      ),
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              MyEncriptionDecription.decryptWithAESKey(snapshot
                                  .data.docs[index]['profilePicture']))),
                      title: Text(
                        snapshot.data.docs[index]['name'],
                        style: GoogleFonts.barlow(
                            color: whiteColor, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              );
            });
      });
}

userNameProfile(UserModell userModell) {
  return Padding(
    padding: const EdgeInsets.only(top: 0.5, left: 5, bottom: 1.5),
    child: Text(
      "@${userModell.username}",
      style: GoogleFonts.barlow(
          fontWeight: FontWeight.w600, fontSize: 16, color: whiteColor),
    ),
  );
}

displayName(UserModell userModell) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, left: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userModell.name,
              style: GoogleFonts.roboto(
                  fontSize: 19, fontWeight: FontWeight.bold, color: whiteColor),
            ),
            const SizedBox(
              width: 1,
            ),
            userModell.verification
                ? Icon(CupertinoIcons.checkmark_seal_fill,
                    size: 16, color: verifiedColor)
                : const SizedBox()
          ],
        ),
      ],
    ),
  );
}

followingandFollowers(
  int followingCount,
  int followersCount,
) {
  return Padding(
    padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 5),
    child: Row(
      children: [
        Text(
          '$followingCount Following',
          style: GoogleFonts.barlow(
            fontSize: 17,
            color: whiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 1,
          height: 11,
          color: Colors.grey.shade400,
        ),
        const SizedBox(width: 6),
        Text(
          '$followersCount Followers',
          style: GoogleFonts.barlow(
            fontSize: 17,
            color: whiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

bio(UserModell userModell, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Container(
          padding: const EdgeInsets.only(top: 2, bottom: 0),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            userModell.bio.isEmpty ? '' : "${userModell.bio}",
            style: GoogleFonts.barlow(
                color: Color.fromARGB(255, 214, 213, 213),
                fontWeight: FontWeight.w400,
                fontSize: 15),
          ),
        ),
      ),
    ],
  );
}

location(UserModell userModell, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      userModell.country.isNotEmpty
          ? Row(
              children: [
                Icon(FlutterIcons.location_pin_ent,
                    size: 15, color: whiteColor),
                Container(
                  padding: const EdgeInsets.only(top: 2, bottom: 0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "${userModell.country}${userModell.cityorTown.isEmpty ? "" : " , "}${userModell.cityorTown}",
                    style: GoogleFonts.roboto(
                        color: Color.fromARGB(255, 208, 203, 203),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ],
            )
          : const SizedBox()
    ],
  );
}

normalAvatar(
  context,
  String profilePicture,
  String visitedUserId,
  key,
  double height,
  double width,
  double raduis,
) {
  return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(1),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(raduis),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 78, 89, 123).withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(raduis),
          child: CachedNetworkImage(
            imageUrl: MyEncriptionDecription.decryptWithAESKey(profilePicture),
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
        ),
      ));
}

socialMediaButton(Color color, IconData icon) {
  return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(13)),
      child: Icon(
        icon,
        color: Colors.white,
      ));
}

Widget buildSocialButtons(String visitedUserId) {
  return StreamBuilder(
      stream: linksRef.doc(visitedUserId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
          // ignore: unrelated_type_equality_checks
        } else if (snapshot == ConnectionState.waiting) {
          return const SizedBox();
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

        LinksModel linksModel = LinksModel.fromDoc(snapshot.data);
        return Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 5, right: 5),
          child: Row(
            children: [
              linksModel.youtube.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: GestureDetector(
                        onTap: () async {
                          var url = linksModel.youtube;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            print('Could not launch $url');
                          }
                        },
                        child: socialMediaButton(
                            Colors.red, FontAwesome.youtube_play),
                      ))
                  : const SizedBox(),
              if (linksModel.facebook.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: GestureDetector(
                      onTap: () async {
                        var url = linksModel.facebook;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          print('Could not launch $url');
                        }
                      },
                      child:
                          socialMediaButton(Colors.blue, FontAwesome.facebook),
                    ))
              else
                const SizedBox(),
              if (linksModel.instagram.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: GestureDetector(
                      onTap: () async {
                        var url = linksModel.instagram;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          print('Could not launch $url');
                        }
                      },
                      child: socialMediaButton(
                          Color.fromARGB(255, 244, 45, 111),
                          FontAwesome.instagram),
                    ))
              else
                const SizedBox()
            ],
          ),
        );
      });
}
