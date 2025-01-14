import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htp/User/UI/HomeScreen.dart';
import 'package:htp/User/UserBlogs/UserBlogServices.dart';
import 'package:htp/User/UserBlogs/uBlogDetailScreen.dart';
import 'package:htp/User/Utils/Utils.dart';
import 'package:htp/User/Widgets/CustomCard.dart';

class Userblogscreen extends StatefulWidget {
  const Userblogscreen({super.key});

  @override
  State<Userblogscreen> createState() => _UserblogscreenState();
}

class _UserblogscreenState extends State<Userblogscreen> {
  List<QueryDocumentSnapshot> _blogs = [];
  bool _isLoading = true;
  String _adminEmail = '';
  final TextEditingController searchController = TextEditingController();

  String searchText = ''; // Store the search text

  @override
  void initState() {
    super.initState();
    _loadBlogs();
  }

  Future<void> _loadBlogs() async {
    Userblogservices blogServices = Userblogservices();
    final blogs = await blogServices.fetchAdminBlogs();

    // Fetch the email of the admin using UID
    final adminEmail = await blogServices.getAdminEmailFromUID(blogs);

    setState(() {
      _blogs = blogs;
      _adminEmail = adminEmail;
      _isLoading = false;
    });
  }

  String extractName(String email) {
    final name = email.split('@').first; // Get the part before '@'
    return name.replaceAll(
        RegExp(r'[^a-zA-Z]'), ''); // Remove non-alphabet characters
  }

  @override
  Widget build(BuildContext context) {
    // Filter the blogs based on search text
    final filteredBlogs = _blogs.where((blog) {
      final title = blog['title']?.toString().toLowerCase() ?? '';
      return title.contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homescreen()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: CustomScrollView( // Use CustomScrollView instead of SingleChildScrollView
        slivers: [
          // Search Text Field
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  hintText: 'Search blogs...',
                  suffixIcon: searchText.isEmpty
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
          ),
          // Display loading indicator while fetching data
          _isLoading
              ? SliverFillRemaining(child: Utils().ShimmerEffect())
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final blog = filteredBlogs[index];
                      final title = blog['title'] ?? 'Untitled';
                      final imageUrl = blog['imageUrl'] ?? '';
                      final timestamp = blog['timestamp'] as Timestamp?;
                      final publisherName = extractName(_adminEmail);

                      return Customcard(
                        heroTag: 'blogHeroTag_$index',
                        title: title,
                        imageUrl: imageUrl,
                        timestamp: timestamp?.toDate(),
                        publisherName: publisherName,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserBlogDetailPage(
                                blogData: blog,
                                heroTag: 'blogHeroTag_$index',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: filteredBlogs.length,
                  ),
                ),
        ],
      ),
    );
  }
}
