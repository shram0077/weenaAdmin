import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Movies/moviePage.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

import '../Screens/Post/EditPost.dart';

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
                child: Row(
                  children: [
                    Text(
                      widget.postModel.title,
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        onPressed: () {
                          showModalPost(widget.postModel, context);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: whiteColor,
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  bool isloading = false;

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
