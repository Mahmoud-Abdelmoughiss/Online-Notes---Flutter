import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_firebase/aroundApp.dart';
import 'package:flutter_app_firebase/favourites.dart';
import 'package:flutter_app_firebase/splashScreen.dart';
import './home.dart';
import './login.dart';
import './signUp.dart';
import 'addNote.dart';
import 'myDrawer.dart';
import 'updateNote.dart';
import 'homeScreen.dart';
void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: "Times New Roman"
      ),
      title: 'Online Note',
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      initialRoute:'splash',
      routes: {
        'splash':(context){
          return Splash();
        },
        'drawer':(context){
          return AppDrawer();
        },
        'favourites':(context){
          return Favourites();
        },
        'homeScreen':(context){
          return HomeScreen();
        },
        'home':(context){
          return Home();
        },
        'login':(context){
          return Login();
        },
        'signup':(context){
          return SignUp();
        },
        'addNote' : (context){
          return Add();
        },
        'update' : (context){
          return Update();
        },
        'aroundApp' : (context){
          return AroundApp();
        }
      },

    )
  );
}
