import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase/homeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
class VerificationScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return VerificationScreenState();
  }
}
class VerificationScreenState extends State<VerificationScreen>{
  var auth=FirebaseAuth.instance.currentUser;
  Timer timer;
  @override
  void initState() {
    auth.sendEmailVerification();
    timer=Timer.periodic(Duration(seconds: 5), (timer) {
     setState(() {
       checkEmailVerification();
     });
    });

    super.initState();
  }
  void dispose(){
    super.dispose();
    timer.cancel();
   }
  Future<void> checkEmailVerification()async{
    auth=FirebaseAuth.instance.currentUser;
    await auth.reload();
    if(auth.emailVerified){
      timer.cancel();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
           return  HomeScreen();
      }));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Verification Link has been sent to ${FirebaseAuth.instance.currentUser.email} ,please verify !'
                ,textAlign: TextAlign.center,style: GoogleFonts.fingerPaint(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("You will redirected after Verification",style: GoogleFonts.oregano(
                color: Colors.white54,
                fontSize: 25
              ),textAlign: TextAlign.center,),
            ),
          ],
        ),
      )
    );
  }
}