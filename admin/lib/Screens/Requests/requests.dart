import 'package:admin/Constant/constant.dart';
import 'package:admin/encryption_decryption/encryption.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Requests extends StatefulWidget {
  static const String id = 'requests';

  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Requests',
            style: GoogleFonts.barlow(color: whiteColor),
          ),
        ),
        body: FutureBuilder(
            future: requestsRef.orderBy('Timestamp', descending: false).get(),
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
                return Center(child: circularProgressIndicator());
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
                    String email = snapshot.data.docs[index]['Email'];
                    String username = snapshot.data.docs[index]['Username'];
                    String userId = snapshot.data.docs[index]['UserId'];
                    String displayName =
                        snapshot.data.docs[index]['Display Name'];
                    String country = snapshot.data.docs[index]["Country"];
                    String cityortown =
                        snapshot.data.docs[index]['City or town'];
                    String typOfRequest =
                        snapshot.data.docs[index]["Type of Request"];
                    Timestamp == snapshot.data.docs[index]["Timestamp"];

                    return Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.green[100],
                      shadowColor: Colors.blueGrey,
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.info_outline)),
                            leading:
                                Icon(Icons.album, color: Colors.cyan, size: 45),
                            title: Row(
                              children: [
                                Text(
                                  username,
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "-$cityortown",
                                  style: TextStyle(fontSize: 19),
                                ),
                                Spacer(),
                                Text(
                                  MyEncriptionDecription.decryptWithAESKey(
                                      email),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            subtitle: Text(typOfRequest),
                          ),
                        ],
                      ),
                    );
                  });
            }));
  }
}
