import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Screens/Post/EditPost.dart';
import 'package:admin/Services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

circularProgressIndicator() {
  return CircularProgressIndicator(
    color: moviePageColor,
    backgroundColor: whiteColor,
  );
}

isloadingComments(context) {
  double width = MediaQuery.of(context).size.width;

  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: unColor,
            ),
          ),
          GestureDetector(
            onLongPress: () {},
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 20,
                            decoration: BoxDecoration(
                                color: unColor,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 45,
                            height: 20,
                            decoration: BoxDecoration(
                                color: unColor,
                                borderRadius: BorderRadius.circular(5)),
                          ),
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
                    width: width / 1.5,
                    height: 28,
                    decoration: BoxDecoration(
                        color: unColor, borderRadius: BorderRadius.circular(5)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 35,
                        height: 20,
                        decoration: BoxDecoration(
                            color: unColor,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 35,
                        height: 20,
                        decoration: BoxDecoration(
                            color: unColor,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
}

showModalPost(PostModel postModel, context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Wrap(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          ListTile(
            onTap: () async {
              await recommendedRef.doc(postModel.postuid).set({
                "description": postModel.description,
                "video": postModel.video,
                "Timestamp": Timestamp.now(),
                "postuid": postModel.postuid,
                "title": postModel.title,
                "type": postModel.type,
                "userId": postModel.userId,
                "verified": postModel.verified,
                'thumbnail': postModel.thumbnail,
                "episode": postModel.episode,
                'series': postModel.series,
                "tags": postModel.tags,
                "trailer": postModel.trailer,
                "imdbRating": postModel.imdbRating,
                "likes": postModel.likes,
                "views": postModel.views,
              });
            },
            leading: const Icon(Icons.recommend),
            title: const Text('set to Recommended'),
          ),
          ListTile(
            onTap: () async {
              recommendedRef
                  .doc(postModel.postuid)
                  .delete()
                  .whenComplete(() => Fluttertoast.showToast(msg: 'Done'));
            },
            leading: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            title: const Text(
              'Remove in Recommended-only',
              style: TextStyle(color: Colors.red),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              explorersRef.doc(postModel.postuid).set({
                "description": postModel.description,
                "video": postModel.video,
                "Timestamp": Timestamp.now(),
                "postuid": postModel.postuid,
                "title": postModel.title,
                "type": postModel.type,
                "userId": postModel.userId,
                "verified": postModel.verified,
                'thumbnail': postModel.thumbnail,
                "episode": postModel.episode,
                'series': postModel.series,
                "tags": postModel.tags,
                "trailer": postModel.trailer,
                "imdbRating": postModel.imdbRating,
                "likes": postModel.likes,
                "views": postModel.views,
              });
            },
            leading: const Icon(Icons.explore),
            title: const Text('set to Explorer'),
          ),
          ListTile(
            onTap: () async {
              explorersRef
                  .doc(postModel.postuid)
                  .delete()
                  .whenComplete(() => Fluttertoast.showToast(msg: 'Done'));
            },
            leading: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            title: const Text(
              'Remove in Explorer-only',
              style: TextStyle(color: Colors.red),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () async {
              await newMoviesRef.doc(postModel.postuid).set({
                "description": postModel.description,
                "video": postModel.video,
                "Timestamp": Timestamp.now(),
                "postuid": postModel.postuid,
                "title": postModel.title,
                "type": postModel.type,
                "userId": postModel.userId,
                "verified": postModel.verified,
                'thumbnail': postModel.thumbnail,
                "episode": postModel.episode,
                'series': postModel.series,
                "tags": postModel.tags,
                "trailer": postModel.trailer,
                "imdbRating": postModel.imdbRating,
                "likes": postModel.likes,
                "views": postModel.views,
              });
            },
            leading: const Icon(Icons.recommend),
            title: const Text('set to NewMovies'),
          ),
          ListTile(
            onTap: () async {
              newMoviesRef
                  .doc(postModel.id)
                  .delete()
                  .whenComplete(() => Fluttertoast.showToast(msg: 'Done'));
            },
            leading: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            title: const Text(
              'Remove in NewMovies-only',
              style: TextStyle(color: Colors.red),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: EditPost(
                        postModel: postModel,
                      )));
            },
            leading: const Icon(CupertinoIcons.pencil_circle),
            title: const Text('Edit'),
          ),
          ListTile(
            onTap: () {
              DatabaseServices.removeEveryWhere(postModel);
            },
            leading: const Icon(CupertinoIcons.trash),
            title: const Text('Remove everywhere'),
          ),
        ],
      );
    },
  );
}
