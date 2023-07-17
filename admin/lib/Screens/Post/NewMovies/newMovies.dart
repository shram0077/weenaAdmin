import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Screens/Users/widget.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/widgets/PostCard.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  bool isSearching = false;
  final _searchController = TextEditingController();
  Future<QuerySnapshot>? _movies;

  buildSearchField() {
    return Container(
      padding: const EdgeInsets.only(left: 8, bottom: 3),
      width: 300,
      height: 45,
      decoration: BoxDecoration(
          color: Colors.white54, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        onChanged: (input) {
          print(input);
          setState(() {
            _searchController.text;
            _movies = DatabaseServices.searchPosts(
              input,
            );
            print(_movies.toString());
          });
        },
        decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: _searchController.text.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _movies = null;
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
            // ignore: unnecessary_const
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 238, 238, 238)),
            border: InputBorder.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: buildSearchField(),
      ),
      backgroundColor: appBarColor,
      body: _searchController.text.isEmpty
          ? ListView(
              children: [
                Divider(
                  color: whiteColor,
                  endIndent: 11,
                  indent: 11,
                ),
                GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 500,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1),
                    itemCount: _newMovies.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return PostCard(postModel: _newMovies[index]);
                    }),
              ],
            )
          : FutureBuilder(
              future: _movies,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No Movies found!',
                            style: GoogleFonts.alef(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black)),
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: circularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      PostModel postModel =
                          PostModel.fromDoc(snapshot.data.docs[index]);
                      return buildPostCard(
                        postModel,
                      );
                    });
              }),
    );
  }
}
