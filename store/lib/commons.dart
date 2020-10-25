import'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'globeVar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
Future<Map<String,dynamic>> getFire(String address) async {///get the document from firestore
  Map<String,dynamic> data;
  try{
  var doc = await FirebaseFirestore.instance.doc(address).get();
  data=doc.data();
  }catch(e){
    print(e);
    print('-----error getFire-----');
    print(address);
  }
  return data;
}
/*class Evaluatequest {
  String quest;
  List<dynamic> Options;
}*/
///get data from storage
Future<Image> getimage(String address) async {
  Image cover;
  try {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref().child(address)
        .getDownloadURL();
    //print(downloadURL+'//here');
    cover = Image.network(downloadURL);
  }catch(e){
    cover = Image.asset('$visuals/default.png');
  }
  /*Function onResolve(downloadURL) {
    cover = Image.network(downloadURL);
  }

  Function onReject(error) {
    cover = Image.asset('$visuals/default.png');
  }
  await firebase_storage.FirebaseStorage.instance
      .ref().child(address)
      .getDownloadURL().then(onResolve,onError: onReject);*/
  return cover;
}
///check login status;
Future<bool> getUser()async{
  await getLuser();
  var user=FirebaseAuth.instance.currentUser;
    if(user==null){
      Guser=null;
      Gusercred=null;
      loggedin=false;
    }
    else{
      Guser=user;
      loggedin=true;
    }
  return loggedin;
}

///save initial user data to json
void saveJason()async{
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final filepath = "$path/$userFile";
  File file=new File(filepath);
  bool exist=await file.exists();
  if(exist){
    file.writeAsString(json.encode(Luser));
  }else{
    await file.create(recursive: true);
    file.writeAsString(json.encode(Luser));
  }

}
///get userinfo
Future<Map<String,dynamic>> getLuser()async{
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final filepath = "$path/$userFile";
  File file=new File(filepath);
  bool exist=await file.exists();
  if(exist){
    String content=await File(filepath).readAsString();
    try {
      Luser = json.decode(content);
    }catch(e){
      Luser=null;
    }
  }else{
    await file.create(recursive: true);
    Luser=null;
  }

  return Luser;
}
///initialize local user
void initLuser()async{
  await getLuser();
  if(Luser==null){
  Luser={'name':Guser.displayName,
  'email':Guser.email,
  'phone':'Phone',
  'addressl1':'Address Line 1',
  'addressl2':'Address Line 2',
  'landmark':'Landmark',
  'pincode':'Pincode',
  'city':'Kolkata',
  'state':'West Bengal'};
  }
  await saveJason();
}
///google sign in
void signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  // Once signed in, return the UserCredential
  Gusercred = await FirebaseAuth.instance.signInWithCredential(credential);
  await getUser();
  await initLuser();
  //print(user);
  }
  ///appoint function
Future<bool> userExist(String user)async{
  var doc=await getFire('appointments/$user');
    if (doc==null) {
      return false;
    }else{
      return true;
    }
}
///update appointments
void update(String uid){
  FirebaseFirestore.instance.collection('appointments').doc(uid).update({
    'appointments':FieldValue.arrayUnion([phonestate]),
  })
      .catchError((error) {
  print("Error removing document: $error");

  });

}
///initialize appointment
void initAppoint(String uid){
  FirebaseFirestore.instance.collection('appointments').doc(uid).set({
    'profile':Luser,
    'appointments':[],
  })
      .catchError((error) => print("Failed to add user: $error"));
}
///initialize pstae
void initializep(){
  phonestate={
    'root':'',
    'pstate':{
      '1':[],
      '2':[],
      '3':[],
      '4':[],
      '5':[],
      '6':[],
    },
    'price':0,
    'datetime':'0',
  };
}
///licenses
void License(context){
  showAboutDialog(context: context,
    applicationName: 'Blue Phone Base',
    applicationVersion: 'Version: $version',
    applicationLegalese: '\u00a9 Copyright '
        'All rights reserved\n'
        'You are only granted the right to use the app, '
        'you cannot decompile the app or use any assets of this app.\n'
        'this version of app is only for testing and will therefore be eventually deprecated.\n'
        'Please give your valuable feedback to the developer.',

  );
}