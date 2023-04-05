import 'package:admin/Constant/constant.dart';
import 'package:admin/Services/Auth.dart';
import 'package:admin/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String _email;
  late String _password;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  bool _isError = false;
  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Please enter valid email';
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        body: ListView(children: [
          SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "WEENA-Admin Panel",
                        style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.w900,
                            color: _isError ? errorColor : whiteColor),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 5,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/images/weena.png',
                              ),
                              fit: BoxFit.cover)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 2),
                              child: Text(
                                'Email',
                                style: GoogleFonts.barlow(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          elevation: 1,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 5),
                                child: TextFormField(
                                  style: GoogleFonts.lato(),
                                  onChanged: (value) {
                                    _email = value;
                                  },
                                  validator: validateEmail,
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email',
                                    hintStyle: GoogleFonts.lato(fontSize: 14),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 2),
                              child: Text(
                                'Password',
                                style: GoogleFonts.barlow(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          elevation: 1,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 5),
                                child: TextFormField(
                                  style: GoogleFonts.lato(),
                                  onChanged: (value) {
                                    _password = value;
                                  },
                                  validator: (input) => input!.trim().length < 8
                                      ? 'Please enter valid password'
                                      : null,
                                  obscureText:
                                      _obscureText == true ? true : false,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your Password',
                                    hintStyle: GoogleFonts.lato(fontSize: 14),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 4.0, top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "note: only the admin's can sign in",
                                style: GoogleFonts.roboto(
                                    color: errorColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (_obscureText == true) {
                                      setState(() {
                                        _obscureText = false;
                                      });
                                    } else if (_obscureText == false) {
                                      setState(() {
                                        _obscureText = true;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    _obscureText
                                        ? CupertinoIcons.eye_slash_fill
                                        : CupertinoIcons.eye,
                                    color: _obscureText
                                        ? errorColor
                                        : Colors.white,
                                  ))
                            ],
                          ),
                        ),
                        Center(
                          child: _isLoading
                              ? circularProgressIndicator()
                              : Container(
                                  width: 300,
                                  padding: const EdgeInsets.only(
                                      top: 3, left: 3, bottom: 3, right: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: const Border(
                                        bottom: BorderSide(color: Colors.white),
                                        top: BorderSide(color: Colors.white),
                                        left: BorderSide(color: Colors.white),
                                        right: BorderSide(color: Colors.white),
                                      )),
                                  child: MaterialButton(
                                    color: moviePageColor,
                                    minWidth: double.infinity,
                                    height: 50,
                                    onPressed: login,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))
        ]));
  }

  login() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        bool isValid = await AuthService.login(_email, _password, context);
        if (isValid) {
          // ignore: use_build_context_synchronously
          setState(() {
            Navigator.pushNamed(
              context,
              "/feed",
            );
          });
        } else {
          setState(() {
            _isError = true;
          });
          _isLoading = false;
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('This Error$e');
    }
  }
}
