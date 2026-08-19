import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalapp/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final Ref ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthService(this.ref);

 Future<UserCredential?> signIn(String email, String password)async{
  try {
   bool userExists = await _checkUserExists(email);

   if(!userExists) {
    throw Exception("User not found. please register first");
   }

  final UserCredential result = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  await _saveUserState(true);
  return result;
  } on FirebaseException catch(e) {
    throw Exception("Login Failed: ${e.message}");
  }
  
  }

  Future<UserCredential?> createUser(String userName,String email, String password, )async {
     try {
      bool userExists = await _checkUserExists(email);

   if(userExists) {
    throw Exception("User already exist. please Login");
   }

  final UserCredential result = await _auth.createUserWithEmailAndPassword(
    email: email, 
    password: password
    );
    await _addUserToDatabase(userName, email, password);

  await _saveUserState(true);
    return result;
  }  catch(e) {
    throw Exception("Registration Failed: $e");
  }
  
  }

 Future<void> signOut()async {
  await _auth.signOut();
 await _saveUserState(false);
 }

 Future<void> _addUserToDatabase(
  String userName,
   String email,
    String password)
    async {
    final userId =   _auth.currentUser!.uid;
  UserModel user = UserModel(username: userName, email: email);
  try {
    await _firestore.collection('users').doc(userId).set(user.toMap());
  } catch (e) {
    throw Exception("Failed to register: $e");
  }
 
 }

 Future<bool> _checkUserExists(String email) async {
  try {
   final QuerySnapshot<Map<String, dynamic>> result = await _firestore
    .collection('users')
     .where('email', isEqualTo: email)
     .limit(1)
     .get();
   return result.docs.isNotEmpty;
  } catch (e) {
    throw Exception("Error in checking: $e");
  }
 }

 Future<void> _saveUserState(bool isLoggedIn) async {
   final prefs = await SharedPreferences.getInstance();
   await prefs.setBool('isLoggedIn', isLoggedIn);
 }
}

