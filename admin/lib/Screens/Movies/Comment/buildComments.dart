import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Users/UserProfile.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../Models/CommentModel.dart';

buildComments(CommentModel commentModel, context, String currentUserId) {
  double width = MediaQuery.of(context).size.width;

  return StreamBuilder(
      stream: usersRef.doc(commentModel.byUserId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: isloadingComments(context));
        } else {
          UserModell userModel = UserModell.fromDoc(snapshot.data);
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  GestureDetector(
                    onLongPress: () {
                      if (commentModel.byUserId == currentUserId) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: appBarDarkColor,
                              title: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.trash,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      'Do you want to delete your comment?',
                                      style: GoogleFonts.barlow(
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  // ignore: sort_child_properties_last
                                  child: Text(
                                    'NO',
                                    style:
                                        GoogleFonts.barlow(color: Colors.white),
                                  ),
                                  onPressed: Navigator.of(context).pop,
                                ),
                                TextButton(
                                  child: Text(
                                    'YES',
                                    style: GoogleFonts.barlow(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    commentsRef
                                        .doc(commentModel.postuid)
                                        .collection('Comments')
                                        .doc(currentUserId)
                                        .delete()
                                        .whenComplete(() {
                                      Fluttertoast.showToast(
                                        msg: 'Done',
                                        backgroundColor: appcolor,
                                        textColor: Colors.white,
                                      );
                                      Navigator.pop(context);
                                    });
                                  },
                                )
                              ],
                            );
                          },
                        );
                      } else {}
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 2,
                          ),
                          commentModel.author
                              ? Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.person_circle_fill,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 1,
                                    ),
                                    Text(
                                      'Author',
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white),
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    userModel.name.isEmpty
                                        ? userModel.username
                                        : userModel.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize:
                                            userModel.name.isEmpty ? 13 : 14.5),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  userModel.verification
                                      ? const Icon(
                                          CupertinoIcons.checkmark_seal_fill,
                                          color:
                                              Color.fromARGB(255, 72, 197, 255),
                                          size: 13,
                                        )
                                      : const SizedBox.shrink(),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const Text(
                                    '·',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 158, 158, 158),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                      '${timeago.format(commentModel.timestamp.toDate())} ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 178, 178, 178),
                                          fontSize: 10.5)),
                                ],
                              )),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            color: const Color.fromARGB(255, 191, 191, 191)
                                .withOpacity(.3),
                            height: 0.5,
                            width: width / 1.5,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: width / 1.5,
                            child: ReadMoreText(
                              commentModel.commentText,
                              preDataTextStyle:
                                  GoogleFonts.barlow(color: Colors.white),
                              trimLines: 5,
                              style: GoogleFonts.barlow(
                                  fontSize: 15, color: Colors.white),
                              colorClickableText: Colors.amber,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'See more',
                              trimExpandedText: '  Show less',
                              moreStyle: GoogleFonts.barlow(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                FontAwesome.star,
                                size: 20,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 5),
                              Text(commentModel.rating.toString(),
                                  style: GoogleFonts.barlow(
                                      fontSize: 14.5, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        }
      });
}
