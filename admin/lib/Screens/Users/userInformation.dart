import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/userModel.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserInformation extends StatefulWidget {
  final String visitedUserId;

  const UserInformation({key, required this.visitedUserId});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  dynamic username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          "about $username",
          style: GoogleFonts.barlow(color: whiteColor),
        ),
        leading: BackButton(color: whiteColor),
      ),
      body: StreamBuilder(
          stream: usersRef.doc(widget.visitedUserId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: Center(child: circularProgressIndicator()),
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

            UserModell userModel = UserModell.fromDoc(snapshot.data);
            username = userModel.username;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: moviePageColor.withOpacity(0.8)),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            MyEncriptionDecription.decryptWithAESKey(
                                userModel.profilePicture),
                          ),
                          backgroundColor: profileBGcolor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          MyEncriptionDecription.decryptWithAESKey(
                              userModel.email),
                          style: GoogleFonts.barlow(
                              color: whiteColor, fontSize: 18),
                        ),
                        Spacer(),
                        Text(
                          userModel.admin == true ? "Admin" : "",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold, color: whiteColor),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4, top: 4),
                    child: ListTile(
                      leading: Icon(
                        Icons.admin_panel_settings_outlined,
                        color: whiteColor,
                      ),
                      tileColor: moviePageColor.withOpacity(0.7),
                      title: Text(
                        "Admin",
                        style: GoogleFonts.barlow(color: whiteColor),
                      ),
                      trailing: CupertinoSwitch(
                        value: userModel.admin,
                        onChanged: (value) {
                          if (userModel.admin = true) {
                            usersRef.doc(userModel.id).update({"admin": value});
                          } else if (userModel.admin = false) {
                            usersRef.doc(userModel.id).update({"admin": value});
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4, top: 4),
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.checkmark_circle,
                        color: whiteColor,
                      ),
                      tileColor: moviePageColor.withOpacity(0.7),
                      title: Text(
                        "verification",
                        style: GoogleFonts.barlow(color: whiteColor),
                      ),
                      trailing: CupertinoSwitch(
                        value: userModel.verification,
                        onChanged: (value) {
                          if (userModel.verification = true) {
                            usersRef
                                .doc(userModel.id)
                                .update({"verification": value});
                          } else if (userModel.admin = false) {
                            usersRef
                                .doc(userModel.id)
                                .update({"verification": value});
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0, right: 4, top: 4),
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.time,
                        color: whiteColor,
                      ),
                      tileColor: moviePageColor.withOpacity(0.7),
                      title: Text(
                        "Joined",
                        style: GoogleFonts.barlow(color: whiteColor),
                      ),
                      trailing: Text(
                        DateFormat.yMMMMd().format(
                          userModel.joinedAt.toDate(),
                        ),
                        style: GoogleFonts.barlow(
                            color: whiteColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0, right: 4, top: 4),
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.calendar_circle,
                        color: whiteColor,
                      ),
                      tileColor: moviePageColor.withOpacity(0.7),
                      title: Text(
                        "Birthday",
                        style: GoogleFonts.barlow(color: whiteColor),
                      ),
                      trailing: Text(
                        DateFormat.yMMMMd().format(
                          userModel.birthday.toDate(),
                        ),
                        style: GoogleFonts.barlow(
                            color: whiteColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0, right: 4, top: 4),
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.calendar_circle,
                        color: whiteColor,
                      ),
                      tileColor: moviePageColor.withOpacity(0.7),
                      title: Text(
                        "Gender",
                        style: GoogleFonts.barlow(color: whiteColor),
                      ),
                      trailing: Text(
                        userModel.gender,
                        style: GoogleFonts.barlow(
                            color: whiteColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
