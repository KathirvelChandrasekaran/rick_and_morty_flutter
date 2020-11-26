import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

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


  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        pageCount <= 0 ? pageCount = 1 : pageCount;
        pageCount++;
        fetchEpisodes(
            "https://rickandmortyapi.com/api/episode/?page=$pageCount");
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        pageCount <= 0 ? pageCount = 1 : pageCount;
        pageCount--;
        fetchEpisodes(
            "https://rickandmortyapi.com/api/episode/?page=$pageCount");
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
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
      backgroundColor: Color(0xffffadc6),
      body: EpisodeBody(),
    );
  }

  Widget EpisodeBody() {
    if (episodes.contains(null) || episodes.length < 0 || loading) {
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
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            return EpisodeCard(episodes[index]);
          }),
    );
  }

  Widget EpisodeCard(index) {
    var name = index['name'];
    var air_date = index['air_date'];
    var episode = index['episode'];
    List characters = index['characters'];

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
                      Text("Air Date\t:\t",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      Text(air_date,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ]),
                    Row(children: [
                      Text("Episode\t:\t",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      Expanded(
                        child: Text(episode,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    Row(children: [
                      Text("Character count\t:\t",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      Text(characters.length.toString(),
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
