import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSeries extends StatefulWidget {
  final PostModel postModel;

  const AddSeries({key, required this.postModel});

  @override
  State<AddSeries> createState() => _AddSeriesState();
}

class _AddSeriesState extends State<AddSeries> {
  final sessionController = TextEditingController();
  final episodeController = TextEditingController();
  final videoUrlController = TextEditingController();
  final thumbnailController = TextEditingController();
  String? _session;
  String? _episode;
  String? videoURL;
  String? thumbnail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.postModel.title,
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: ListView(
          children: [
            Text(
              "Adding Episode or Session to ${widget.postModel.title}",
              style: GoogleFonts.barlow(color: Colors.black, fontSize: 19),
            ),
            Divider(
              thickness: 0.3,
              color: Colors.grey,
            ),
            Row(
              children: [
                Text(
                  'Session',
                  style: GoogleFonts.barlow(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.barlow(),
                  controller: sessionController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Session',
                  ),
                  onChanged: (value) {
                    _session = value;
                    setState(() {
                      sessionController;
                    });
                  },
                ),
              ),
            ),
            Divider(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Episode',
                  style: GoogleFonts.barlow(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.barlow(),
                  controller: episodeController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Episode',
                  ),
                  onChanged: (value) {
                    _episode = value;
                    setState(() {
                      episodeController;
                    });
                  },
                ),
              ),
            ),
            Divider(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Video',
                  style: GoogleFonts.barlow(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.barlow(),
                  controller: videoUrlController,
                  keyboardType: TextInputType.url,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Video URL',
                  ),
                  onChanged: (value) {
                    videoURL = value;
                    setState(() {
                      videoURL;
                    });
                  },
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'Thumbnail',
                  style: GoogleFonts.barlow(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.barlow(),
                  controller: thumbnailController,
                  keyboardType: TextInputType.url,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Thumbnail URL',
                  ),
                  onChanged: (value) {
                    thumbnail = value;
                    setState(() {
                      thumbnail;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () async {
                await postsRef
                    .doc(widget.postModel.userId)
                    .collection('userPosts')
                    .doc(widget.postModel.postuid)
                    .collection('sessions')
                    .doc(_session)
                    .set({'session': _session}).whenComplete(() async {
                  await postsRef
                      .doc(widget.postModel.userId)
                      .collection('userPosts')
                      .doc(widget.postModel.postuid)
                      .collection('sessions')
                      .doc(_session)
                      .collection('Videos')
                      .add({
                    "video": videoURL,
                    "episode": _episode,
                    "thumbnail": thumbnail
                  });
                });
              },
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  'Upload',
                  style: GoogleFonts.barlow(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
