import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Screens/Movies/moviePage.dart';
import 'package:admin/Screens/Post/EditPost.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:page_transition/page_transition.dart';

class PostCard extends StatefulWidget {
  final PostModel postModel;
  const PostCard({
    key,
    required this.postModel,
  });
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _likes = 0;
  var key;
  getLikesCount() async {
    int likesCount =
        await DatabaseServices.getPostLikes(widget.postModel.postuid);
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: 1,
        alwaysIncludeSemantics: false,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: moviePageColor,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: MoviePage(
                          postModel: widget.postModel,
                        ))),
                child: Container(
                  width: 160,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            widget.postModel.thumbnail),
                        fit: BoxFit.cover),
                    color: moviePageColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(1),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(1)),
                  ),
                ),
              ),
              Container(
                width: 185,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(1),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(1)),
                    color: Colors.transparent),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      Text(
                        widget.postModel.title,
                        style: GoogleFonts.barlow(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Flexible(
                        child: Text(
                          widget.postModel.description,
                          style: GoogleFonts.barlow(
                              height: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                              Text(
                                '$_likes likes',
                                style: GoogleFonts.barlow(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                showModalPost(widget.postModel, context);
                              },
                              icon: const Icon(
                                Icons.more_horiz_outlined,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.postModel.type,
                            style: GoogleFonts.barlow(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      widget.postModel.type == 'Series'
                          ? Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     PageTransition(
                                      //         type: PageTransitionType.fade,
                                      //         child: AddSeries(
                                      //           postModel: widget.postModel,
                                      //         )));
                                    },
                                    child: Text(
                                      'Add Series',
                                      style: GoogleFonts.barlow(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ],
                            )
                          : SizedBox(),
                      widget.postModel.verified
                          ? Row(
                              children: [
                                Text(
                                  'Verifed',
                                  style: GoogleFonts.oswald(
                                      color: Colors.white, fontSize: 17),
                                ),
                                const Icon(
                                  Icons.verified_outlined,
                                  color: Colors.white,
                                  size: 18,
                                )
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
