import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

InputDecoration formDecoration(Size size)=> InputDecoration(
  labelText: '',
  //hintText: '',
  contentPadding: EdgeInsets.symmetric(horizontal: size.height*.02,vertical: size.height*.02),
  isDense: true,
  alignLabelWithHint: true,
  hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: size.height*.022,
      fontWeight: FontWeight.w400,
      fontFamily: 'OpenSans'
  ),
  labelStyle: TextStyle(
      color: Colors.grey,
      fontSize: size.height*.022,
      fontWeight: FontWeight.w400,
      fontFamily: 'OpenSans'
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.blueGrey,
        width: 0.5
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.blueGrey,
        width: 0.5
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.teal,
        width: 0.5
    ),
  ),
);

void showSnackBar(BuildContext context,String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      alignment: Alignment.center,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.3),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Color(0xff7FCA4A),
            ]
          ),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Text(message,textAlign:TextAlign.center,
        style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.height*.02,),),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    duration: Duration(milliseconds: 4000),
  ));
}

void showToast(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16,
  );
}

Widget spinCircle()=>
    SpinKitCircle(
    color: Color(0xff162B36),
    size: 50.0,
  );
