import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:htp/Admin/Blogs/BlogEditorScreen.dart';
import 'package:htp/Admin/Blogs/MyBlogs.dart';
import 'package:htp/User/UI/Auth/LoginScreen.dart';

class AdminDrawer extends StatefulWidget {
  AdminDrawer({super.key});

  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final _auth = FirebaseAuth.instance;

  String displayName = 'User Name';
  String email = 'Email not available';
  String? photoURL;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      email = currentUser.email ?? 'Email not available';
      photoURL = currentUser.photoURL;

      // Fetch name from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('HtpUsers')
          .doc(currentUser.uid)
          .get();

      setState(() {
        displayName = userDoc['name'] ?? 'User Name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(152, 158, 158, 158),
            ),
            child: ListTile(
              leading: photoURL != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(photoURL!),
                    )
                  : const CircleAvatar(child: Icon(Icons.person)),
              title: Text('Welcome, $displayName', style: const TextStyle(color: Colors.white)),
              subtitle: Text(email, style: const TextStyle(color: Colors.white)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Write Blog'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlogEditorScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('My Blogs'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyBlogs()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async {
              await _auth.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Loginscreen()),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
