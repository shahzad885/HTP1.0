import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UserService {

  // Function to store user info in Firestore
  Future<void> storeUserInfo(User user, String name) async {
    try {
      // Check if the user already exists in the Firestore collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('HtpUsers')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // If the user doesn't exist, create a new document
        await FirebaseFirestore.instance.collection('HtpUsers').doc(user.uid).set({
          'name': name, // Add name field
          'email': user.email,
          'uid': user.uid,
          'role': 'user', // Default role is 'user'
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error storing user info: $e');
    }
  }
  
}
