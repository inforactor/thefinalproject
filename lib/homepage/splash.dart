/*import 'dart:async';

import 'package:flutter/material.dart';
import 'homepge.dart';
import 'login_window.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 3), _handleTapEvent);
    return new Scaffold(
      key: globalKey,
      body: _splashContainer(),
    );
  }
//------------------------------------------------------------------------------
  Widget _splashContainer() {
    return GestureDetector(
        onTap: _handleTapEvent,
        child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: new BoxDecoration(color: Colors.blue[400]),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Container(
                    child: new Image(
                      height: 200.0,
                      width: 200.0,
                      image: new AssetImage("assets/images/ic_launcher.png"),
                      fit: BoxFit.fill,
                    )),
                new Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: new Text(
                    "Flutter Client Php Backend",
                    style: new TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ),
              ],
            )));
  }
//------------------------------------------------------------------------------
  void _handleTapEvent() async {
   bool isLoggedIn = await SharedPreferences.isUserLoggedIn();
    if (this.mounted) {
      setState(() /*{
       if (isLoggedIn != null && isLoggedIn) {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new HomePage()),
          );
        } */else {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new Login()),
          );
        }
      });
    }
  }
//------------------------------------------------------------------------------
}*/