import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'display.dart';
class Favourites extends StatefulWidget{
  final note,title,image,userid,timeCreated1;
  Favourites({Key key,this.note,this.title,this.image,this.userid,this.timeCreated1}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FavouritesState();
  }
}
class FavouritesState extends State<Favourites>
{
  var note ,title,image,userid,timeCreated,userDocID;

  var noteFavouriteRef = FirebaseFirestore.instance.collection('favourites');
  String convertFromTimestamp(timeStamp){
    var dateFromTimeStamp=DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds*1000);
    return DateFormat("dd/MM/yyyy hh:mm a").format(dateFromTimeStamp);
  }

  setData(){
   setState(() {
     note=widget.note;
     title=widget.title;
     image=widget.image;
     userid=widget.userid;
     timeCreated=widget.timeCreated1;
   });
  }
  getFavouriteDocID() async {
    var noteFavouriteReference = noteFavouriteRef.where('userid',
        isEqualTo: FirebaseAuth.instance.currentUser.uid);
    await noteFavouriteReference.get().then((value) {
      value.docs.forEach((element) {
        userDocID = element.id;
      });
    });
    return userDocID;
  }
  addToFavourite()async{
    if(title!=null && note!=null) {
      await noteFavouriteRef.add({
        'title': title,
        'note': note,
        'imageURL': image,
        "userid": userid,
        'createdTime': timeCreated
      });
    }
  }
 @override
  void initState() {
  setState(() {
    setData();
    addToFavourite();
    // getFavouriteDocID();
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      // drawer: AppDrawer(),
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 30,
        shadowColor: Colors.white,
        title: Text('Favourite',style: GoogleFonts.gochiHand(
            color: Colors.red,
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.notes_outlined,size: 25,color: Colors.white,),
          onPressed: (){
            Navigator.of(context).pushNamed('home');
          },
        ),
      ),
      body: FutureBuilder(
        future: noteFavouriteRef.where("userid",isEqualTo: FirebaseAuth.instance.currentUser.uid).get(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            if(snapshot.data.docs.length != 0){
              return Container(
                decoration: BoxDecoration(
                  // color: Colors.black54,
                    image: DecorationImage(
                      image: AssetImage('images/carousel/14.jpg'),
                      fit: BoxFit.fill,
                    )
                ),
                child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context,i){
                      return  Column(
                        children: [
                          ListTile(
                            tileColor: Colors.black54,
                            title: Text("${snapshot.data.docs[i].data()['title']}",
                              overflow: TextOverflow.ellipsis,style: GoogleFonts.comingSoon(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                            subtitle: Text("${convertFromTimestamp(snapshot.data.docs[i].data()['createdTime'])}",
                              overflow: TextOverflow.ellipsis,style: GoogleFonts.adventPro(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                            leading: snapshot.data.docs[i].data()['imageURL'] != null ?
                            Image.network("${snapshot.data.docs[i].data()['imageURL']}", height: 50, width: 50, fit: BoxFit.fill,) :
                            Image.asset('images/logo/3.jpg', height: 50, width: 50, fit: BoxFit.fill,),
                            isThreeLine: false,
                            trailing: IconButton(
                              icon: Icon(Icons.delete_forever, size: 25,
                                color: Colors.red,),
                              onPressed: () async{
                                if(snapshot.data.docs[i].data()['imageURL']!=null){
                                  await FirebaseStorage.instance
                                      .refFromURL(snapshot.data.docs[i].data()['imageURL'])
                                      .delete();
                                }
                                await FirebaseFirestore.instance.collection(
                                    'favourites')
                                    .doc(snapshot.data.docs[i].id)
                                    .delete().then((value){
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                                        return Favourites();
                                      }), (route) => false);
                                  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Note Deleted Successfully"),
                                    duration: Duration(seconds: 4),
                                    backgroundColor: Colors.green,
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
                                Navigator.of(context).pushNamed('favourites');
                              },
                            ),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) {
                                          return Display( data: snapshot.data.docs[i].data());
                                        }), (route) => false);
                            },),
                          (i+1)!=snapshot.data.docs.length ?
                          Divider(
                            height: 15,
                            color: Colors.white,
                            thickness: 2,
                          ):Text("")
                        ],
                      );
                    }),
              );
            }
            else{
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                      // color: Colors.black54,
                      image: DecorationImage(
                          image: AssetImage('images/carousel/13.jpg'),
                          fit: BoxFit.fill,
                      )
                  ),
                  padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/3),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.7),
                          ),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline,size: 40,color: Colors.white,),
                              SizedBox(width: 20,),
                              Container(
                                child: Text("Pull the note left for adding favourites",
                                  style: TextStyle(color: Colors.white,fontSize: 20),
                                  textScaleFactor: .6,
                                ),
                              )
                            ],
                          )
                      ),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                            color: Colors.white54,
                          ),
                          child: Text("Add To Your Favourite",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                        ),
                        onTap: (){
                          Navigator.of(context).pushNamed('home');
                        },
                      )
                    ],
                  ),
                ),
              );
            }
          }
          if(snapshot.hasError){
            return Text("Error Occurs !");
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}

