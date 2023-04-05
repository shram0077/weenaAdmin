import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class EditDramas extends StatefulWidget {
  final PostModel postModel;
  final String postID;
  const EditDramas({Key? key, required this.postModel, required this.postID})
      : super(key: key);

  @override
  State<EditDramas> createState() => _EditDramasState();
}

class _EditDramasState extends State<EditDramas> {
  List<PostModel> _allSeries = [];
  bool _loading = false;
  String? postID;
  getSeries() async {
    setState(() {
      _loading = true;
    });
    List<PostModel> otherSeries =
        await DatabaseServices.getOtherEpisodes(widget.postModel);
    if (mounted) {
      setState(() {
        _allSeries = otherSeries.toList();
      });
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSeries();
  }

  Future<void> refreshDatas() async {
    await getSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  getSeries();
                },
                icon: Icon(
                  Icons.refresh_outlined,
                  color: Colors.white,
                ))
          ],
          backgroundColor: appBarColor,
          elevation: 0,
          title: const Text("Edit drama's"),
          automaticallyImplyLeading: false,
          leading: BackButton(),
        ),
        body: _loading
            ? Center(
                child: circularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: refreshDatas,
                color: Colors.white,
                backgroundColor: moviePageColor,
                child: ListView(
                  children: [
                    GridView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 500,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1),
                        itemCount: _allSeries.length,
                        itemBuilder: (BuildContext context, int index) {
                          return detailCard(
                            _allSeries[index],
                          );
                        })
                  ],
                ),
              ));
  }

  detailCard(
    PostModel postModel,
  ) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(255, 114, 114, 114),
              spreadRadius: 0.5,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                widget.postModel.thumbnail,
              ),
              fit: BoxFit.cover),
          color: appcolor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(9)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              padding: const EdgeInsets.only(left: 8, top: 3, bottom: 2),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(9),
                      bottomLeft: Radius.circular(9)),
                  color: moviePageColor.withOpacity(0.9)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Episode ${postModel.episode}",
                    style: GoogleFonts.roboto(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {
                        deleteDrama(
                          postModel,
                        );
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              )),
        ],
      ),
    );
  }

  deleteDrama(
    PostModel postModel,
  ) async {
    await postsRef
        .doc(widget.postModel.userId)
        .collection("userPosts")
        .doc(widget.postID)
        .collection('otherSeries')
        .doc(postModel.postuid)
        .delete()
        .whenComplete(() {
      setState(() {
        getSeries();
        Fluttertoast.showToast(
            msg: 'Deleted', backgroundColor: appcolor, textColor: Colors.white);
      });
    });
  }
}
