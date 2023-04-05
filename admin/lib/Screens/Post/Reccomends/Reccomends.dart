import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/widgets/PostCard.dart';
import 'package:admin/widgets/PostConatiner.dart';
import 'package:admin/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Reccomends extends StatefulWidget {
  static const String id = 'reccomends';

  @override
  State<Reccomends> createState() => _ReccomendsState();
}

class _ReccomendsState extends State<Reccomends> {
  bool _resreshing = false;
  List<PostModel> _recommended = [];
  List<PostModel> _userId = [];
  getRecommendedPost() async {
    setState(() {
      _resreshing = true;
    });
    List<PostModel> recommendedPosts =
        await DatabaseServices.getRecommendedPost();
    if (mounted) {
      setState(() {
        _recommended = recommendedPosts.toList();
        _userId =
            _recommended.where((element) => element.userId.isNotEmpty).toList();
        print(_userId.length);
        _resreshing = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecommendedPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      body: ListView(
        children: [
          Center(
            child: Text(
              'Reccomends',
              style: GoogleFonts.roboto(
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.5),
            ),
          ),
          Divider(
            color: whiteColor,
            endIndent: 11,
            indent: 11,
          ),
          GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 500,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1),
              itemCount: _recommended.length,
              itemBuilder: (BuildContext ctx, index) {
                return PostCard(postModel: _recommended[index]);
              }),
        ],
      ),
    );
  }
}
