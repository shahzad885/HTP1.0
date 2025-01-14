import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:htp/User/Utils/Utils.dart';

class BlogservicesProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance.collection('articles');

  // Method to save blog data to Firestore
  Future<void> saveBlog(
      String title, String content, String imageUrl, String uid) async {
    try {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      await firestore.doc(id).set({
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'uid': uid, // Save the user's UID
      });
      // Notify listeners (e.g., UI) that the data has been saved successfully
      notifyListeners();
    } catch (e) {
      Utils().ToastMessage('Error saving to history: $e');
    }
  }

  // Get blogs for a specific user by UID
  Future<QuerySnapshot> getBlogsByUid(String uid) async {
    return await FirebaseFirestore.instance
        .collection('articles')
        .where('uid', isEqualTo: uid) // Query blogs by UID
        .orderBy('timestamp', descending: true)
        .get();
  }
}
