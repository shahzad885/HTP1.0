import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardProvider with ChangeNotifier {
  int totalUsers = 0;
  int totalBlogs = 0;
  int totalImageAnalyses = 0;

  AdminDashboardProvider() {
    _listenToCounts();
  }

  void _listenToCounts() {
    FirebaseFirestore.instance
        .collection('HtpUsers')
        .snapshots()
        .listen((userSnapshot) {
      totalUsers = userSnapshot.size;
      notifyListeners();
    });

    FirebaseFirestore.instance
        .collection('articles')
        .snapshots()
        .listen((blogSnapshot) {
      totalBlogs = blogSnapshot.size;
      notifyListeners();
    });

    FirebaseFirestore.instance
        .collection('HTP-History')
        .snapshots()
        .listen((analysisSnapshot) {
      totalImageAnalyses = analysisSnapshot.size;
      notifyListeners();
    });
  }

  int get getTotalUsers => totalUsers;

  int get getTotalBlogs => totalBlogs;

  int get getTotalImageAnalyses => totalImageAnalyses;
}
