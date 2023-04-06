import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Movies/moviePage.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

class PostConatiner extends StatefulWidget {
  final String currentUserId;
  final PostModel postModel;
  final UserModell userModell;

  const PostConatiner(
      {Key? key,
      required this.currentUserId,
      required this.postModel,
      required this.userModell})
      : super(key: key);

  @override
  State<PostConatiner> createState() => _PostConatinerState();
}

class _PostConatinerState extends State<PostConatiner> {
  bool _isLiked = false;
  int _likes = 0;
  var key;
  getLikesCount() async {
    int likesCount = await DatabaseServices.getPostLikes(widget.postModel.id);
    if (mounted) {
      setState(() {
        _likes = likesCount;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLikesCount();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: MoviePage(
                  postModel: widget.postModel,
                )));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: [
              const BoxShadow(
                color: Color.fromARGB(255, 59, 58, 58),
                spreadRadius: 0.5,
                blurRadius: 4,
                offset: Offset(0, 0.9),
              ),
            ],
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.postModel.thumbnail,
                ),
                fit: BoxFit.cover),
            color: moviePageColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(9)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 8, top: 3, bottom: 2),
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(9),
                        bottomLeft: Radius.circular(9)),
                    color: moviePageColor),
                child: Text(
                  widget.postModel.title,
                  style: GoogleFonts.roboto(
                      color: Colors.white, fontWeight: FontWeight.w600),
                )),
          ],
        ),
      ),
    );
  }

  bool isloading = false;
  showPostBottom() {
    String postID = widget.postModel.postuid;
    String postTitle = widget.postModel.title;

    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 5, bottom: 15),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Share',
                          style: GoogleFonts.roboto(),
                        ),
                        leading: const Icon(
                          CupertinoIcons.share,
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          try {
                            DatabaseServices.removeEveryWhere(
                              widget.postModel,
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                        title: Text(
                          'Delete',
                          style: GoogleFonts.roboto(color: Colors.red),
                        ),
                        leading: const Icon(
                          CupertinoIcons.trash,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  showComments() {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                Center(
                  child: Text(
                    'Comments',
                    style: GoogleFonts.lato(
                        height: 2, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  height: 500,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12))),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(widget.userModell.name),
                        subtitle: Text(widget.postModel.description),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              MyEncriptionDecription.decryptWithAESKey(
                                  widget.userModell.profilePicture)),
                        ),
                      ),
                      ListTile(
                        title: Text(widget.userModell.name),
                        subtitle: Text(widget.postModel.description),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              MyEncriptionDecription.decryptWithAESKey(
                                  widget.userModell.profilePicture)),
                        ),
                      ),
                      ListTile(
                        title: Text(widget.userModell.name),
                        subtitle: Text(widget.postModel.description),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              MyEncriptionDecription.decryptWithAESKey(
                                  widget.userModell.profilePicture)),
                        ),
                      ),
                      ListTile(
                        title: Text(widget.userModell.name),
                        subtitle: Text(widget.postModel.description),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              MyEncriptionDecription.decryptWithAESKey(
                                  widget.userModell.profilePicture)),
                        ),
                      ),
                      ListTile(
                        title: Text(widget.userModell.name),
                        subtitle: Text(widget.postModel.description),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              MyEncriptionDecription.decryptWithAESKey(
                                  widget.userModell.profilePicture)),
                        ),
                      ),
                      ListTile(
                        title: Text(widget.userModell.name),
                        subtitle: Text(widget.postModel.description),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              MyEncriptionDecription.decryptWithAESKey(
                                  widget.userModell.profilePicture)),
                        ),
                      ),
                      ListTile(
                        title: Text(widget.userModell.name),
                        subtitle: Text(widget.postModel.description),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              MyEncriptionDecription.decryptWithAESKey(
                                  widget.userModell.profilePicture)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}


// Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               normalAvatar(widget.userModell, context, widget.currentUserId,
//                   widget.postModel.userId, key, 55, 55, 20),
//               const SizedBox(width: 10),
//               Text(
//                 widget.userModell.name,
//                 style: GoogleFonts.barlow(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 ' · ${widget.postModel.title}',
//                 style: GoogleFonts.barlow(
//                   fontSize: 14.5,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               const Spacer(),
//               widget.userModell.id != widget.currentUserId
//                   ? const SizedBox()
//                   : IconButton(
//                       onPressed: () {
//                         showPostBottom();
//                       },
//                       icon: const Icon(
//                         FlutterIcons.more_vert_mdi,
//                         size: 19,
//                       ))
//             ],
//           ),
//           const SizedBox(height: 15),
//           ReadMoreText(
//             widget.postModel.description,
//             style: GoogleFonts.barlow(
//               fontSize: 15,
//             ),
//             trimLines: 6,
//             colorClickableText: Colors.redAccent,
//             trimMode: TrimMode.Line,
//             trimCollapsedText: 'Show more',
//             trimExpandedText: '   Show less',
//             moreStyle: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//               color: appcolor,
//             ),
//           ),
//           widget.postModel.video.isEmpty
//               ? const SizedBox.shrink()
//               : Column(
//                   children: [
//                     const SizedBox(height: 15),
//                     InkWell(
//                       onTap: () {
//                         // Navigator.push(
//                         //     context,
//                         //     PageTransition(
//                         //         type: PageTransitionType.rightToLeft,
//                         //         child: DetailThePost(
//                         //           timestamp: widget.postModel.timestamp,
//                         //           currencyType: widget.postModel.currencyType,
//                         //           description: widget.postModel.description,
//                         //           goodsType: widget.postModel.typeOfGoods,
//                         //           name: widget.userModell.name,
//                         //           phoneNumber: widget.postModel.phoneNumber,
//                         //           pictures: widget.postModel.pictures,
//                         //           price: widget.postModel.price,
//                         //           title: widget.postModel.title,
//                         //           userId: widget.postModel.userId,
//                         //           userModell: widget.userModell,
//                         //           currentUserId: widget.currentUserId,
//                         //           key: key,
//                         //         )));
//                       },
//                       child: Container(
//                         height: 250,
//                         decoration: BoxDecoration(
//                             color: profileBGcolor,
//                             borderRadius: BorderRadius.circular(10),
//                             image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(widget.postModel.thumbnail),
//                             )),
//                       ),
//                     )
//                   ],
//                 ),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       _isLiked ? Icons.favorite_rounded : Icons.favorite_border,
//                       color: _isLiked ? Colors.red : Colors.black,
//                     ),
//                     onPressed: likeOrUnlike,
//                   ),
//                   Text(
//                     '$_likes likes',
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       FlutterIcons.comment_faw5,
//                     ),
//                     onPressed: showComments,
//                   ),
//                   const Text(
//                     '232 comments',
//                   ),
//                 ],
//               ),
//               Text(
//                 timeago.format(widget.postModel.timestamp.toDate()),
//                 style:
//                     const TextStyle(color: Color.fromARGB(255, 132, 132, 132)),
//               )
//             ],
//           ),
//           const SizedBox(height: 10),
//           const Divider()
//         ],
//       ),
//     );