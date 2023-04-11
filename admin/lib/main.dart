import 'package:admin/Screens/Dashboard/dashboard.dart';
import 'package:admin/Screens/Post/Dramas/dramas.dart';
import 'package:admin/Screens/Login/login.dart';
import 'package:admin/Screens/Post/Explorer/explorer.dart';
import 'package:admin/Screens/Post/NewMovies/newMovies.dart';
import 'package:admin/Screens/Post/Reccomends/Reccomends.dart';
import 'package:admin/Screens/Reports/reports.dart';
import 'package:admin/Screens/Users/users.dart';
import 'package:admin/Screens/home.dart';
import 'package:admin/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyA9ph4887v67ixYAPkBuXHWZwaPIwMIhts",
    authDomain: "the-movies-and-drama.firebaseapp.com",
    databaseURL: "https://the-movies-and-drama-default-rtdb.firebaseio.com",
    projectId: "the-movies-and-drama",
    storageBucket: "the-movies-and-drama.appspot.com",
    messagingSenderId: "804288035758",
    appId: "1:804288035758:web:47863309c4600ceb05e63f",
    measurementId: "G-J7LFKZPPE4",
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/home": (BuildContext context) => Home(),
        Users.id: (context) => Users(),
        Dramas.id: (context) => Dramas(),
        Reccomends.id: (context) => Reccomends(),
        Dashboard.id: (context) => Dashboard(),
        Home.id: (context) => Home(),
        NewMovies.id: (context) => NewMovies(),
        Explorer.id: (context) => Explorer(),
        Reports.id: (context) => Reports(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Weena-Admin',
      home: AuthService.getScreenId(),
    );
  }
}
