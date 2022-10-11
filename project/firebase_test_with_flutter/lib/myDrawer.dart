import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app_firebase/homeScreen.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer> {
  var picked, file, ref, userImageurl, userRef, user, email, userDocID, currentUserImage;
  var authEmail = FirebaseAuth.instance.currentUser.email;
  var userCollectionRef = FirebaseFirestore.instance.collection('users');
  getUserDocID() async {
    var userReference = userCollectionRef.where('email',
        isEqualTo: FirebaseAuth.instance.currentUser.email);
    await userReference.get().then((value) {
      value.docs.forEach((element) {
        userDocID = element.id;
      });
    });
    return userDocID;
  }

  getCurrentUserImage() async {
    // YurP9ksxcaANaWHs2457
    setState(() async {
      await getUserDocID();
      if (userDocID != null) {
        await userCollectionRef.doc(userDocID).get().then((value) {
          currentUserImage = value.data()['userImage'];
        });
      } else {
        currentUserImage = "userDocID is null";
      }
    });
  }

  modalbottomsheet(context,imgUlr,documentId) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 190,
            color: Colors.white38,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Choose Image From :",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                InkWell(
                    onTap: () async {
                      picked = await ImagePicker()
                          .getImage(source: ImageSource.camera);
                      if (picked != null) {
                        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
                        ScaffoldMessenger.of(context).
                        showSnackBar(
                            SnackBar(
                              content: Text("Load the Image . . . ."),
                              duration: Duration(seconds: 5),
                              backgroundColor: Colors.orange,
                              action:SnackBarAction(
                                textColor: Colors.black,
                                label: "Ok",
                                onPressed: (){
                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                },
                              ) ,
                            ));
                       // Navigator.popAndPushNamed(context, 'home');
                        // Navigator.pop(context);
                        //Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
                        ///////////////delete image///////////////
                        if(imgUlr != null && imgUlr != "image url here"){
                          await FirebaseStorage.instance.refFromURL(imgUlr).delete();
                        }
                        //////////////end delete image/////////////////////////////////////
                        file = File(picked.path);
                        var rand = Random().nextInt(1000000);
                        var imageName = "$rand" + basename(picked.path);
                        ref =  FirebaseStorage.instance
                            .ref('userAccountPicture')
                            .child("$imageName");
                        await ref.putFile(file);
                        userImageurl = await ref.getDownloadURL();
                        /////////////////////////////////////////////////////////////////////////////
                        //userDocID = await getUserDocID();
                        userCollectionRef
                            .doc(documentId)
                            // .doc(documentId)
                            .update({
                          'userImage': userImageurl,
                        }).then((value) {
                              print("_____________________Hello_________________________________________");
                        }
                        ).catchError((e) {
                          print(
                              "_________________________________________________________________");
                          print("e: $e");
                        });
                        // Navigator.of(context).popAndPushNamed('home');
                        // Navigator.pushReplacementNamed(context, 'home');
                      }



                      //Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 20),
                      color: Colors.white60,
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    )),
                InkWell(
                    onTap: () async {
                      picked = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      if (picked != null) {
                        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
                        ScaffoldMessenger.of(context).
                        showSnackBar(
                            SnackBar(
                              content: Text("Load the Image . . . ."),
                              duration: Duration(seconds: 5),
                              backgroundColor: Colors.orange,
                              action:SnackBarAction(
                                textColor: Colors.black,
                                label: "Ok",
                                onPressed: (){
                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                },
                              ) ,
                            ));
                        // Navigator.popAndPushNamed(context, 'home');
                        // Navigator.pop(context);
                        //Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
                        ///////////////delete image///////////////
                        if(imgUlr != null && imgUlr != "image url here"){
                          await FirebaseStorage.instance.refFromURL(imgUlr).delete();
                        }
                        //////////////end delete image/////////////////////////////////////
                        file = File(picked.path);
                        var rand = Random().nextInt(1000000);
                        var imageName = "$rand" + basename(picked.path);
                        ref =  FirebaseStorage.instance
                            .ref('userAccountPicture')
                            .child("$imageName");
                        await ref.putFile(file);
                        userImageurl = await ref.getDownloadURL();
                        /////////////////////////////////////////////////////////////////////////////
                        //userDocID = await getUserDocID();
                        userCollectionRef
                            .doc(documentId)
                        // .doc(documentId)
                            .update({
                          'userImage': userImageurl,
                        }).then((value) {
                          print("_____________________Hello_________________________________________");
                        }
                        ).catchError((e) {
                          print(
                              "_________________________________________________________________");
                          print("e: $e");
                        });
                        // Navigator.of(context).popAndPushNamed('home');
                        // Navigator.pushReplacementNamed(context, 'home');
                      }



                      //Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 20),
                      color: Colors.white60,
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Gallery",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    )),

              ],
            ),
          );
        },

    );
  }

  getUserData() async {
    await getUserDocID();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocID)
        .get()
        .then((value) {
      user = value.data()['username'];
      email = value.data()['email'];
    });
  }

  initState() {
    // setState(() {
    super.initState();
    getCurrentUserImage();
    getUserDocID();
    getUserData();

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          color: Colors.black87,
          child: ListView(children: [
            Container(
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'images/carousel/01.jpg',
                            ),
                            fit: BoxFit.fill,)

                      ),
                      height: 200,
                      child: FutureBuilder(
                        future: userCollectionRef
                            .where('email', isEqualTo: authEmail)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return UserAccountsDrawerHeader(
                              accountName: Text(
                                snapshot.data.docs[0].data()['username'] != null
                                    ? snapshot.data.docs[0].data()['username']
                                    : "Username",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17),
                              ),
                              accountEmail: Text(
                                snapshot.data.docs[0].data()['email'] != null
                                    ? snapshot.data.docs[0].data()['email']
                                    : "email...",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              currentAccountPicture: CircleAvatar(
                                  child: Stack(
                                    children: [
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('images/icons/person.jpg'),
                                            fit: BoxFit.fitWidth
                                          ),
                                            borderRadius: BorderRadius.circular(300)),
                                        // child: Image.asset('images/logo/1.jpg'),
                                        child: snapshot.data.docs[0]
                                            .data()['userImage'] !=
                                            null
                                            ? Image.network(
                                          snapshot.data.docs[0].data()['userImage'],
                                          fit: BoxFit.cover,
                                          width: 90,
                                          height: 90,
                                        )
                                            : Image.asset('images/logo/1.jpg'),
                                      ),
                                      Positioned(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Colors.redAccent,
                                          ),
                                          iconSize: 35,
                                          onPressed: () async {
                                            await modalbottomsheet(context,snapshot.data.docs[0].data()['userImage'],snapshot.data.docs[0].id);
                                            // showLoading(context);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        bottom: -10,
                                        right: -10,
                                      ),
                                    ],
                                  )
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text('Error');
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )),
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    decoration: BoxDecoration(
                        // color: Colors.black87
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent.shade100),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                return HomeScreen();
                              }));
                            },
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.white,
                          height: .001,
                          indent: 0,
                          endIndent: 100,
                        ),
                        Container(
                          height: 70,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.notes,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "My Notes",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent.shade100),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed('home');
                            },
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.white,
                          height: .001,
                          indent: 0,
                          endIndent: 100,
                        ),
                        Container(
                          height: 70,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.note_add_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Add Note",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent.shade100),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed('addNote');
                            },
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.white,
                          height: .001,
                          indent: 0,
                          endIndent: 100,
                        ),
                        Container(
                          height: 70,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Favourites",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent.shade100),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed('favourites');
                            },
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.white,
                          height: .001,
                          indent: 0,
                          endIndent: 100,
                        ),
                        // Container(
                        //   height: 70,
                        //   child: InkWell(
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         Icon(
                        //           Icons.settings,
                        //           size: 30,
                        //           color: Colors.blue,
                        //         ),
                        //         SizedBox(
                        //           width: 20,
                        //         ),
                        //         Text(
                        //           "Setting",
                        //           style: TextStyle(
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.blue),
                        //         )
                        //       ],
                        //     ),
                        //     onTap: () {},
                        //   ),
                        // ),
                        Container(
                          height: 70,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.android_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Around App",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent.shade100),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed('aroundApp');
                            },
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.white,
                          height: .001,
                          indent: 0,
                          endIndent: 100,
                        ),
                        Container(
                          height: 70,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Log Out",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent.shade100),
                                )
                              ],
                            ),
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),

    );
  }
}

