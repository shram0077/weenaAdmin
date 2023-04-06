import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/widgets/PostCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class NewMovies extends StatefulWidget {
  static const String id = 'newMovies';

  @override
  State<NewMovies> createState() => _NewMoviesState();
}

class _NewMoviesState extends State<NewMovies> {
  List<PostModel> _newMovies = [];
  bool _resreshing = false;
  getNewovies() async {
    setState(() {
      _resreshing = true;
    });
    List<PostModel> recommendedPosts = await DatabaseServices.getNewMovies();
    if (mounted) {
      setState(() {
        _newMovies = recommendedPosts.toList();

        _resreshing = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      body: ListView(
        children: [
          Center(
            child: Text(
              'New Movies',
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
              itemCount: _newMovies.length,
              itemBuilder: (BuildContext ctx, index) {
                return PostCard(postModel: _newMovies[index]);
              }),
        ],
      ),
    );
  }
}
