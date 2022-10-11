import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'display.dart';
import 'favourites.dart';
import 'myDrawer.dart';
import 'updateNote.dart';
import 'package:flutter_app_firebase/components/showLoading.dart';
class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}
class HomeState extends State<Home>
{
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
   String convertFromTimestamp(timeStamp){
    var dateFromTimeStamp=DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds*1000);
    return DateFormat("dd/MM/yyyy hh:mm a").format(dateFromTimeStamp);
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
        // backgroundColor: Colors.grey,
        drawer: AppDrawer(),
        // key: closingDrawerKey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
        onPressed: (){
          Navigator.of(context).pushNamed('addNote');
        },
        child: Icon(Icons.add,size: 30,color: Colors.black,)
      ),
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 30,
        shadowColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text('Notes',style: GoogleFonts.gochiHand(
          color: Colors.red,
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),),
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
                          Image.asset('images/logo/1.jpg',fit: BoxFit.fill,),
                        )
                    ),
                  ],
                );
              }
              if(snapshot.hasError)
                {
                  return Text("Error");
                }
              //no event
              return Text("");
            }
          ),
        ],
      ),
      body:FutureBuilder(
          future:noteRef.where('userid',isEqualTo: FirebaseAuth.instance.currentUser.uid).get() ,
          builder: (context,snapshot){
            if(snapshot.hasData){
              if(snapshot.data.docs.length==0){
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/carousel/13.jpg'),
                          fit: BoxFit.fill,
                        ),
                        color: Colors.black54,
                    ),
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/3),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        // Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     padding: EdgeInsets.symmetric(vertical: 30),
                        //     decoration: BoxDecoration(
                        //       color: Colors.black.withOpacity(.7),
                        //     ),
                        //     child:Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Icon(Icons.warning,size: 40,color: Colors.white,),
                        //         SizedBox(width: 20,),
                        //         Text("You haven't added notes yet",style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.center,),
                        //       ],
                        //     )
                        // ),
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 30),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                            ),
                            child: Text("Click To Add Notes",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                          ),
                          onTap: (){
                            Navigator.of(context).pushNamed('addNote');
                          },
                        )
                      ],
                    ),
                  ),
                );
              }else {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/carousel/12.jpg'),
                      fit: BoxFit.fill
                    )
                  ),
                  child:  ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, i) {
                        return
                          Dismissible(
                              background: Container(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(Icons.delete,size: 40,color: Colors.white,),
                                ),
                              ),
                              secondaryBackground: Container(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                color: Colors.orange,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.favorite,size: 40,color: Colors.white,),
                                ),
                              ),
                              key: UniqueKey(),
                              onDismissed: (direction) async {
                                if(direction==DismissDirection.startToEnd){
                                  if(snapshot.data.docs[i].data()['imageURL']!=null){
                                    await FirebaseStorage.instance
                                        .refFromURL(snapshot.data.docs[i].data()['imageURL'])
                                        .delete();
                                  }
                                  await FirebaseFirestore.instance.collection(
                                      'notes')
                                      .doc(snapshot.data.docs[i].id)
                                      .delete().then((value){
                                    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Note Deleted Successfully"),
                                      duration: Duration(seconds: 4),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.fixed,
                                      action: SnackBarAction(
                                        label: "Ok",
                                        textColor: Colors.white,
                                        onPressed: (){
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                      ),
                                    ));
                                  }).catchError((e){
                                    Text("Error : $e");
                                  });
                                  showLoading(context);
                                  Navigator.of(context).pop();
                                }
                                if(direction==DismissDirection.endToStart){
                                  var mynote= snapshot.data.docs[i].data()['note'],
                                      mytitle= snapshot.data.docs[i].data()['title'],
                                      myimage= snapshot.data.docs[i].data()['imageURL'],
                                      myuserid= snapshot.data.docs[i].data()['userid'],
                                      // mytimeCreated= convertFromTimestamp(snapshot.data.docs[i].data()['createdTime']);
                                      mytimeCreated= snapshot.data.docs[i].data()['createdTime'];

                                  await FirebaseFirestore.instance.collection('notes')
                                      .doc(snapshot.data.docs[i].id)
                                      .delete().then((value){
                                    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Note Added to Favourites Successfully"),
                                      duration: Duration(seconds: 4),
                                      backgroundColor: Colors.deepOrange,
                                      behavior: SnackBarBehavior.fixed,
                                      action: SnackBarAction(
                                        label: "Ok",
                                        textColor: Colors.black,
                                        onPressed: (){
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                      ),
                                    ));
                                  }).catchError((e){
                                    Text("Error : $e");
                                  });
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                                    return Favourites(
                                        note: mynote,
                                        title: mytitle,
                                        image: myimage,
                                        userid: myuserid,
                                        timeCreated1 : mytimeCreated
                                    );
                                  }), (route) => false);

                                }
                              },
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      ListTile(
                                        selectedTileColor: Colors.white,
                                        tileColor: Colors.blueGrey.withOpacity(0.1),
                                        title: Text("${snapshot.data.docs[i]
                                            .data()['title']}",
                                          overflow: TextOverflow.ellipsis,style: GoogleFonts.comingSoon(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        subtitle: Text("${convertFromTimestamp(snapshot.data.docs[i].data()['createdTime'])}",
                                          overflow: TextOverflow.ellipsis,style: GoogleFonts.adventPro(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        leading: snapshot.data.docs[i]
                                            .data()['imageURL'] != null ?
                                        Image.network("${snapshot.data.docs[i]
                                            .data()['imageURL']}", height: 50,
                                          width: 50,
                                          fit: BoxFit.fill,) :
                                        Image.asset('images/logo/3.jpg', height: 50,
                                          width: 50,
                                          fit: BoxFit.fill,),
                                        trailing: IconButton(
                                          icon: Icon(Icons.edit_outlined, size: 25,
                                            color: Colors.green,),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) {
                                                  return Update(
                                                      docid: snapshot.data.docs[i].id,
                                                      data: snapshot.data.docs[i].data());
                                                }));
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return Display(
                                                    data: snapshot.data.docs[i].data());
                                              }));
                                        },),
                                    ],
                                  ),
                                  (i+1)!=snapshot.data.docs.length ?
                                  Divider(
                                    height: 15,
                                    color: Colors.white,
                                    thickness: 2,
                                  )
                                      :
                                  Text("")
                                ],
                              )

                          );
                      }),
                );
              }
            }
            if(snapshot.hasError){
              return Text('Error');
            }
            // return showLoading(context);
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            );
          })
    );
  }
}
