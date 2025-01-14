import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htp/User/UI/Auth/LoginScreen.dart';
import 'package:htp/User/UI/HTP_History.dart';
import 'package:htp/User/UserBlogs/UserBlogScreen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final _auth = FirebaseAuth.instance;
  String displayName = 'User Name';
  String email = 'Email not available';
  String? photoURL;

  final List<Map<String, dynamic>> navList = [
    {'icon': Icons.history_edu, 'title': 'History'},
    {'icon': Icons.person, 'title': 'Blogs'},
  ];

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
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: ListTile(
              leading: photoURL != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(photoURL!),
                    )
                  : const CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                displayName,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              subtitle: Text(
                email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: navList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    navList[index]['icon'],
                  ),
                  title: Text(
                    navList[index]['title'],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (navList[index]['title'] == 'History') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryPage(),
                        ),
                      );
                    } else if (navList[index]['title'] == 'Blogs') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Userblogscreen(),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Loginscreen(),
                    ),
                  );
                });
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
