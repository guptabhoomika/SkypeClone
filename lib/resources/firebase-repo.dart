import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/user.dart';

import '../resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Firebaserepo
{
    Firebasemethods _firebasemethods = Firebasemethods();
    Future<FirebaseUser> getUser() => _firebasemethods.getuser();
    Future<FirebaseUser> signIn() => _firebasemethods.signIn();
    Future<bool> auth(FirebaseUser user) => _firebasemethods.authenticateUser(user);
    Future<void> addData(FirebaseUser user) => _firebasemethods.addData(user);
    Future<void> signOut() => _firebasemethods.signOut();
    Future<List<User>> fetchAll(FirebaseUser user) => _firebasemethods.fetchAllUser(user);
    
  Future<void> addMessageToDb(Message message, User sender, User receiver) =>
      _firebasemethods.addMessageToDb(message, sender, receiver);
}