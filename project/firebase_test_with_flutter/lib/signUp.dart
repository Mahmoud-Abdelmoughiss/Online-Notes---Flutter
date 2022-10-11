import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/showLoading.dart';
import 'verificationScreen.dart';
class SignUp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}
class SignUpState extends State<SignUp>
{
  var _email,_password,_username;
  UserCredential userCredential;
  GlobalKey<FormState> formKey=GlobalKey<FormState>();
  signUp()async{
    var formData=formKey.currentState;
    if(formData.validate()){
      formData.save();
      showLoading(context);
      try{
         userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email, password: _password
        ).then((_)async{
                await FirebaseFirestore.instance.collection('users').add({
                  'username':_username,
                  'email':_email,
                  'userImage':'image url here'
                });
                return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                  return VerificationScreen();
                }), (route) => false);

        });
        return userCredential;
      }on FirebaseAuthException catch(e){
        if(e.code=='email-already-in-use'){
          Navigator.of(context).pop();//remove showLoading function affect
          return AwesomeDialog(context: context,title: "Error",body: Text("Email Provided Already Exists !"))..show();

        }else if(e.code=='weak-password'){
          Navigator.of(context).pop();//remove showLoading function affect
          return AwesomeDialog(context: context,title: "Error",body: Text("Password Provided is very Weak"))..show();
        }
      }catch(e){
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            SizedBox(height: 10,),
            SizedBox(
              height: 270,
              width: MediaQuery.of(context).size.width,
              child: Icon(Icons.supervised_user_circle,size: 300,color: Colors.blue,),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            )
                        ),
                        prefixIcon: Icon(Icons.person),
                        hintText: "User Name"
                      ),
                      onSaved: (val){
                        _username=val;
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Empty Field";
                        }else if(val.length<4){
                          return "UserName Should More Than 4 Letters";
                        }else if(val.length>50){
                          return "UserName Should Less Than 50 Letters";
                        }else{
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              )
                          ),
                          prefixIcon: Icon(Icons.email),
                          hintText: "Email Address"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val){
                        _email=val;
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Empty Field";
                        }else if(val.length<12){
                          return "Email Should More Than 12 Letters";
                        }else if(val.length>50){
                          return "Email Should Less Than 50 Letters";
                        }else{
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              )
                          ),
                          prefixIcon: Icon(Icons.vpn_key_rounded),
                          hintText: "Password"
                      ),
                      onSaved: (val){
                        _password=val;
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Empty Field";
                        }else if(val.length<4){
                          return "Password Should More Than 4 Letters";
                        }else if(val.length>50){
                          return "Password Should Less Than 50 Letters";
                        }else{
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                      children: [
                        Text("     IF You Have An account   ",style: TextStyle(

                        ),),
                        InkWell(
                          child: Text("Go to Log In",style: TextStyle(
                              fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600
                          ),),
                          onTap: (){
                            Navigator.of(context).pushNamed('login');
                          },
                        ),
                      ],
                    ),),
                    SizedBox(height: 20,),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                        primary: Colors.white,
                        backgroundColor: Colors.blue,
                        onSurface: Colors.blueGrey,
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        )
                      ),
                      onPressed: ()async{
                        await signUp();
                        // UserCredential _user= await signUp();
                        // if(_user != null){
                        //   await FirebaseFirestore.instance.collection('users').add({
                        //     'username':_username,
                        //     'email':_email,
                        //     'userImage':'image url here'
                        //   });
                         // var currentUser = FirebaseAuth.instance.currentUser;
                         // if(!currentUser.emailVerified){
                         //   await currentUser.sendEmailVerification();
                         //   Navigator.of(context).pushNamedAndRemoveUntil('homeScreen',(Route<dynamic> route){
                         //     return false;
                         //   });
                         // }
                        }
                      // }
                       ,
                      child: Text("Sign Up"))
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}

