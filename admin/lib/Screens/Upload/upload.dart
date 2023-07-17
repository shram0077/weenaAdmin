import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  const Upload({key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final descriptionController = TextEditingController();
  final userIdController = TextEditingController();
  final titleOFVideoController = TextEditingController();
  final thumbnailURLController = TextEditingController();
  final videoURLController = TextEditingController();
  final tagsController = TextEditingController();
  final trailerURLController = TextEditingController();
  final imdbRatingController = TextEditingController();

  bool _loading = false;
  String? _description;
  String? _userId;
  String? _titleOFvideo;
  String? _videoURL;
  String? _thumbnailURL;
  String? _tags;
  String? _trailer;
  bool _uploadToProfile = false;
  bool _uploadToNewMovies = false;
  bool _uploadToFollowersTimeline = false;
  bool _isCheckedUser = false;
  double? imdbRating;

  String? _typeMovie;
  List<String> userdIds = [
    "O0vj0b7RaYUi2UU4wAZ9ITqmWFE3",
    "BRLZNE7kWjbNy9bNzwsRU6SNdTF2",
    "hhieHehYJFY23GMvbwmvh6Qx7TE3",
  ];
  List<String> usernames = [
    "weena",
    "shram",
    "mdx079",
  ];

  List<String> resultTags = [];
  checkUserId() async {
    String userID = await DatabaseServices.checkUserId(userIdController.text);
    if (mounted) {
      setState(() {
        userID == _userId;
        _isCheckedUser = true;
      });
      // ignore: avoid_print
      print(userID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(5),
            child: sendButton(),
          )
        ],
        backgroundColor: appBarColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: Text(
          'Upload',
          style: GoogleFonts.barlow(color: whiteColor),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            controller: descriptionController,
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            controller: titleOFVideoController,
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            controller: videoURLController,
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            controller: trailerURLController,
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            controller: thumbnailURLController,
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            textDirection: TextDirection.ltr,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.barlow(),
                            controller: imdbRatingController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'IMDB Rating',
                            ),
                            onChanged: (value) {
                              imdbRating = double.parse(value);
                            },
                          ),
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
                      _typeMovie == 'Series'
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
                        padding: const EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(userdIds.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      userIdController.text = userdIds[index];
                                      _userId = userIdController.text;
                                    });
                                    print(_userId);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blueGrey,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          userdIds[index],
                                          style: GoogleFonts.barlow(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          usernames[index],
                                          style: GoogleFonts.barlow(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            // initialValue: _userId,
                            controller: userIdController,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.barlow(),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'UserId',
                            ),
                            onChanged: (value) {
                              _userId = value;
                              setState(() {
                                userIdController;
                              });
                            },
                          ),
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
                                      resultTags.add(tags[index]);
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
                        children: List.generate(resultTags.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  resultTags.remove(resultTags[index]);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color.fromARGB(255, 232, 68, 14),
                                ),
                                child: Text(
                                  resultTags[index],
                                  style: GoogleFonts.barlow(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _isCheckedUser != true
                          ? const SizedBox()
                          : buildUserInformation(),
                      userIdController.text.isEmpty
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: _loading ? null : checkUserId,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.blueGrey),
                                child: Center(
                                  child: Text(
                                    'Check userId',
                                    style: GoogleFonts.barlow(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                      const Divider(
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4),
                        child: ListTile(
                          tileColor: Colors.white,
                          title: const Text("Upload to profile"),
                          trailing: CupertinoSwitch(
                            value: _uploadToProfile,
                            onChanged: (value) {
                              setState(() {
                                _uploadToProfile = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4),
                        child: ListTile(
                          tileColor: Colors.white,
                          title: const Text("Upload to new Movie's"),
                          trailing: CupertinoSwitch(
                            value: _uploadToNewMovies,
                            onChanged: (value) {
                              setState(() {
                                _uploadToNewMovies = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4),
                        child: ListTile(
                          tileColor: Colors.white,
                          title: const Text("Upload to Timeline"),
                          trailing: CupertinoSwitch(
                            value: _uploadToFollowersTimeline,
                            onChanged: (value) {
                              setState(() {
                                _uploadToFollowersTimeline = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  buildUserInformation() {
    return StreamBuilder(
        stream: usersRef.doc(_userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Center(child: CircularProgressIndicator()),
            );
            // ignore: unrelated_type_equality_checks
          } else if (snapshot == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Center(child: CircularProgressIndicator()),
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
            padding: const EdgeInsets.only(left: 6.0, right: 6),
            child: ListTile(
              trailing: Text(
                MyEncriptionDecription.decryptWithAESKey(userModel.email),
                style: GoogleFonts.barlow(
                  color: Colors.white,
                ),
              ),
              tileColor: moviePageColor,
              leading: Container(
                width: 45,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        MyEncriptionDecription.decryptWithAESKey(
                            userModel.profilePicture)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userModel.name,
                    style: GoogleFonts.barlow(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    userModel.username,
                    style: GoogleFonts.barlow(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  sendButton() {
    if (_loading) {
      return CircularProgressIndicator();
    } else {
      return InkWell(
        onTap: () async {
          if (_typeMovie == null) {
            Fluttertoast.showToast(msg: 'type of the video is empty');
          } else if (_userId!.isEmpty) {
            Fluttertoast.showToast(msg: 'UserId is Empty');
          } else {
            if (_typeMovie == null) {
              _typeMovie = '';
            } else {
              _typeMovie = await _typeMovie;
            }
            if (_typeMovie == null) {
              _typeMovie = '';
            } else {
              _typeMovie = await _typeMovie;
            }
            if (_titleOFvideo == null) {
              _titleOFvideo = '';
            } else {
              _titleOFvideo = await _titleOFvideo;
            }
            try {
              setState(() {
                _loading = true;
              });
              var uuid = const Uuid().v4();

              if (_uploadToProfile == true) {
                if (_typeMovie == 'Drama') {
                  DatabaseServices.uploadToProfile(
                      _userId!,
                      uuid,
                      _description!,
                      _videoURL!,
                      _titleOFvideo!,
                      _typeMovie!,
                      _thumbnailURL!,
                      1,
                      0,
                      resultTags,
                      _trailer!,
                      imdbRating!,
                      0,
                      0);
                } else if (_typeMovie == 'Series') {
                  setState(() {
                    _loading = true;
                  });
                  DatabaseServices.uploadToProfile(
                      _userId!,
                      uuid,
                      _description!,
                      _videoURL!,
                      _titleOFvideo!,
                      _typeMovie!,
                      _thumbnailURL!,
                      0,
                      1,
                      resultTags,
                      _trailer!,
                      imdbRating!,
                      0,
                      0);
                  setState(() {
                    _loading = false;
                  });
                } else if (_typeMovie == 'Movie') {
                  setState(() {
                    _loading = true;
                  });
                  DatabaseServices.uploadToProfile(
                      _userId!,
                      uuid,
                      _description!,
                      _videoURL!,
                      _titleOFvideo!,
                      _typeMovie!,
                      _thumbnailURL!,
                      0,
                      0,
                      resultTags,
                      _trailer!,
                      imdbRating!,
                      0,
                      0);
                  setState(() {
                    _loading = false;
                  });
                }
              }
              if (_uploadToNewMovies == true) {
                if (_typeMovie == 'Drama') {
                  setState(() {
                    _loading = true;
                  });
                  DatabaseServices.uploadToNewMovies(
                      _userId!,
                      uuid,
                      _description!,
                      _videoURL!,
                      _titleOFvideo!,
                      _typeMovie!,
                      _thumbnailURL!,
                      1,
                      0,
                      resultTags,
                      _trailer!,
                      imdbRating!,
                      0,
                      0);
                  setState(() {
                    _loading = false;
                  });
                } else if (_typeMovie == 'Series') {
                  setState(() {
                    _loading = true;
                  });
                  DatabaseServices.uploadToNewMovies(
                      _userId!,
                      uuid,
                      _description!,
                      _videoURL!,
                      _titleOFvideo!,
                      _typeMovie!,
                      _thumbnailURL!,
                      0,
                      1,
                      resultTags,
                      _trailer!,
                      imdbRating!,
                      0,
                      0);
                  setState(() {
                    _loading = false;
                  });
                } else if (_typeMovie == 'Movie') {
                  setState(() {
                    _loading = true;
                  });
                  DatabaseServices.uploadToNewMovies(
                      _userId!,
                      uuid,
                      _description!,
                      _videoURL!,
                      _titleOFvideo!,
                      _typeMovie!,
                      _thumbnailURL!,
                      0,
                      0,
                      resultTags,
                      _trailer!,
                      imdbRating!,
                      0,
                      0);
                  setState(() {
                    _loading = false;
                  });
                }
              }
              if (_uploadToFollowersTimeline == true) {
                setState(() {
                  _loading = true;
                });
                DatabaseServices.uploadToFollowersTimeline(
                    _userId!,
                    uuid,
                    _description!,
                    _videoURL!,
                    _titleOFvideo!,
                    _typeMovie!,
                    _thumbnailURL!,
                    1,
                    0,
                    resultTags,
                    _trailer!,
                    imdbRating!,
                    0,
                    0);
                setState(() {
                  _loading = false;
                });
              } else if (_typeMovie == 'Series') {
                setState(() {
                  _loading = true;
                });
                DatabaseServices.uploadToFollowersTimeline(
                    _userId!,
                    uuid,
                    _description!,
                    _videoURL!,
                    _titleOFvideo!,
                    _typeMovie!,
                    _thumbnailURL!,
                    0,
                    1,
                    resultTags,
                    _trailer!,
                    imdbRating!,
                    0,
                    0);
                setState(() {
                  _loading = false;
                });
              } else if (_typeMovie == 'Movie') {
                setState(() {
                  _loading = true;
                });
                DatabaseServices.uploadToFollowersTimeline(
                    _userId!,
                    uuid,
                    _description!,
                    _videoURL!,
                    _titleOFvideo!,
                    _typeMovie!,
                    _thumbnailURL!,
                    0,
                    0,
                    resultTags,
                    _trailer!,
                    imdbRating!,
                    0,
                    0);
                setState(() {
                  _loading = false;
                });
              } else {
                Fluttertoast.showToast(msg: 'no selected any options');
              }
              setState(() {
                _loading = false;
              });
            } catch (e) {
              Fluttertoast.showToast(msg: "$e", backgroundColor: errorColor);
            }
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: moviePageColor.withOpacity(0.8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _loading ? "Uploading..." : 'Upload to Cloud',
                style: GoogleFonts.barlow(),
              ),
              SizedBox(
                width: 3,
              ),
              Icon(
                CupertinoIcons.upload_circle,
                size: 16,
              )
            ],
          ),
        ),
      );
    }
  }
}
