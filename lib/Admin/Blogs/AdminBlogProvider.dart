// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:htp/User/Utils/Utils.dart';

// class BlogProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<QueryDocumentSnapshot> _blogs = [];
//   bool _isLoading = false;

//   List<QueryDocumentSnapshot> get blogs => _blogs;
//   bool get isLoading => _isLoading;

//   // Fetch blogs for the logged-in user
//   Future<void> fetchUserBlogs() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       final snapshot = await _firestore
//           .collection('articles')
//           .where('uid', isEqualTo: user.uid)
//           .orderBy('timestamp', descending: true)
//           .get();

//       _blogs = snapshot.docs;
//     } catch (e) {
//       Utils().ToastMessage('Error fetching blogs: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Save a blog
//   Future<void> saveBlog(String title, String content, String imageUrl) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       String id = DateTime.now().millisecondsSinceEpoch.toString();
//       await _firestore.collection('articles').doc(id).set({
//         'title': title,
//         'content': content,
//         'imageUrl': imageUrl,
//         'timestamp': FieldValue.serverTimestamp(),
//         'uid': user.uid,
//       });

//       fetchUserBlogs();
//       Utils().ToastMessage('Blog saved successfully!');
//     } catch (e) {
//       Utils().ToastMessage('Error saving blog: $e');
//     }
//   }

//   // Delete a blog
//   Future<void> deleteBlog(String blogId) async {
//     try {
//       await _firestore.collection('articles').doc(blogId).delete();
//       _blogs.removeWhere((doc) => doc.id == blogId);
//       notifyListeners();
//       Utils().ToastMessage('Blog deleted successfully!');
//     } catch (e) {
//       Utils().ToastMessage('Error deleting blog: $e');
//     }
//   }
// }
