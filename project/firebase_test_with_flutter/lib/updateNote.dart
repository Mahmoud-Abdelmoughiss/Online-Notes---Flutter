import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/showLoading.dart';
class Update extends StatefulWidget{
  final docid,data;
  Update({Key key,this.docid,this.data}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return UpdateState();
  }
}
class UpdateState extends State<Update>{
  File file;
  var imageurl, note, title,ref,picked;
  GlobalKey<FormState> _formKeyUpdate=GlobalKey<FormState>();
  updateNote(context)async{
    var formData=_formKeyUpdate.currentState;
    if(formData.validate()){
      formData.save();
      showLoading(context);
      var noteRef = FirebaseFirestore.instance.collection('notes');
      if(picked != null) {
        if(widget.data['imageURL']!=null){
          await FirebaseStorage.instance.refFromURL(widget.data['imageURL']).delete();
        }
        await ref.putFile(file);
        imageurl=await ref.getDownloadURL();
       await noteRef.doc(widget.docid).update({
          'title': title,
          'createdTime':DateTime.now(),
          'note': note,
          'imageURL': imageurl,
        });
      }else{
       await noteRef.doc(widget.docid).update({
          'title': title,
          'note': note,
         'createdTime':DateTime.now(),
        }).then((value){
         return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           content: Text("Note Updated Successfully"),
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
      }
      Navigator.of(context).pushNamedAndRemoveUntil('home',(route) => false);
    }

  }
  modalbottomsheet(context)async {
    return showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            padding: EdgeInsets.all(20),
            height: 170,
            decoration: BoxDecoration(
              color: Colors.white38,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Choose Image From :",style: TextStyle(
                      fontSize: 25,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600
                  ),),
                ),
                InkWell(
                    onTap: ()async{
                      picked=await ImagePicker().getImage(source: ImageSource.camera);
                      setState(() {
                        if(picked != null) {
                          file=File(picked.path);
                          var rand=Random().nextInt(1000000);
                          var imageName="$rand"+basename(picked.path);
                          ref = FirebaseStorage.instance.ref('noteImages').child("$imageName");
                        }
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 20),
                      color: Colors.white60,
                      child: Row(
                        children: [
                          Icon(Icons.camera,size: 30,),
                          SizedBox(width: 20,),
                          Text("Camera",style: TextStyle(fontSize: 20,),)
                        ],
                      ),
                    )
                ),
                InkWell(
                    onTap: () async {
                      picked=await ImagePicker().getImage(source: ImageSource.gallery);
                      setState(() {
                        if(picked != null) {
                          file=File(picked.path);
                          var rand=Random().nextInt(1000000);
                          var imageName="$rand"+basename(picked.path);
                          ref = FirebaseStorage.instance.ref('noteImages').child("$imageName");
                        }
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      // padding: EdgeInsets.only(bottom: 20),
                      color: Colors.white60,
                      child: Row(
                        children: [
                          Icon(Icons.photo_album_outlined,size: 30,),
                          SizedBox(width: 20,),
                          Text("Gallery",style: TextStyle(fontSize: 20,),)
                        ],
                      ),
                    )
                ),

              ],
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        elevation: 30,
        shadowColor: Colors.white,
        title: Text("Edit a Note",style: GoogleFonts.gochiHand(
            color: Colors.red,
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 100,left: 20,right: 20),
        children: [
          Form(
              key: _formKeyUpdate,
              child: Column(
                children: [
                  Container(
                    child: TextFormField(
                      initialValue: widget.data['title'],
                      onSaved: (val){title=val;},
                      validator: (val){
                        if(val.length<1){
                          return "Title is Required";
                        }
                        return null;
                      },
                      maxLength: 70,
                      decoration: InputDecoration(
                        border:  OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 2
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 2
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 2
                          )
                        ),
                        counterStyle: TextStyle(
                          color: Colors.white
                        ),
                        errorStyle: TextStyle(
                          color: Colors.red
                        ),
                        helperStyle: TextStyle(
                            color: Colors.white
                        ),
                        prefixIcon: Icon(Icons.title,size: 30,color: Colors.black,),
                        hintText: "Note Title",
                        labelText: "Title",
                        labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          color: Colors.red
                        ),
                        hintStyle: TextStyle(
                          color: Colors.red
                        ),

                        filled: true,
                        fillColor:Color(0xFFDAE0E5),
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    child: TextFormField(
                      initialValue: widget.data['note'],
                      onSaved: (val){note=val;},
                      validator: (val){
                        if(val.length<1){
                          return "Note Body is Required";
                        }
                        return null;
                      },
                      maxLength: 500,
                      decoration: InputDecoration(
                        border:  OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 2
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 2
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2
                          )
                        ),
                        counterStyle: TextStyle(
                            color: Colors.white
                        ),
                        errorStyle: TextStyle(
                            color: Colors.red
                        ),
                        helperStyle: TextStyle(
                            color: Colors.white
                        ),
                        prefixIcon: Icon(Icons.message,size: 30,color: Colors.black,),
                        hintText: "Note Body",
                        labelText: "Note Body",
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.red
                        ),
                        hintStyle: TextStyle(
                            color: Colors.red
                        ),
                        filled: true,
                        fillColor:Color(0xFFDAE0E5),
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      minLines: 1,
                      maxLines: null,
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          widget.data['imageURL']==null?
                              Container(
                                height: 35,
                                width: 35,
                                child: Image.asset('images/logo/3.jpg',fit: BoxFit.fill,),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ):
                          Container(
                            height: 35,
                            width: 35,
                            child: Image.network(widget.data['imageURL'],fit: BoxFit.fill,),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          )
                          ,
                          // Icon(Icons.image,size: 30,color: Color(0xFF1F0A45),),
                          Text("Change Image [ Optional ]",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          )
                        ],
                      ),
                      onPressed:()async{
                        await modalbottomsheet(context);
                      },
                      // onPressed:(){},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        shadowColor: Colors.red,
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    padding: EdgeInsets.only(top: 10),
                    child: Text(picked==null?"No Image changed":"Image has been changed",
                      style: GoogleFonts.aclonica(
                      color: Colors.white,
                    ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.symmetric(vertical: BorderSide(
                        color: Colors.red,
                        width: 3
                      ),horizontal: BorderSide(
                          color: Colors.red,
                          width: 0
                      ))
                    ),
                    child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Confirm Edit",
                            style: GoogleFonts.yeonSung(
                                color: Colors.blueAccent,
                                fontSize: 25,
                                fontWeight: FontWeight.w900
                            ),
                          )
                        ],
                      ),
                      onPressed: ()async{
                        await updateNote(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.red,
                        padding: EdgeInsets.all(30),
                      ),
                    ),
                  )

                ],
              ))
        ],
      ),
    );
  }
}

