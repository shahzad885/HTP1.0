import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserServicesProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create User
  Future<void> createUser(String name, String email, String role, String password) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user details in Firestore
      await _firestore.collection('HtpUsers').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role,
        'uid': userCredential.user!.uid,
      });

      notifyListeners();
    } catch (error) {
      debugPrint("Error creating user: $error");
      rethrow; // Rethrow to handle errors in the UI
    }
  }

  // Update User
  Future<void> updateUser(String userId, String name, String email, String role) async {
    try {
      await _firestore.collection('HtpUsers').doc(userId).update({
        'name': name,
        'email': email,
        'role': role,
      });
      notifyListeners();
    } catch (error) {
      debugPrint("Error updating user: $error");
      rethrow;
    }
  }

  // Delete User
  Future<void> deleteUser(String userId) async {
    try {
      // Delete user from Firestore
      await _firestore.collection('HtpUsers').doc(userId).delete();
      notifyListeners();
    } catch (error) {
      debugPrint("Error deleting user: $error");
      rethrow;
    }
  }
}
