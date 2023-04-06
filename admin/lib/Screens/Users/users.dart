import 'package:admin/Constant/constant.dart';
import 'package:admin/Screens/Users/UserProfile.dart';
import 'package:admin/Screens/Users/widget.dart';
import 'package:admin/Services/Database.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class Users extends StatefulWidget {
  static const String id = 'users';
  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  bool isSearching = false;
  final _searchController = TextEditingController();
  Future<QuerySnapshot>? _users;
  FirebaseAuth _auth = FirebaseAuth.instance;
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
            _users = DatabaseServices.searchUsers(
              input,
            );
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
                        _users = null;
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
          elevation: 0,
          title: buildSearchField(),
          centerTitle: true,
        ),
        backgroundColor: appBarColor,
        body: _searchController.text.isEmpty
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isSearching = false;
                  });
                },
                child: FutureBuilder(
                    future:
                        usersRef.orderBy('joinedAt', descending: true).get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 300.0),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                        );
                        // ignore: unrelated_type_equality_checks
                      } else if (snapshot == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 300.0),
                          child: Center(child: circularProgressIndicator()),
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
                      return ListView.builder(
                          shrinkWrap: false,
                          primary: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ListTile(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => UserProfile(
                                              email: snapshot.data.docs[index]
                                                  ['email'],
                                              bio: snapshot.data.docs[index]
                                                  ['bio'],
                                              username: snapshot
                                                  .data.docs[index]['username'],
                                              displayName: snapshot
                                                  .data.docs[index]['name'],
                                              country: snapshot.data.docs[index]
                                                  ['country'],
                                              cityortown: snapshot.data
                                                  .docs[index]['cityorTown'],
                                              coverPicture: snapshot.data
                                                  .docs[index]['coverPicture'],
                                              profilePicture:
                                                  snapshot.data.docs[index]
                                                      ['profilePicture'],
                                              verification: snapshot.data
                                                  .docs[index]['verification'],
                                              visitedUserId: snapshot
                                                  .data.docs[index]['id'],
                                            ))),
                                tileColor: moviePageColor.withOpacity(0.8),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                // ignore: prefer_const_constructors
                                trailing: Text(
                                    snapshot.data.docs[index]["id"] ==
                                            _auth.currentUser!.uid
                                        ? "Me"
                                        : "",
                                    style: GoogleFonts.roboto(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  snapshot.data.docs[index]['username'],
                                  style: GoogleFonts.roboto(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500),
                                ),
                                leading: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: profileBGcolor,
                                      borderRadius: BorderRadius.circular(3),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              MyEncriptionDecription
                                                  .decryptWithAESKey(snapshot
                                                          .data.docs[index]
                                                      ['profilePicture'])))),
                                ),
                                title: Text(
                                  snapshot.data.docs[index]['name'],
                                  style: GoogleFonts.barlow(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          });
                    }),
              )
            : searchResult(_users));
  }
}
