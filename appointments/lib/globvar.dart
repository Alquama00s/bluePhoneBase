String version='Unstable';
Map<String,dynamic> ratelist;
double price;
const String StartPoint='phone/phone/brand/brand';//starting point of Firestore
const String visuals='assets/visuals';
const List<String> quest=['General Problems','How is your screen condition','Do you have the following',
  'Mobile age','Is your phone under warranty','Other problems'];
const List<List<dynamic>> option=[['C','Front camera','Back camera','Volume button','Finger Touch sensor','WiFi','Battery','speaker','facesensor'],['C','Touch not Working','Spots present','Display Lines present','Broken'],['C','Charger','Box','Bill'],
  ['R','Less than a year','More than a year'],['R','Yes','No'],['C','Sim not working','Scratch present','Dent present']];
String updateroot;
const List<String> month=['','January','February','March','April','May','June','July','August','September','October','November','December'];
const List<String> day=['','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];