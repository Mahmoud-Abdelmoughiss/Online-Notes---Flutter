import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
class AroundApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AroundAppState();
  }
}
class AroundAppState extends State<AroundApp>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        elevation: 30,
        shadowColor: Colors.red,
        title: Text('Around App',style: GoogleFonts.gochiHand(
            color: Colors.red,
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50,left: 10,bottom: 25),
                alignment: Alignment.topLeft,
                child: Text("Tips",style: GoogleFonts.alike(
                  color: Colors.teal,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),textAlign: TextAlign.left,),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                alignment: Alignment.topLeft,
                child: Text("- Pull The Note To Left For Adding To Your Favourites",style: GoogleFonts.alef(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.left,),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                alignment: Alignment.topLeft,
                child: Text("- Pull The Note To Right For Deleting.",style: GoogleFonts.alef(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.left,),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                alignment: Alignment.topLeft,
                child: Text("- Click The Note To Display Your Note In a Large Screen",style: GoogleFonts.alef(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.left,),
              ),
              Divider(
                color: Colors.yellow,
                thickness: 2,
              ),
              Container(
                padding: EdgeInsets.only(top: 20,left: 10,bottom: 25),
                alignment: Alignment.topLeft,
                child: Text("App Version",style: GoogleFonts.alike(
                    color: Colors.teal,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.left,),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                alignment: Alignment.topLeft,
                child: Text("- Version     1 . 0 . 1",style: GoogleFonts.alef(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.left,),
              ),
              Divider(
                color: Colors.yellow,
                thickness: 2,
              ),
              Container(
                padding: EdgeInsets.only(top: 20,left: 10,bottom: 25),
                alignment: Alignment.topLeft,
                child: Text("App Developer",style: GoogleFonts.alike(
                    color: Colors.teal,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.left,),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    FacebookButton(onPressed: ()async{
                     await  launch('https://www.facebook.com/profile.php?id=100010071751632');
                    }),

                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        width: MediaQuery.of(context).size.width/4*2,
                        child: Text("- Mahmoud Elsayed Abdel-Moughiss",style: GoogleFonts.alef(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,

                        ),
                      ),
                      onTap: ()async{
                        //face book url
                       await launch('https://www.facebook.com/profile.php?id=100010071751632');
                      },
                    )
                  ],
                )
              ),

            ],
          )
        ],
      ),
    );
  }
}