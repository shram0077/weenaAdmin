import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentField extends StatefulWidget {
  final PostModel postModel;
  final String currentUserId;

  const CommentField(
      {Key? key, required this.postModel, required this.currentUserId})
      : super(key: key);
  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  final commentController = TextEditingController();
  bool _isSending = false;
  bool _isPending = false;
  FocusNode focusNode = FocusNode();
  bool emojiShowing = false;
  double _rating = 0.5;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _rating != 0.5
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.star_circle,
                      size: 25,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      _rating.toString(),
                      style: GoogleFonts.barlow(color: Colors.amber),
                    )
                  ],
                ),
              )
            : SizedBox(),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, left: 3),
          child: SingleChildScrollView(
            child: Container(
              height: 60,
              color: Color.fromARGB(246, 7, 7, 7),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 3),
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: TextField(
                            enabled: _isSending ? false : true,
                            onTap: () {
                              setState(() {
                                emojiShowing = false;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                commentController;
                              });
                            },
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            focusNode: focusNode,
                            cursorColor: Colors.amber,
                            controller: commentController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "you just can see the comments".tr,
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
