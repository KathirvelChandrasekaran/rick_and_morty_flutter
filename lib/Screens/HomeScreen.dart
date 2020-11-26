import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:rick_and_morty/Screens/Characters.dart';
import 'package:rick_and_morty/Screens/Episodes.dart';
import 'package:rick_and_morty/Screens/Location.dart';

Color c1 = Color(0xff764248);
Color c2 = Color(0xffdda3b2);
Color c3 = Color(0xffffadc6);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List colorList = [c1,c2,c3,];

  List screenList = [
    Character(),
    Location(),
    Episodes()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        animationDuration: Duration(milliseconds: 250),
        backgroundColor: colorList[currentIndex],
        selectedIndex: currentIndex,
        showElevation: false,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        curve: Curves.easeInOutSine,
        items: [
          BottomNavyBarItem(
            icon: Icon(
              Icons.face_outlined,
              color: c1,
              size: 30,
            ),
            title: Text('Characters'),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.location_city_outlined,
              size: 30,
              color: Color(0xff1b998b),
            ),
            title: Text('Location'),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.play_circle_fill_outlined,
              size: 30,
              color: Color(0xff1c3144),
            ),
            title: Text('Episodes'),
            activeColor: Colors.white,
          )
        ],
      ),
    );
  }
}
