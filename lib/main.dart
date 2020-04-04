import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/screens/searchScreen.dart';
import './resources/firebase-repo.dart';
import './screens/homescreen.dart';
import './screens/login.dart';
void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Firebaserepo _firebaserepo = Firebaserepo();
  
  
  @override
  
  Widget build(BuildContext context) {
      //_firebaserepo.signOut();
   
  
    return MaterialApp(
      title: "Skype_Clone",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      initialRoute: '/',
      routes: {
        '/searchScreen' : (context) => SearchScreen(),
      },
      home: FutureBuilder(
        future: _firebaserepo.getUser(),
        builder:  (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return LoginScreen();
          } 
        

        }),

      
      
    );
  }
}