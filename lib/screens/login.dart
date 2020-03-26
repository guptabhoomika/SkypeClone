import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone/utils/universal_vars.dart';
import '../resources/firebase-repo.dart';
import 'homescreen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Firebaserepo _firebaserepo = Firebaserepo();
  bool isLoginPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: loginButton(),
          ),
          isLoginPressed ? Center(child: CircularProgressIndicator(),) : Container(),
        ],
      ),
      backgroundColor: UniversalVariables.blackColor,
        
      
    );
  }

  Widget loginButton()
  {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
          child: FlatButton(
        child: Text("LOGIN",style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2
        ),),
         onPressed: () => performLogin(),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

  }

  void performLogin()
  {
    setState(() {
      isLoginPressed = true;
    });
    _firebaserepo.signIn().then((FirebaseUser user){
      if(user!=null)
      {
          authenticate(user);
      }
      else
      {
        print("Error");
      }
      
    });

  }
  void authenticate(FirebaseUser user)
  {
    setState(() {
      
      isLoginPressed = false;
    });
    _firebaserepo.auth(user).then((isNewUser){
      print(isNewUser);
        if (isNewUser) {
        _firebaserepo.addData(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } 
      else
      {
         Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
      }

    });

  }
}