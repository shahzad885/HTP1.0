import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htp/Admin/dashboard.dart';
import 'package:htp/User/UI/Auth/LoginScreen.dart';
import 'package:htp/User/UI/HomeScreen.dart';

class SplashScreenProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Method to check login status and navigate
  void checkLoginStatus(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    // Simulate loading state for the splash screen
    _isLoading = true;
    notifyListeners();

    // Wait for 2 seconds before checking the login status
    await Future.delayed(const Duration(seconds: 1));

    if (user != null) {
      // Fetch user role from Firestore
      final uid = user.uid;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('HtpUsers')
          .doc(uid)
          .get();

      if (userDoc.exists && userDoc['role'] == 'admin') {
        // Check if widget is still mounted before navigating
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
          );
        }
      } else {
        // Check if widget is still mounted before navigating
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homescreen()),
          );
        }
      }
    } else {
      // Check if widget is still mounted before navigating
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
      }
    }

    // Set loading to false once navigation happens
    _isLoading = false;
    notifyListeners();
  }
}
