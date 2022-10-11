import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase/homeScreen.dart';
import 'package:flutter_app_firebase/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogged;
  bool isLoggen(){
    var currentUser=FirebaseAuth.instance.currentUser;
    if(currentUser != null){
      isLogged=true;
    }
    else
    {
      isLogged=false;
    }
    return isLogged;
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 10,
      navigateAfterSeconds:isLoggen()?HomeScreen():Login(),
      backgroundColor: Colors.lightBlue,
      title: new Text(
        'Welcome To Online Note Application',
        style: GoogleFonts.comicNeue(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          color: Colors.white,
        ),
        softWrap:true,
        textAlign: TextAlign.center,
      ),
      useLoader: true,
      loaderColor: Colors.grey,
      loadingText: Text("Hello Mahmoud${FirebaseAuth.instance.currentUser!=null?FirebaseAuth.instance.currentUser:"not Null"}",style: GoogleFonts.comingSoon(
        color: Colors.white,
        fontWeight:FontWeight.bold
      ),),
      onClick: (){
        Navigator.of(context).pushNamed('login');
      },
    );
  }
}