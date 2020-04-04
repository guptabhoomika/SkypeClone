import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/user.dart';
import '../utils/username.dart';
class Firebasemethods
{
  User user = User();
  Utils util = Utils();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  static final firestore = Firestore.instance;
      Future<FirebaseUser> getuser() async{
        FirebaseUser currentUser;
        currentUser = await _auth.currentUser();
        return currentUser;

      }
      Future<FirebaseUser> signIn() async
      {
        GoogleSignInAccount googleSignInAccount =await  googleSignIn.signIn();
        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken, 
          accessToken: googleSignInAuthentication.accessToken
          );
          FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
          return user;

      }

     Future<bool> authenticateUser(FirebaseUser user) async{
       QuerySnapshot result = await firestore.collection("users").where("email" ,isEqualTo: user.email).getDocuments();
       final List<DocumentSnapshot> documnents = result.documents;
       return documnents.length == 0 ? true : false;
     }

     Future<void> addData(FirebaseUser cuser) async{
       String cusername = util.getUsername(cuser.email);
       user = User(
         uid: cuser.uid,
         email: cuser.email,
         name: cuser.displayName,
         profilePhoto: cuser.photoUrl,
         username: cusername
       );
       print("adding data");
       firestore.collection("users").document(cuser.uid).setData(user.toMap(user));

     }
     Future<void> signOut() async {
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    return await _auth.signOut();
  }
  Future<List<User>> fetchAllUser(FirebaseUser currentUser) async
  {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await firestore.collection("users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }
    
  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();

    await firestore
        .collection("messages")
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);
    
    return await firestore
        .collection("messages")
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  
}