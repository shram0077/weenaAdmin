import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

class EditPost extends StatefulWidget {
  final PostModel postModel;

  const EditPost({key, required this.postModel});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
//
  String? _description;
  String? _userId;
  String? _titleOFvideo;
  String? _videoURL;
  String? _thumbnailURL;
  List? _tagsOfVideo;
  String? _trailer;
  String? _postuid;
  int? _series;
  int? _episode;
  bool? _verified;
  Timestamp? _timestamp;
  double? _imdbRating;
  int? _likes;
  int? _views;
  //
  List<String> tags = [
    'ئاکشن',
    'کۆمیدیا',
    'ڕۆمانسی',
    'تراژیدی',
    'غەمگین',
    'ترسناک',
    'نهێنی',
    'گەڕان',
    'سەرکێشی',
    'تەکنەلۆجیا',
    'خەیاڵی زانستی',
    'زیرەکی',
    'تاوانکاری',
    'ئه‌نیمه‌یشن',
    'دراما',
    'خێزانی'
  ];
  String? _typeMovie;
  List<String> listOfValue = [
    'Movie',
    'Drama',
    'Series',
    'Animation and Carton',
  ];
  bool _isLoading = false;
  save() async {
    setState(() {
      _isLoading = true;
    });
    PostModel postModel = PostModel(
        likes: _likes!,
        views: _views!,
        imdbRating: _imdbRating!,
        postuid: _postuid!,
        series: _series!,
        userId: _userId!,
        episode: _episode!,
        title: _titleOFvideo!,
        timestamp: _timestamp!,
        description: _description!,
        video: _videoURL!,
        type: _typeMovie!,
        id: _postuid!,
        thumbnail: _thumbnailURL!,
        verified: _verified!,
        tags: _tagsOfVideo!,
        trailer: _trailer!);
    updatePost(postModel);
    // Navigator.pop(context);
  }

