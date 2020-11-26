import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty/Utils/colors.dart';

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
  var refreshkey = GlobalKey<RefreshIndicatorState>();

  int checkCount(pageCount) {
    return pageCount <= 0 ? pageCount = 1 : pageCount;
  }

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
    this.checkConnectivity();
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi))
      this.fetchLocation(this.webURL);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Location',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: pageColor,
      body: locationBody(),
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
                    fetchLocation(
                        "https://rickandmortyapi.com/api/location/?page=$pageCount");
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
                    fetchLocation(
                        "https://rickandmortyapi.com/api/location/?page=$pageCount");
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
      this.fetchLocation(webURL);
      pageCount = 1;
    });
  }

  Widget locationBody() {
    if (location.contains(null) || location.length < 0 || loading) {
      return Center(
        child: SpinKitDoubleBounce(
          color: Colors.black,
          size: 125,
        ),
      );
    }
    return SafeArea(
      child: RefreshIndicator(
        child: ListView.builder(
            controller: _controller,
            itemCount: location.length,
            itemBuilder: (context, index) {
              return locationCard(location[index]);
            }),
        onRefresh: refreshlist,
      ),
    );
  }

  Widget locationCard(index) {
    var name = index['name'];
    var type = index['type'];
    var dimension = index['dimension'];
    List residents = index['residents'];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          color: cardColor,
          child: Container(
            margin: EdgeInsets.all(20.0),
            height: 155.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(name,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
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
                    SizedBox(
                      height: 10,
                    ),
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
                    SizedBox(
                      height: 10,
                    ),
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
