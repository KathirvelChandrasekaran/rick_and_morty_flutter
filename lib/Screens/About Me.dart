import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatelessWidget {
  _launchGitHub() async {
    const git = "https://github.com/KathirvelChandrasekaran";
    if (await canLaunch(git))
      await launch(git);
    else
      throw 'Could not launch $git';
  }

  _launchLinkedin() async {
    const linkedin = "https://www.linkedin.com/in/kathirvel-chandrasekaran/";
    if (await canLaunch(linkedin))
      await launch(linkedin);
    else
      throw 'Could not launch $linkedin';
  }

  _launchSourceCode() async {
    const git = "https://github.com/KathirvelChandrasekaran/rick_and_morty_flutter";
    if (await canLaunch(git))
      await launch(git);
    else
      throw 'Could not launch $git';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Container(
          // color: Colors.black,
          width: MediaQuery.of(context).size.width * 0.65,
          margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
          child: Column(
            children: [
              Card(
                elevation: 18,
                shape: CircleBorder(),
                child: CircleAvatar(
                  maxRadius: 75,
                  backgroundImage: AssetImage('images/Me.jpg'),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Kathirvel Chandrasekaran",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _launchGitHub,
                    child: CircleAvatar(
                      maxRadius: 30,
                      backgroundImage: AssetImage('images/github.png'),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    onTap: _launchLinkedin,
                    child: Image.asset(
                      'images/linkedin.png',
                      width: 70,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                color: Colors.black38,
              ),
              SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: _launchSourceCode,
                child: Container(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: 70,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      'Source code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
