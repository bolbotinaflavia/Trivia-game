import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../new_party/new_party_widget.dart';

class AddFriendsToPartyWidget extends StatefulWidget {
  final String partyId;

  const AddFriendsToPartyWidget({super.key, required this.partyId});

  @override
  State<AddFriendsToPartyWidget> createState() => _AddFriendsToPartyWidgetState();
}

class _AddFriendsToPartyWidgetState extends State<AddFriendsToPartyWidget> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List<dynamic> partyUsers = []; // List of users already in the party

  @override
  void initState() {
    super.initState();
    _fetchPartyUsers();
  }

  Future<void> _fetchPartyUsers() async {
    try {
      final partyDoc = await FirebaseFirestore.instance
          .collection('parties')
          .doc(widget.partyId)
          .get();

      if (partyDoc.exists) {
        setState(() {
          partyUsers = partyDoc['users'] ?? [];
        });
      }
    } catch (e) {
      print("Error fetching party users: $e");
    }
  }

  Future<void> _addFriendToParty(String friendId) async {
    try {
      await FirebaseFirestore.instance
          .collection('parties')
          .doc(widget.partyId)
          .update({
        'users': FieldValue.arrayUnion([friendId]),
      });

      // Update the local state to reflect the change
      setState(() {
        partyUsers.add(friendId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Friend added to the party!")),
      );
    } catch (e) {
      print("Error adding friend: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add friend.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Friends to Party"),
        backgroundColor: const Color(0xFF1D5D8A),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() => searchQuery = value.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search friends...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // Friends List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No friends found."));
                }

                final users = snapshot.data!.docs
                    .where((doc) {
                  final userName = (doc['userName'] as String?)?.toLowerCase() ?? '';
                  return userName.contains(searchQuery);
                }).toList();

                if (users.isEmpty) {
                  return const Center(child: Text("No matching friends found."));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userName = user['userName'] ?? 'Unknown User';
                    final userId = user.id;

                    // Check if the user is already in the party
                    final isInParty = partyUsers.contains(userId);

                    return ListTile(
                      title: Text(userName),
                      trailing: ElevatedButton(
                        onPressed: isInParty
                            ? null
                            : () => _addFriendToParty(userId),
                        child: Text(
                          isInParty ? "Added" : "Add",
                          style: TextStyle(
                            color: isInParty ? Colors.grey : Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInParty
                              ? Colors.grey[300]
                              : const Color(0xFF1D5D8A),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Next Step Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewPartyWidget(
                      partyId: widget.partyId,
                      userId: "", // Replace with actual userId if needed
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back to QR Code"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D5D8A),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
