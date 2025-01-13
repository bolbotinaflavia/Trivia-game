import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trivia_2/flutter_flow/widgets.dart';
import '../../flutter_flow/theme.dart';

class AddFriendWidget extends StatefulWidget {
  final String userId;
  const AddFriendWidget({super.key, required this.userId});

  @override
  State<AddFriendWidget> createState() => _AddFriendWidgetState();
}

class _AddFriendWidgetState extends State<AddFriendWidget> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1D5D8A),
          title: const Text("Add Friends"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              // User List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No users found."));
                    }

                    final users = snapshot.data!.docs
                        .where((doc) {
                      final userName = (doc['userName'] as String?)?.toLowerCase() ?? '';
                      return userName.contains(searchQuery) && doc['uid'] != widget.userId;
                    })
                        .toList();

                    if (users.isEmpty) {
                      return const Center(child: Text("No matching users found."));
                    }

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final userName = user['userName'] ?? 'Unknown User';
                        final profileImage = user['uploadedImage'] ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: profileImage.isNotEmpty
                                ? NetworkImage(profileImage)
                                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                          ),
                          title: Text(userName),
                          trailing: FFButtonWidget(
                            onPressed: () async {
                          try {
                            // Update the current user's "friends" array
                            await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
                              'friends': FieldValue.arrayUnion([user.id]),
                            });

                            // Optionally, update the friend's "friends" array to include the current user
                            await FirebaseFirestore.instance.collection('users').doc(user.id).update({
                              'friends': FieldValue.arrayUnion([widget.userId]),
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("You are now friends with $userName!")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to add friend: $e")),
                            );
                          }
                        },
                            text: 'Add Friend',
                            options: FFButtonOptions(
                              height: 40.0,
                              color: const Color(0xFF1D5D8A),
                              textStyle: MyAppTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
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
        ),
      ),
    );
  }
}
