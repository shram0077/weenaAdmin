import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Users/UserProfile.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:page_transition/page_transition.dart';

import '../../Models/Post.dart';

class MoviePageButtons extends StatefulWidget {
  final PostModel postModel;
  final int views;
  final int likes;
  const MoviePageButtons(
      {key, required this.postModel, required this.views, required this.likes});

  @override
  State<MoviePageButtons> createState() => _MoviePageButtonsState();
}

class _MoviePageButtonsState extends State<MoviePageButtons> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: usersRef.doc(widget.postModel.userId).snapshots(),
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: 60,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(14, 237, 233, 233),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.likes.toString(),
                          style: GoogleFonts.barlow(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: 60,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(14, 237, 233, 233),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.eye,
                          color: Colors.white,
                          size: 19,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.views.toString(),
                          textAlign: TextAlign.end,
                          style: GoogleFonts.barlow(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: UserProfile(
                                bio: userModel.bio,
                                cityortown: userModel.cityorTown,
                                username: userModel.username,
                                country: userModel.country,
                                coverPicture: userModel.coverPicture,
                                displayName: userModel.name,
                                email: userModel.email,
                                profilePicture: userModel.profilePicture,
                                verification: userModel.verification,
                                visitedUserId: userModel.id,
                              )));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(23),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                MyEncriptionDecription.decryptWithAESKey(
                                    userModel.profilePicture)),
                            fit: BoxFit.cover,
                            opacity: 35,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF292b37)),
                    ),
                  ),
                ]),
          );
        });
  }
}
