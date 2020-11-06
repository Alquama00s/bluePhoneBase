import'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globvar.dart';
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
///get data from storage
Future<Image> getimage(String address) async {
  Image cover;
  if(address=='/Add.png'){
    cover = Image.asset('$visuals/add.png');
    return cover;
  }
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
///google sign in
Future<String> signInWithGoogle() async {
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
  UserCredential Gusercred=await FirebaseAuth.instance.signInWithCredential(credential);
  return Gusercred.user.uid;
}
///licenses
void License(context){
  showAboutDialog(context: context,
    applicationName: 'Blue Phone Back',
    applicationVersion: 'Version: $version',
    applicationLegalese: '\u00a9 Copyright '
        'All rights reserved\n'
        'You are NOT granted the right to use the app without prior written permission from developer,\n'
        'you cannot decompile the app or use any assets of this app.\n'
        'this version of app is only for testing and will therefore be eventually deprecated.\n'
        'Please give your valuable feedback to the developer.',

  );
}
///update phonedata
void update(){
  FirebaseFirestore.instance.doc(updateroot).update({
    'ratelist':ratelist,
    'price':price,
  })
      .catchError((error) {
    print("Error updating document: $error");

  });
print('ratelist:$ratelist');
print(updateroot);
}
///upload image
Future<void> uploadFile(String filePath,String name) async {
  File file = File(filePath);

  try {
    await firebase_storage.FirebaseStorage.instance
        .ref().child('$name.png')
        .putFile(file);
  } catch (e) {
    print(e);
  }
}
///Add brand
Future<void> addBrand(String info,String filepath)async{
  info=info.toLowerCase();
  try{
  FirebaseFirestore.instance.doc(StartPoint).update({
    'address.$info':'/$info/$info',
    'list':FieldValue.arrayUnion([info]),
  });}catch(_){
    FirebaseFirestore.instance.doc(StartPoint).set({
      'address':{'$info':'/$info/$info'},
      'list':[info],
    });
  }
  FirebaseFirestore.instance.collection('$StartPoint/$info').doc(info).set({
    'address':{},
    'list':[],
    'type':1,
  }).then((value) =>
  print('done'));
  await uploadFile(filepath,info);
}
///Add series
Future<void> addSeries(String info,String filepath,String phone,String phonepath,bool varient,String namevar,String varpath)async{
  info=info.toLowerCase();
  phone=phone.toLowerCase();
  try{
  await FirebaseFirestore.instance.doc(updateroot).update({
    '$info.address.$phone':'/$info/$phone',
    '$info.list':FieldValue.arrayUnion([phone]),
    'address.$info':'tomap',
    'list':FieldValue.arrayUnion([info]),
  });}catch(_){
    await FirebaseFirestore.instance.doc(updateroot).set({
      '$info':{'address':{'$phone':'/$info/$phone'},'list':[phone]},
      'address':{'$info':'tomap'},
      'list':[info],
    });
  }
  if(varient==true){
    namevar=namevar.toLowerCase();
    try {
      await FirebaseFirestore.instance.collection('$updateroot/$info').doc(
          phone).update({
        'address.$namevar': '/$namevar/$namevar',
        'list': FieldValue.arrayUnion([namevar]),
        'type': 0,
      });
    }catch(_){
      await FirebaseFirestore.instance.collection('$updateroot/$info').doc(
          phone).set({
        'address':{'$namevar':'/$namevar/$namevar'},
        'list': [namevar],
        'type': 0,
      });
    }
    FirebaseFirestore.instance.collection('$updateroot/$info/$phone/$namevar').doc(namevar).set({
      'price':0,
      'ratelist':{'1':[-1,100,200,300,400,500,600,700,800],'2':[1,0,0,0,0],'3':[1,10,20,30],'4':[1,0,0],'5':[1,0,0],'6':[1,0,0,0],'limit':6},
      'type':3,
    }).then((value) =>
        print('done'));
    await uploadFile(varpath,namevar);
  }else{
    FirebaseFirestore.instance.collection('$updateroot/$info').doc(phone).set({
      'price':0,
      'ratelist':{'1':[-1,100,200,300,400,500,600,700,800],'2':[1,0,0,0,0],'3':[1,10,20,30],'4':[1,0,0],'5':[1,0,0],'6':[1,0,0,0],'limit':6},
      'type':3,
    }).then((value) =>
        print('done'));
  }
  await uploadFile(filepath,info);
  await uploadFile(phonepath,phone);
}
///resend price
Future<void> reSend(double price ,String root,String hashid)async{
  await FirebaseFirestore.instance.doc(root).update({
    'appointments.$hashid.accepted':false,
    'appointments.$hashid.ourprice':price,
  });
  await FirebaseFirestore.instance.doc('appointments/global').update({
    'appointments.$hashid.accepted':false,
    'appointments.$hashid.ourprice':price,
  });
}
///update pickup
Future<void> pickup(Map<String,dynamic> deliv,String root,String hashid)async{
  await FirebaseFirestore.instance.doc(root).update({
    'appointments.$hashid.delivery':deliv,
  });
  await FirebaseFirestore.instance.doc('appointments/global').update({
    'appointments.$hashid.delivery':deliv,
  });
}
///converting appointment map to array
List<Map<String,dynamic>> ConvAppointments(List<dynamic> ids,Map<String,dynamic> appointmentsMap){
  List<Map<String,dynamic>> appointments=[];
  for(String i in ids){
    appointmentsMap[i]['hashid']=i;
    appointments.add(appointmentsMap[i]);
  }
  return appointments;
}