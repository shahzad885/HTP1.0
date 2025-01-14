import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:htp/User/UI/DetailHistoryPage.dart';
import 'package:htp/User/UI/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:htp/User/Utils/Utils.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homescreen()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Analysis History'),
      ),
      body: Column(
        children: [
          // Search Text Field
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                hintText: 'Search history...',
                suffixIcon: searchController.text.isEmpty
                    ? const Icon(Icons.search)
                    : GestureDetector(
                        onTap: () {
                          searchController.clear();
                          setState(() {
                            searchText = '';
                          });
                        },
                        child: const Icon(Icons.clear),
                      ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('HTP-History')
                  .where('uid', isEqualTo: user?.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Utils().ShimmerEffect();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No analysis history available.'));
                }

                final historyDocs = snapshot.data!.docs;

                // Filter results based on the search text
                final filteredDocs = historyDocs.where((doc) {
                  final response = doc['response'].toString().toLowerCase();
                  return searchText.isEmpty || response.contains(searchText);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text('No results match your search.'));
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data = filteredDocs[index];
                    final imageUrl = data['imageURL'];
                    final response = data['response'];
                    final timestamp = data['timestamp'];
                    final truncatedResponse = response.length > 30
                        ? '${response.substring(0, 30)}...'
                        : response;

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
                         color: Colors.grey.withOpacity(0.2),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        leading: Image.network(imageUrl, width: 60, height: 60),
                        title: Text(truncatedResponse, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          formattedTimestamp != null
                              ? 'Analyzed at: ${formattedTimestamp.toLocal()}'
                              : 'Timestamp not available',
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
          ),
        ],
      ),
    );

   }
}
