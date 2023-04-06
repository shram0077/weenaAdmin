import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/widgets/PostCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class Explorer extends StatefulWidget {
  static const String id = 'exp';

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  List<PostModel> _explorer = [];
  bool _resreshing = false;
  getEXP() async {
    setState(() {
      _resreshing = true;
    });
    List<PostModel> exp = await DatabaseServices.getExplorerPost();
    if (mounted) {
      setState(() {
        _explorer = exp.toList();

        _resreshing = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEXP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      body: ListView(
        children: [
          Center(
            child: Text(
              "Explorer's",
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
              itemCount: _explorer.length,
              itemBuilder: (BuildContext ctx, index) {
                return PostCard(postModel: _explorer[index]);
              }),
        ],
      ),
    );
  }
}
