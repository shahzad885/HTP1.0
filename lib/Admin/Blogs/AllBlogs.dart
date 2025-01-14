import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllBlogs extends StatelessWidget {
  const AllBlogs({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Blogs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .orderBy('timestamp', descending: true) // Sorting by timestamp
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No blogs available.'));
          }

          final blogDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: blogDocs.length,
            itemBuilder: (context, index) {
              final data = blogDocs[index];

              final title = data['title']; // Assuming the blog has a title field
              final imageUrl = data['imageUrl'] ?? '';
             // final content = data['content']; // Assuming the blog has a content field
              final timestamp = data['timestamp']; // Assuming the blog has a timestamp field
              // final truncatedContent = content.length > 30
              //     ? '${content.substring(0, 30)}...'
              //     : content;

              // Convert timestamp to DateTime
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
                },
                background: Container(
                  color: const Color(0xffB71540),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(screenWidth * 0.03),
                  leading: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: screenWidth * 0.25, // Fixed width for the image
                          height: screenWidth * 0.25, // Fixed height for the image
                          fit: BoxFit.cover, // Ensures the image doesn't distort
                        )
                      : Icon(Icons.image_not_supported, size: screenWidth * 0.25, color: Colors.grey), // Placeholder icon if no image
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  
                  subtitle: Text(
                    formattedTimestamp != null
                        ? 'Published on: ${formattedTimestamp.toLocal()}'
                        : 'Timestamp not available',
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetailPage(blogData: data, heroTag: ''), // Navigate to BlogDetailPage
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

  const BlogDetailPage({super.key, required this.blogData, required String heroTag});

  @override
  Widget build(BuildContext context) {
    final title = blogData['title'] ?? 'Untitled';
    final content = blogData['content'] ?? '';
    final imageUrl = blogData['imageUrl'] ?? '';
    final timestamp = blogData['timestamp'];

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
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
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
