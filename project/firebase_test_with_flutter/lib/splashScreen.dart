import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase/homeScreen.dart';
import 'package:flutter_app_firebase/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<Splash> {
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
  isVerified(){
    var auth=FirebaseAuth.instance.currentUser.emailVerified;
    return auth;
  }
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds:isLoggen()&&isVerified()?HomeScreen():Login(),
      backgroundColor: Colors.black,
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
      loaderColor: Colors.white,
      loadingText: Text("Connecting The Internet..",style: GoogleFonts.comingSoon(
          color: Colors.white,
          fontWeight:FontWeight.bold
      ),),
      onClick: (){
        isLoggen() && isVerified()?
        Navigator.of(context).pushNamedAndRemoveUntil('homeScreen', (route) => false):
        Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
      },
    );
  }
}