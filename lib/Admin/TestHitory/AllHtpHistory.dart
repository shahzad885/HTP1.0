import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:htp/User/UI/DetailHistoryPage.dart';

class Allhtphistory extends StatelessWidget {
  const Allhtphistory({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;
   // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Analysis History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('HTP-History')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No analysis history available.'));
          }

          final historyDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {
              final data = historyDocs[index];
              final imageUrl = data['imageURL'];
              final response = data['response'];
              final timestamp = data['timestamp'];
              final truncatedResponse = response.length > 30
                  ? '${response.substring(0, 30)}...'
                  : response;

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
                      .collection('HTP-History')
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
                  leading: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: screenWidth * 0.15,
                          height: screenWidth * 0.15,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.image_not_supported,
                          size: screenWidth * 0.15, color: Colors.grey),
                  title: Text(
                    truncatedResponse,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  subtitle: Text(
                    formattedTimestamp != null
                        ? 'Analyzed at: ${formattedTimestamp.toLocal()}'
                        : 'Timestamp not available',
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detailhistorypage(data: data),
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
