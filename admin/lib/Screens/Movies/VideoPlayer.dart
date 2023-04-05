import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Screens/Movies/Comment/comment.dart';
import 'package:admin/Screens/Movies/OtherParts.dart';
import 'package:admin/Services/Database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pod_player/pod_player.dart';
import 'package:uuid/uuid.dart';

class VideoPlayer extends StatefulWidget {
  final PostModel postModel;
  final String currentUserId;
  final commentCount;
  final bool isFromEpisode;
  final episodeLink;
  const VideoPlayer(
      {required this.postModel,
      required this.currentUserId,
      this.commentCount,
      required this.isFromEpisode,
      this.episodeLink})
      : super();

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  int _likes = 0;
  var key;
  var uuid = Uuid().v4();
  getLikesCount() async {
    int likesCount = await DatabaseServices.getPostLikes(widget.postModel.id);
    if (mounted) {
      setState(() {
        _likes = likesCount;
      });
    }
  }

  bool _loading = false;
  List<PostModel> _otherEpisodes = [];
  getSeries() async {
    setState(() {
      _loading = true;
    });
    List<PostModel> otherSeries =
        await DatabaseServices.getOtherEpisodes(widget.postModel);
    if (mounted) {
      setState(() {
        _otherEpisodes = otherSeries.toList();
        print(_otherEpisodes.length);
        _loading = false;
      });
    }
  }

  String nextVideo = '';
  PodPlayerController? _controller;
  @override
  void initState() {
    if (widget.isFromEpisode) {
      _controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.network(
          widget.episodeLink,
        ),
      )..initialise();
    } else {
      nextVideo = widget.postModel.video;

      _controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.network(
          nextVideo,
        ),
      )..initialise();
    }

    super.initState();
    print("URI: $nextVideo");
    if (widget.postModel.type == 'Drama') {
      getSeries();
    } else {
      print("isn't Drama");
    }
    getLikesCount();

    numberOfSeries = widget.postModel.episode;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  int numberOfSeries = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appBarColor,
      appBar: AppBar(
        actions: [
          widget.postModel.type == 'Drama'
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      numberOfSeries.toString(),
                      style: GoogleFonts.barlow(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
        backgroundColor: appBarColor.withOpacity(0.2),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        title: Text(widget.postModel.title),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, top: 1),
            child: PodVideoPlayer(
              backgroundColor: shadowColor,
              controller: _controller!,
              alwaysShowProgressBar: true,
              videoTitle: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.postModel.title,
                  style: GoogleFonts.firaSans(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
              ),
              videoThumbnail: DecorationImage(
                /// load from asset: AssetImage('asset_path')
                image: NetworkImage(
                  widget.postModel.thumbnail,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: shadowColor.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Like
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: shadowColor.withOpacity(0.1)),
                            child: Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _likes.toString(),
                            style: GoogleFonts.barlow(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Comment
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller!.pause();
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: Comments(
                                      currentUserId: widget.currentUserId,
                                      postModel: widget.postModel,
                                    )));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: shadowColor.withOpacity(0.1)),
                            child: const Icon(
                              CupertinoIcons.chat_bubble,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            widget.commentCount.toString(),
                            style: GoogleFonts.barlow(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Report
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: shadowColor.withOpacity(0.1)),
                              child: const Icon(
                                CupertinoIcons.info,
                                size: 24,
                                color: Colors.white,
                              )),
                        ),
                        Text(
                          'Report',
                          style: GoogleFonts.barlow(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ]),
          ),
          const Divider(
            color: Colors.white,
            indent: 5,
            endIndent: 5,
          ),
          widget.postModel.type == 'Drama'
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Episodes',
                        style: GoogleFonts.lato(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'See All',
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white54),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
          // if video is drama part appear here
          if (widget.postModel.type != 'Drama')
            const SizedBox()
          else
            _otherEpisodes.isEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.only(top: 18.0, left: 8, right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: shadowColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text(
                        "هێشتاهیچ زنجیرەیەکی تربەردەست نیە",
                        style: GoogleFonts.barlow(
                            color: Colors.white, fontSize: 20),
                      )),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 4, left: 4),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _otherEpisodes == 0
                          ? const SizedBox()
                          : Row(
                              children:
                                  List.generate(_otherEpisodes.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      nextVideo = _otherEpisodes[index].video;
                                      _controller!.changeVideo(
                                          playVideoFrom:
                                              PlayVideoFrom.network(nextVideo));
                                      getSeries();
                                      numberOfSeries =
                                          _otherEpisodes[index].episode;
                                      getLikesCount();
                                    });
                                  },
                                  child: OtherParts(
                                    numberOfSeries: numberOfSeries,
                                    postModel: _otherEpisodes[index],
                                  ),
                                );
                              }),
                            ),
                    ),
                  ),
        ],
      ),
    );
  }
}
