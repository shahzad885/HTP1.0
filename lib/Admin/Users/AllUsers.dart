import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:htp/Admin/Users/UserServicesProvider.dart';
import 'package:provider/provider.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  String _searchText = ''; // Store the search text

  @override
  Widget build(BuildContext context) {
    final userServicesProvider = Provider.of<UserServicesProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateUserDialog(context, userServicesProvider, screenHeight),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Text Field
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 16),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                hintText: 'Search users...',
                suffixIcon: _searchText.isEmpty
                    ? const Icon(Icons.search)
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchText = '';
                          });
                        },
                        child: const Icon(Icons.clear),
                      ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          // Display users with search filter
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('HtpUsers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading users.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                final users = snapshot.data!.docs;

                // Filter users based on search text
                final filteredUsers = users.where((user) {
                  final userData = user.data() as Map<String, dynamic>;
                  final userEmail = userData['email'] ?? 'No Email';
                  return userEmail.toLowerCase().contains(_searchText.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    final userData = user.data() as Map<String, dynamic>;
                    final userEmail = userData['email'] ?? 'No Email';
                    final userRole = userData['role'] ?? 'No Role';
                    final userName = userEmail.split('@')[0];
                    final userId = user.id;

                    return Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01,
                      ),
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.blue, size: screenWidth * 0.07),
                        title: Text(userName, style: TextStyle(fontSize: screenWidth * 0.04)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userEmail, style: TextStyle(fontSize: screenWidth * 0.035)),
                            Text(userRole, style: TextStyle(fontSize: screenWidth * 0.035)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, size: screenWidth * 0.06),
                              onPressed: () {
                                _showEditUserDialog(
                                  context,
                                  userServicesProvider,
                                  userId,
                                  userName,
                                  userEmail,
                                  userRole,
                                  screenHeight,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red, size: screenWidth * 0.06),
                              onPressed: () {
                                userServicesProvider.deleteUser(userId);
                              },
                            ),
                          ],
                        ),
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
void _showCreateUserDialog(BuildContext context, UserServicesProvider userServicesProvider, double screenHeight) {
  String name = '';
  String email = '';
  String role = '';
  String password = ''; // Add password field

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                decoration: const InputDecoration(labelText: 'Role'),
                onChanged: (value) {
                  role = value;
                },
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true, // Hide password input
                onChanged: (value) {
                  password = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await userServicesProvider.createUser(name, email, role, password);
                Navigator.of(context).pop();
              } catch (error) {
                // Handle error (e.g., show a snackbar or dialog)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error creating user: $error')),
                );
              }
            },
            child: const Text('Create'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}


  // Function to show the Edit User dialog
  void _showEditUserDialog(
      BuildContext context,
      UserServicesProvider userServicesProvider,
      String userId,
      String userName,
      String userEmail,
      String userRole,
      double screenHeight) {
    String name = userName;
    String email = userEmail;
    String role = userRole;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: TextEditingController(text: name),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: TextEditingController(text: email),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  decoration: const InputDecoration(labelText: 'Role'),
                  controller: TextEditingController(text: role),
                  onChanged: (value) {
                    role = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                userServicesProvider.updateUser(userId, name, email, role);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
