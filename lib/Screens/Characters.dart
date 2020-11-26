import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'package:expansion_card/expansion_card.dart';
import 'package:rick_and_morty/Utils/colors.dart';

class Character extends StatefulWidget {
  @override
  _CharacterState createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  List characters = [];
  bool loading = false;

  static int pageCount = 0;
  String webURL = "https://rickandmortyapi.com/api/character/?page=$pageCount";

  ScrollController _controller;

  var refreshkey = GlobalKey<RefreshIndicatorState>();

  int checkCount(pageCount) {
    return pageCount <= 0 ? pageCount = 1 : pageCount;
  }

  @override
  void initState() {
    _controller = ScrollController();
    checkConnectivity();
    super.initState();
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi))
      this.fetchCharacter(this.webURL);
    else
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 50,
              title: Text(
                "No internet connectivity 🤦‍♂️",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              content: Text(
                "Please connect the device to internet.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            );
          });
  }

  fetchCharacter(url) async {
    setState(() {
      loading = true;
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['results'];
      setState(() {
        characters = data;
        loading = false;
      });
    } else {
      print("Error");
      characters = [];
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Characters',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: pageColor,
      body: characterBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              onPressed: refreshlist,
              backgroundColor: Colors.black,
              heroTag: null,
              child: new Icon(
                Icons.refresh_outlined,
                color: Colors.white,
              )),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
              onPressed: () {
                if (_controller.offset <=
                        _controller.position.minScrollExtent &&
                    !_controller.position.outOfRange) {
                  setState(() {
                    pageCount = this.checkCount(pageCount);
                    pageCount--;
                    fetchCharacter(
                        "https://rickandmortyapi.com/api/character/?page=$pageCount");
                  });
                }
              },
              heroTag: null,
              backgroundColor: Colors.black,
              child: new Icon(
                Icons.arrow_left,
                color: Colors.white,
              )),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
              onPressed: () {
                if (_controller.offset <=
                        _controller.position.minScrollExtent &&
                    !_controller.position.outOfRange) {
                  setState(() {
                    pageCount = this.checkCount(pageCount);
                    pageCount++;
                    fetchCharacter(
                        "https://rickandmortyapi.com/api/character/?page=$pageCount");
                  });
                }
              },
              heroTag: null,
              backgroundColor: Colors.black,
              child: new Icon(
                Icons.arrow_right,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  Future<Null> refreshlist() async {
    refreshkey.currentState?.show(atTop: true);
    await Future.delayed(
        Duration(seconds: 0.5.toInt())); //wait here for 2 second
    setState(() {
      this.fetchCharacter(webURL);
      pageCount = 1;
    });
  }

  Widget characterBody() {
    if (characters.contains(null) || characters.length < 0 || loading) {
      return Center(
        child: SpinKitDoubleBounce(
          color: Colors.black,
          size: 125,
        ),
      );
    }
    return RefreshIndicator(
      child: ListView.builder(
        controller: _controller,
        itemCount: characters.length,
        itemBuilder: (context, index) {
          return characterCard(characters[index]);
        },
      ),
      onRefresh: refreshlist,
    );
  }

  Widget characterCard(index) {
    var name = index['name'];
    var imageURL = index['image'];
    var status = index['status'];
    var species = index['species'];
    var gender = index['gender'];
    var location = index['origin']['name'];
    List episodes = index['episode'];
    return Container(
      child: ExpansionCard(
        backgroundColor: pageColor,
        borderRadius: 20,
        title: Container(
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.elliptical(15, 15),
                        right: Radius.elliptical(15, 15)),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(imageURL),
                    )),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.5),
                ),
              ),
            ],
          ),
        ),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 140),
                    child: Text("Status \t:\t",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  Container(
                    child: Text(status,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 140),
                    child: Text("Species \t:\t",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  Container(
                    child: Expanded(
                      child: Text(species,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 140),
                    child: Text("Gender \t:\t",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  Container(
                    child: Text(gender,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 140),
                    child: Text("Location \t:\t",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  Container(
                    child: Expanded(
                      child: Text(location,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 140),
                    child: Text("Total Episodes \t:\t",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  Container(
                    child: Text(episodes.length.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
