import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:rick_and_morty/Screens/About%20Me.dart';
import 'package:rick_and_morty/Screens/Characters.dart';
import 'package:rick_and_morty/Screens/Episodes.dart';
import 'package:rick_and_morty/Screens/Location.dart';
import 'package:rick_and_morty/Utils/colors.dart';

Color c4 = Colors.white;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List colorList = [pageColor, pageColor, pageColor, pageColor];

  List screenList = [Character(), Location(), Episodes(), AboutMe()];

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
              color: navItemColor,
              size: 30,
            ),
            title: Text(
              'Characters',
              style: TextStyle(
                fontFamily: 'Nunito',
              ),
            ),
            activeColor: navItemColor,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.location_city_outlined,
              size: 30,
              color: navItemColor,
            ),
            title: Text(
              'Location',
              style: TextStyle(
                fontFamily: 'Nunito',
              ),
            ),
            activeColor: navItemColor,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.play_circle_fill_outlined,
              size: 30,
              color: navItemColor,
            ),
            title: Text(
              'Episodes',
              style: TextStyle(
                fontFamily: 'Nunito',
              ),
            ),
            activeColor: navItemColor,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              size: 30,
              color: navItemColor,
            ),
            title: Text(
              'About Me',
              style: TextStyle(
                fontFamily: 'Nunito',
              ),
            ),
            activeColor: navItemColor,
          )
        ],
      ),
    );
  }
}
