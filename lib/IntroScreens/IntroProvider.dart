import 'dart:async';
import 'package:flutter/material.dart';
import 'package:htp/User/UI/Auth/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroProvider with ChangeNotifier {
  final PageController _controller = PageController();
  int _currentPage = 0;

  PageController get controller => _controller;
  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  Future<void> completeIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_completed', true);

    Navigator.push(context, MaterialPageRoute(builder: (context) => const Loginscreen()));

    // final auth = FirebaseAuth.instance;
    // final user = auth.currentUser;

    // if (user != null) {
    //   final uid = user.uid;
    //   final DocumentSnapshot userDoc =
    //       await FirebaseFirestore.instance.collection('HtpUsers').doc(uid).get();

    //   if (userDoc.exists && userDoc['role'] == 'admin') {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard(),));
    //   } else {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homescreen(),));
    //   }
    // } else {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Loginscreen(),));
    // }
  }
}
