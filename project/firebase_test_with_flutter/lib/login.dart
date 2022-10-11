import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/showLoading.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}


class LoginState extends State<Login>
{

  var _email,_password;
  GlobalKey<FormState> formKey=new GlobalKey<FormState>();
  signIn()async{
    var formData=formKey.currentState;
    if(formData.validate()){
      formData.save();
      showLoading(context);
      try{
        UserCredential userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email, password: _password);
        return userCredential;
      }on FirebaseAuthException catch(e){
        if(e.code=='user-not-found'){
          Navigator.of(context).pop();//remove showLoading function affect
          return AwesomeDialog(context: context,title: "Error",body: Text("User Not Found"))..show();
        }
        if(e.code=='wrong-password'){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Login();}));//remove showLoading function affect
          return AwesomeDialog(context: context,title: "Error",body: Text("Wrong Password"))..show();

        }
      }
      catch(e){
        print(e);
      }
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            SizedBox(height: 30,),
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              // child: Image.asset('images/logo/5.jpg',),
              child: Icon(Icons.verified_user,size: 300,color: Colors.blue,),
            ),
            SizedBox(height: 80,),
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
                          prefixIcon: Icon(Icons.email),
                          hintText: "Email address"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val){
                        if(val.isEmpty){
                          return "Empty Field";
                        }else if(val.length<12){
                          return "Email Shouldn't less than 12 letters";
                        }else if(val.length>50){
                          return "Email Shouldn't More than 50 letters";
                        } else{
                          return null;
                        }
                      },
                      onSaved: (val){
                        _email=val;
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
                      validator: (val){
                        if(val.isEmpty){
                          return "Password Field";
                        }else if(val.length<4){
                          return "Password Shouldn't less than 4 letters";
                        }else if(val.length>50){
                          return "Password Shouldn't More than 50 letters";
                        } else{
                          return null;
                        }
                      },
                      onSaved: (val){
                        _password=val;
                      },
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Text("     IF You Haven't An account   ",),
                          InkWell(
                            child: Text("Go to Sign Up",style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              // fontFamily: "Times New Roman",
                            ),),
                            onTap: (){
                              Navigator.of(context).pushNamedAndRemoveUntil('signup',(route) => false);
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
                                fontWeight: FontWeight.w700,
                            )
                        ),
                        onPressed: ()async{
                          UserCredential _user= await signIn();
                          if(_user != null) {
                            if (!_user.user.emailVerified) {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                               return Login();
                              }), (route) => false);
                              showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text("Warning",style: TextStyle(color: Colors.blue),),
                                    backgroundColor: Colors.black,
                                    content: Text("Verify You Email",style: TextStyle(color: Colors.blue)),
                                    actions: [
                                      TextButton(onPressed:(){
                                        Navigator.of(context).pushNamedAndRemoveUntil(
                                            'login', (Route<dynamic> route)=>false);
                                      } , child: Text("Ok"))
                                    ],
                                  );
                                });
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  'homeScreen', (Route<dynamic> route) {
                                return false;
                              });
                            }
                          }
                        },
                        child: Text("Log In"))
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}

