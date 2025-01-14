import 'package:cloud_firestore/cloud_firestore.dart';

class Userblogservices {
  // Fetch blogs from Firestore's 'articles' collection and sort by timestamp
  Future<List<QueryDocumentSnapshot>> fetchAdminBlogs() async {
    try {
      // Access the Firestore 'articles' collection and sort by 'timestamp'
      final querySnapshot = await FirebaseFirestore.instance
          .collection('articles')
          .orderBy('timestamp', descending: true) // Order blogs by most recent
          .get();


      // Return the list of blogs
      return querySnapshot.docs;
    } catch (e) {
      return [];
    }
  }

  // Fetch the admin's email using UID from Firestore users collection
  Future<String> getAdminEmailFromUID(List<QueryDocumentSnapshot> blogs) async {
    try {
      // Get the UID of the first blog (You can modify this to fetch based on a specific condition)
      final uid = blogs.isNotEmpty ? blogs[0]['uid'] : '';
      
      if (uid.isNotEmpty) {
        // Fetch the user details from the 'users' collection based on UID
        final userDoc = await FirebaseFirestore.instance
            .collection('HtpUsers') // Assuming you have a 'users' collection
            .doc(uid)
            .get();
        
        // Check if the document exists and return the email
        if (userDoc.exists) {
          return userDoc['email'] ?? 'unknown@domain.com'; // Return the admin email
        } else {
          return 'User not found';
        }
      } else {
        return 'No UID available';
      }
    } catch (e) {
      
      return 'Error fetching email';
    }
  }
}
