import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}
class HomeScreenState extends State<HomeScreen>{

  var currentUserName,currentUserImage,userDocID;
  var authEmail = FirebaseAuth.instance.currentUser.email;
  var userCollectionRef = FirebaseFirestore.instance.collection('users');
  //var userRef=FirebaseFirestore.instance.collection('users');
  getUserDocID() async {
    var uRefrernce = userCollectionRef.where('email',
        isEqualTo: FirebaseAuth.instance.currentUser.email);
    await uRefrernce.get().then((value) {
      value.docs.forEach((element) {
        userDocID = element.id;
      });
    });
    return userDocID;
  }

  getUserData()async{
    setState(()async {
      var currentuserEmail=FirebaseAuth.instance.currentUser.email;
      await userCollectionRef.where('email',isEqualTo:currentuserEmail).get().then((value){
        value.docs.forEach((element) {
          currentUserName=element.data()['username'];
          currentUserImage=element.data()['userImage'];
        });
      });
    });
  }
  @override
  void initState() {
    getUserData();
    super.initState();
  }
  var noteRef=FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // drawer: AppDrawer(),
      appBar: AppBar(
        // leadingWidth: 30,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title:IconButton(
          icon: Icon(Icons.notes_rounded,color: Colors.red,size: 25,),
          onPressed: (){
            Navigator.of(context).pushNamed('home');
          },
        ),
        actions: [
          FutureBuilder(
              future:userCollectionRef.where('email',isEqualTo: authEmail).get(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return Row(
                    children: [
                      Container(
                        width: 110,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(top: 25),
                          children: [
                            Text("${snapshot.data.docs[0].data()['username']!=null?snapshot.data.docs[0].data()['username']:""}",textAlign: TextAlign.center,overflow: TextOverflow.clip,style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),)
                          ],
                        ),
                      ),
                      SizedBox(width: 5,),
                      CircleAvatar(
                          child: Container(
                            height: 40,
                            width: 40,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(300)),
                              image: DecorationImage(
                                  image: AssetImage('images/icons/person.jpg'),
                                  fit: BoxFit.fitWidth
                              ),
                            ),
                            child:snapshot.data.docs[0].data()['userImage']!=null ?Image.network(snapshot.data.docs[0].data()['userImage'],fit: BoxFit.cover,):
                            Image.asset('images/logo/5.jpg',fit: BoxFit.fill,),
                          )
                      ),
                    ],
                  );
                }
                if(snapshot.hasError)
                {
                  return Text("Error");
                }
                // to no do anything
                return Text("");
              }
          ),
        ],
      ),
      body:  SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Carousel(
          boxFit: BoxFit.cover,
          autoplay: true,
          animationCurve: Curves.ease,
          animationDuration: Duration(seconds: 4),
          dotSize: 6.0,
          dotIncreasedColor: Color(0xFFFF335C),
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 10.0,
          showIndicator: false,
          indicatorBgPadding: 7.0,
          images: [
            Image.asset('images/carousel/01.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/02.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/03.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/04.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/05.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/07.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/09.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/10.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/16.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/21.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/23.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/24.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/25.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/26.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/27.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/28.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/29.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            Image.asset('images/carousel/30.jpg',fit: BoxFit.cover,filterQuality: FilterQuality.high,),
          ],
        ),
      ),

    );
  }
}