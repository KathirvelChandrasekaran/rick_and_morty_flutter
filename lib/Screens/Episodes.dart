import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty/Utils/colors.dart';

class Episodes extends StatefulWidget {
  @override
  _EpisodesState createState() => _EpisodesState();
}

class _EpisodesState extends State<Episodes> {
  List episodes = [];
  bool loading = false;
  static int pageCount = 1;
  ScrollController _controller;
  String webURL = "https://rickandmortyapi.com/api/episode?page=$pageCount";
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
      this.fetchEpisodes(this.webURL);
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
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold),
              ),
              content: Text(
                "Please connect the device to internet.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontFamily: 'Nunito'),
              ),
            );
          });
  }

  fetchEpisodes(url) async {
    setState(() {
      loading = true;
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['results'];
      setState(() {
        loading = false;
        episodes = data;
      });
    } else {
      loading = true;
      episodes = [];
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
          'Episodes',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito'),
        ),
      ),
      backgroundColor: pageColor,
      body: episodeBody(),
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
                    fetchEpisodes(
                        "https://rickandmortyapi.com/api/episode/?page=$pageCount");
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
                    fetchEpisodes(
                        "https://rickandmortyapi.com/api/episode/?page=$pageCount");
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
      this.fetchEpisodes(webURL);
      pageCount = 1;
    });
  }

  Widget episodeBody() {
    if (episodes.contains(null) || episodes.length < 0 || loading) {
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
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              return episodeCard(episodes[index]);
            }),
        onRefresh: refreshlist,
      ),
    );
  }

  Widget episodeCard(index) {
    var name = index['name'];
    var airDate = index['air_date'];
    var episode = index['episode'];
    List characters = index['characters'];

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
              children: [
                Expanded(
                  child: Text(name,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontFamily: 'Nunito')),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Text("Air Date\t:\t",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Nunito')),
                      Text(airDate,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito')),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      Text("Episode\t:\t",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Nunito')),
                      Expanded(
                        child: Text(episode,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito')),
                      ),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      Text("Character count\t:\t",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Nunito')),
                      Text(characters.length.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito')),
                    ]),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
