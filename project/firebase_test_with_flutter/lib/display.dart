import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Display extends StatefulWidget{
  final data;
  Display({Key key,this.data}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return DisplayState();
  }
}
class DisplayState extends State<Display>{
  String convertFromTimestamp(timeStamp){
    var dateFromTimeStamp=DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds*1000);
    return DateFormat("dd/MM/yyyy hh:mm a").format(dateFromTimeStamp);
  }
  @override
  void initState() {
    //
    // SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //     onWillPop: () {
    //       return new Future(() => false);
    //     },
    //     child:Scaffold());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        tooltip: "Go Back To Home",
        child: IconButton(
          icon: Icon(Icons.home_rounded,color: Colors.red,),
          onPressed: (){
            Navigator.of(context).pushReplacementNamed('home');
          },
        ),
        onPressed: (){
          Navigator.of(context).pushReplacementNamed('home');
        },
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 30,
        shadowColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text('Dispaly the Note',style: GoogleFonts.gochiHand(
            color: Colors.red,
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
             // color: Colors.lightBlueAccent,
            ),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/carousel/15.jpg'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  ),
                  child: widget.data['imageURL']==null?
                  Image.asset('images/logo/3.jpg',fit: BoxFit.fill,):
                  Image.network(widget.data['imageURL'],fit: BoxFit.fitWidth,),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                      // color: Colors.redAccent.shade200,
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
                  ),
                  padding: EdgeInsets.only(top: 30,left: 20,right: 20,bottom: 20),
                  child: Text("${widget.data['title']}",style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                     // letterSpacing: 2
                  ),textAlign: TextAlign.center,),
                ),
                ///////////////////////////////////////////
                // Container(
                //   margin: EdgeInsets.only(top: 10,),
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //         // color: Colors.red,
                //         width: .5,
                //       ),
                //       // color: Colors.redAccent.shade200,
                //       color: Colors.black12,
                //   ),
                //   padding: EdgeInsets.all(0),
                //   child: Text("Created At : ${convertFromTimestamp(widget.data['createdTime'])}",style: GoogleFonts.sueEllenFrancisco(
                //     fontSize: 25,
                //     // fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //     // letterSpacing: 2
                //   ),textAlign: TextAlign.center,),
                // ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(color: Colors.red,width: 1),
                    borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))
                  ),
                  padding: EdgeInsets.only(top: 30,left: 20,right: 20,bottom: 20),
                  child: Text("${widget.data['note']}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      // letterSpacing: 1
                  ),textAlign: TextAlign.center,),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}