import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/Screens/HomeScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Center(
          child: SpinKitDoubleBounce(
            color: Colors.greenAccent,
            size: 125,
          ),
        ),
        backgroundColor: Colors.black,
        duration: 2000,
        nextScreen: HomeScreen(),
      ),
    ));