  updatePost(PostModel postModel) async {
    // Update on profile

    QuerySnapshot followerSnapshot =
        await followersRef.doc(postModel.userId).collection('Followers').get();
    try {
      if (followerSnapshot.docChanges.isEmpty) {
        print('No Followers');
      } else {
        for (var docSnapshot in followerSnapshot.docs) {
          setState(() {
            _isLoading = true;
          });
          await followingPostsRef
              .doc(docSnapshot.id)
              .collection('posts')
              .doc(postModel.postuid)
              .update({
            "description": postModel.description,
            "video": postModel.video,
            "Timestamp": postModel.timestamp,
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
            "imdbRating": postModel.imdbRating
          }).whenComplete(() {
            setState(() {
              _isLoading = false;
            });
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "$e", backgroundColor: errorColor);
    }
    setState(() {
      _isLoading = true;
    });
    await postsRef
        .doc(postModel.userId)
        .collection("userPosts")
        .doc(postModel.postuid)
        .update({
      "description": postModel.description,
      "video": postModel.video,
      "Timestamp": postModel.timestamp,
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
      "imdbRating": postModel.imdbRating
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
    setState(() {
      _isLoading = true;
    });
    await newMoviesRef.doc(postModel.postuid).update({
      "description": postModel.description,
      "video": postModel.video,
      "Timestamp": postModel.timestamp,
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
      "imdbRating": postModel.imdbRating
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
    setState(() {
      _isLoading = true;
    });
    await recommendedRef.doc(postModel.postuid).update({
      "description": postModel.description,
      "video": postModel.video,
      "Timestamp": postModel.timestamp,
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
      "imdbRating": postModel.imdbRating
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
    setState(() {
      _isLoading = true;
    });
    await explorersRef.doc(postModel.postuid).update({
      "description": postModel.description,
      "video": postModel.video,
      "Timestamp": postModel.timestamp,
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
      "imdbRating": postModel.imdbRating
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          timeInSecForIosWeb: 3,
          msg: '${postModel.title} successfully updated!');
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _postuid = widget.postModel.postuid;
    _thumbnailURL = widget.postModel.thumbnail;
    _description = widget.postModel.description;
    _tagsOfVideo = widget.postModel.tags;
    _userId = widget.postModel.userId;
    _trailer = widget.postModel.trailer;
    _videoURL = widget.postModel.video;
    _titleOFvideo = widget.postModel.title;
    _series = widget.postModel.series;
    _verified = widget.postModel.verified;
    _timestamp = widget.postModel.timestamp;
    _episode = widget.postModel.episode;
    _imdbRating = widget.postModel.imdbRating;
    _typeMovie = widget.postModel.type;
    _likes = widget.postModel.likes;
    _views = widget.postModel.views;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: moviePageColor,
        elevation: 0,
        actions: [
          CupertinoButton(
              child: Text(
                'Delete',
                style: GoogleFonts.alef(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                    color: Colors.white),
              ),
              onPressed: () {
                _isLoading
                    ? null
                    : showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: moviePageColor,
                            title: Text(
                              "Alert!!",
                              style: TextStyle(color: whiteColor),
                            ),
                            content: Text(
                              "Are you sure delete this post?",
                              style: TextStyle(color: whiteColor),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  DatabaseServices.removeEveryWhere(
                                      widget.postModel);
                                },
                              ),
                              TextButton(
                                child: Text("No",
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w500)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
              }),
          Container(
            height: 10,
            width: 0.5,
            color: whiteColor,
          ),
          CupertinoButton(
              child: Text(
                'Save',
                style: GoogleFonts.alef(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                    color: Colors.white),
              ),
              onPressed: () {
                _isLoading ? null : save();
              }),
        ],
        title: Row(
          children: [
            Icon(CupertinoIcons.pencil_outline),
            SizedBox(
              width: 3,
            ),
            Text(widget.postModel.title),
          ],
        ),
      ),
      body: _isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: circularProgressIndicator(),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Updating...',
                  style: GoogleFonts.barlow(
                      fontSize: 20,
                      color: moviePageColor,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          : ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'Description',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            initialValue: _description,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Description',
                            ),
                            onChanged: (value) {
                              _description = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'Title',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            initialValue: _titleOFvideo,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title',
                            ),
                            onChanged: (value) {
                              _titleOFvideo = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'Video URL',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            initialValue: _videoURL,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Video URL',
                            ),
                            onChanged: (value) {
                              _videoURL = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'Trailer URL',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            initialValue: _trailer,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Trailer URL',
                            ),
                            onChanged: (value) {
                              _trailer = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'Thubmnail URL',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            initialValue: _thumbnailURL,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Thubmnail URL',
                            ),
                            onChanged: (value) {
                              _thumbnailURL = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'IMDB Rating',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                                width: 35,
                                height: 25,
                                child: Image.asset('assets/icons/imdb.png'))
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TextFormField(
                            initialValue: _imdbRating.toString(),
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "IMDB Rating",
                            ),
                            onChanged: (value) {
                              _imdbRating = double.parse(value);
                            },
                          ),
                        ),
                      ),
                      widget.postModel.series == 'Series'
                          ? Row(
                              children: [
                                Container(
                                  color: Colors.red,
                                  width: 123,
                                  height: 26,
                                )
                              ],
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'UserId',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            initialValue: _userId,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'UserId',
                            ),
                            onChanged: (value) {
                              _userId = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'Episode',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            initialValue: _episode.toString(),
                            keyboardType: TextInputType.number,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Episode',
                            ),
                            onChanged: (value) {
                              _episode = int.parse(value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'Series',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            initialValue: _series.toString(),
                            keyboardType: TextInputType.number,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Series',
                            ),
                            onChanged: (value) {
                              _series = int.parse(value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'Type',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5)),
                          isExpanded: true,
                          value: _typeMovie,
                          hint: const Text(
                            'Movie,Drama',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _typeMovie = value;
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              _typeMovie = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "can't empty";
                            } else {
                              return null;
                            }
                          },
                          items: listOfValue.map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text(
                              'Tags',
                              style: GoogleFonts.barlow(
                                  color: moviePageColor,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(tags.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.postModel.tags.add(tags[index]);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blueGrey,
                                    ),
                                    child: Text(
                                      tags[index],
                                      style: GoogleFonts.barlow(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        height: 2,
                        indent: 1,
                        endIndent: 1,
                        thickness: 1,
                      ),
                      Row(
                        children: List.generate(_tagsOfVideo!.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.postModel.tags
                                      .remove(_tagsOfVideo![index]);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color.fromARGB(255, 232, 68, 14),
                                ),
                                child: Text(
                                  _tagsOfVideo![index],
                                  style: GoogleFonts.barlow(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 15),
                      _isLoading
                          ? circularProgressIndicator()
                          : const SizedBox.shrink()
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
