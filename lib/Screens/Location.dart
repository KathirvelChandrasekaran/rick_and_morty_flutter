import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  List location = [];
  bool loading = false;

  static int pageCount = 1;
  String webURL = "https://rickandmortyapi.com/api/location/?page=$pageCount";

  ScrollController _controller;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        pageCount <= 0 ? pageCount = 1 : pageCount;
        pageCount++;
        fetchLocation(
            "https://rickandmortyapi.com/api/location/?page=$pageCount");
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        pageCount <= 0 ? pageCount = 1 : pageCount;
        pageCount--;
        fetchLocation(
            "https://rickandmortyapi.com/api/location/?page=$pageCount");
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    this.fetchLocation(webURL);
  }

  fetchLocation(url) async {
    setState(() {
      loading = true;
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['results'];
      setState(() {
        location = data;
        loading = false;
      });
    } else {
      loading = false;
      location = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdda3b2),
      body: LocationBody(),
    );
  }

  Widget LocationBody() {
    if (location.contains(null) || location.length < 0 || loading) {
      return Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 125,
        ),
      );
    }
    return SafeArea(
      child: ListView.builder(
          controller: _controller,
          itemCount: location.length,
          itemBuilder: (context, index) {
            return LocationCard(location[index]);
          }),
    );
  }

  Widget LocationCard(index) {
    var name = index['name'];
    var type = index['type'];
    var dimension = index['dimension'];
    List residents = index['residents'];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.pink,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 2.0, color: Colors.white))),
            margin: EdgeInsets.all(20.0),
            height: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ,letterSpacing: 2)),
                SizedBox(
                  height: 10.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Text("Type\t:\t",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      Text(type,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ]),
                    Row(children: [
                      Text("Dimension\t:\t",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      Expanded(
                        child: Text(dimension,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    Row(children: [
                      Text("Residents count\t:\t",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      Text(residents.length.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
