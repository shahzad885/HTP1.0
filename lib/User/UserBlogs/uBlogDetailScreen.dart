import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserBlogDetailPage extends StatelessWidget {
  final DocumentSnapshot blogData;
  final String heroTag;

  const UserBlogDetailPage(
      {super.key, required this.blogData, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final title = blogData['title'] ?? 'Untitled';
    final content = blogData['content'] ?? '';
    final imageUrl = blogData['imageUrl'] ?? '';
    final timestamp = blogData['timestamp'];

    // Get screen height and width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog Title
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Blog Image
            if (imageUrl.isNotEmpty)
              Hero(
                tag: heroTag,
                child: Image.network(
                  imageUrl,
                  width: screenWidth, // Set width based on screen width
                  height: screenHeight * 0.4, // Set height based on screen height (30% of screen height)
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            // Blog Content
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Blog Timestamp
            if (timestamp != null)
              Text(
                'Published on: ${(timestamp as Timestamp).toDate().toLocal()}',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
