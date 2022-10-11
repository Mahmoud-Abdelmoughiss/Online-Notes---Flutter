import 'package:flutter/material.dart';
showLoading(context){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
        title: Text("Loading..."),
        content: Container(
          height: 100,
          color: Colors.white54,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
    );
  });
}