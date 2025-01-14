import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Detailhistorypage extends StatelessWidget {
  final QueryDocumentSnapshot data;

  const Detailhistorypage({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = data['imageURL'];
    final response = data['response'];
    final timestamp = data['timestamp'];

    // Convert timestamp to DateTime
    DateTime? formattedTimestamp;
    if (timestamp != null) {
      formattedTimestamp = (timestamp is Timestamp) ? timestamp.toDate() : null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(imageUrl, height: 200), // Full-sized image
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Response:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              response,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Analyzed at:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              formattedTimestamp != null
                  ? formattedTimestamp.toLocal().toString()
                  : 'Timestamp not available',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
