import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/widgets/PostCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class Dramas extends StatefulWidget {
  static const String id = 'dramas';

  @override
  State<Dramas> createState() => _DramasState();
}

class _DramasState extends State<Dramas> {
  List<PostModel> _drama = [];
  bool _resreshing = false;
  getNewovies() async {
    setState(() {
      _resreshing = true;
    });
    List<PostModel> dramasPost = await DatabaseServices.getNewMovies();
    if (mounted) {
      setState(() {
        _drama = dramasPost.toList();
        _drama =
            dramasPost.where((element) => element.type == 'Drama').toList();

        _resreshing = false;
      });
      print("Drama Count: ${_drama.length}");
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
              'Dramas',
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
          _drama.length == 0
              ? Center(
                  child: Text(
                  'no have any Dramas yet!',
                  style: GoogleFonts.barlow(
                      color: errorColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ))
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1),
                  itemCount: _drama.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return PostCard(postModel: _drama[index]);
                  }),
        ],
      ),
    );
  }
}
