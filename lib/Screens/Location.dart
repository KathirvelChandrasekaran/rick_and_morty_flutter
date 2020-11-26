import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  List location = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdda3b2),
      body: LocationBody(),
    );
  }

  Widget LocationBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Text('Location', style: TextStyle(
          color: Colors.black
        ),),
      ),
    );
  }
}
