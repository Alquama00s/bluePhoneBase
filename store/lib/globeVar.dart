import 'package:google_sign_in/google_sign_in.dart';

import 'commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
String version='Unstable';
bool loggedin=true;
User Guser;
UserCredential Gusercred;
Map<String,dynamic> Luser,tempuser;
String userFile='user.json';
const String StartPoint='phone/phone/brand/brand';//starting point of Firestore
const String visuals='assets/visuals';
const List<String> quest=['General Problems','How is your screen condition','Do you have the following',
'Mobile age','Is your phone under warranty','Other problems'];
const List<List<dynamic>> option=[['C','Front camera','Back camera','Volume button','Finger Touch sensor','WiFi','Battery','speaker','facesensor'],['C','Touch not Working','Spots present','Display Lines present','Broken'],['C','Charger','Box','Bill'],
['R','Less than a year','More than a year'],['R','Yes','No'],['C','Sim not working','Scratch present','Dent present']];
const List<List<double>> rateList=[[-1,100,200,300,400,500,600,700,800],[1,0,0,0,0],[1,10,20,30],[1,0,0],[1,0,0],[1,0,0,0]];
Map<String,dynamic> phonestate;