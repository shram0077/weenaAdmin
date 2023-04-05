import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Dramas extends StatefulWidget {
  static const String id = 'dramas';

  @override
  State<Dramas> createState() => _DramasState();
}

class _DramasState extends State<Dramas> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Dramas"));
  }
}
