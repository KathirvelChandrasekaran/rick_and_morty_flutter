import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'package:expansion_card/expansion_card.dart';

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

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        pageCount <= 0 ? pageCount = 1 : pageCount;
        pageCount++;
        fetchCharacter(
            "https://rickandmortyapi.com/api/character/?page=$pageCount");
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        pageCount <= 0 ? pageCount = 1 : pageCount;
        pageCount--;
        fetchCharacter(
            "https://rickandmortyapi.com/api/character/?page=$pageCount");
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    super.initState();
    this.fetchCharacter(this.webURL);
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
      backgroundColor: Color(0xff764248),
      body: characterBody(),
    );
  }

  Widget characterBody() {
    if (characters.contains(null) || characters.length < 0 || loading) {
      return Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 125,
        ),
      );
    }
    return ListView.builder(
      controller: _controller,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return characterCard(characters[index]);
      },
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
    return ExpansionCard(
      backgroundColor: Color(0xff764248),
      borderRadius: 20,
      title: Container(
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
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
                    color: Colors.white,
                    letterSpacing: 1.5),
              ),
            ),
          ],
        ),
      ),
      children: <Widget>[
        Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 140),
                  child: Text("Status \t:\t",
                      style: TextStyle(fontSize: 20, color: Colors.white70)),
                ),
                Container(
                  child: Text(status,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 140),
                  child: Text("Species \t:\t",
                      style: TextStyle(fontSize: 20, color: Colors.white70)),
                ),
                Container(
                  child: Expanded(
                    child: Text(species,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
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
                      style: TextStyle(fontSize: 20, color: Colors.white70)),
                ),
                Container(
                  child: Text(gender,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 140),
                  child: Text("Location \t:\t",
                      style: TextStyle(fontSize: 20, color: Colors.white70)),
                ),
                Container(
                  child: Expanded(
                    child: Text(location,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
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
                      style: TextStyle(fontSize: 20, color: Colors.white70)),
                ),
                Container(
                  child: Text(episodes.length.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
