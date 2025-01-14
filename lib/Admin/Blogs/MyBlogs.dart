import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBlogs extends StatelessWidget {
  const MyBlogs({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Fetch screen dimensions for responsive UI
    final screenWidth = MediaQuery.of(context).size.width;
   // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Blogs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .where('uid', isEqualTo: user?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('You have not created any blogs yet.'));
          }

          final blogDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: blogDocs.length,
            itemBuilder: (context, index) {
              final data = blogDocs[index];
              final title = data['title'] ?? 'Untitled';
              final imageUrl = data['imageUrl'] ?? '';
              final timestamp = data['timestamp'];

              DateTime? formattedTimestamp;
              if (timestamp != null) {
                formattedTimestamp = (timestamp is Timestamp) ? timestamp.toDate() : null;
              }

              return Dismissible(
                key: Key(data.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await FirebaseFirestore.instance
                      .collection('articles')
                      .doc(data.id)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Blog "$title" deleted')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(screenWidth * 0.03),
                  leading: Hero(
                    tag: data.id,
                    child: imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(screenWidth * 0.02),
                            child: Image.network(
                              imageUrl,
                              width: screenWidth * 0.15,
                              height: screenWidth * 0.15,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.image, size: screenWidth * 0.15, color: Colors.grey),
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  subtitle: Text(
                    formattedTimestamp != null
                        ? 'Created on: ${formattedTimestamp.toLocal()}'
                        : 'Timestamp not available',
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetailPage(
                          blogData: data,
                          heroTag: data.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BlogDetailPage extends StatelessWidget {
  final DocumentSnapshot blogData;
  final String heroTag;

  const BlogDetailPage({super.key, required this.blogData, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for dynamic spacing and sizes
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blogData['title'] ?? 'Untitled',
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
            Hero(
              tag: heroTag,
              child: blogData['imageUrl'] != null && blogData['imageUrl'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      child: Image.network(
                        blogData['imageUrl'],
                        width: double.infinity,
                        height: screenWidth * 0.5,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(Icons.image, size: screenWidth * 0.5, color: Colors.grey),
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              blogData['content'] ?? 'No content available',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
