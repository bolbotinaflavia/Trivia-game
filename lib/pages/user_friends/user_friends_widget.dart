import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../friend_profile/friend_profile_widget.dart';

class UserFriendsWidget extends StatefulWidget {
  final String userId;

  const UserFriendsWidget({super.key, required this.userId});

  @override
  State<UserFriendsWidget> createState() => _UserFriendsWidgetState();
}

class _UserFriendsWidgetState extends State<UserFriendsWidget> {
  Future<List<DocumentSnapshot>> _fetchFriends() async {
    try {
      // Fetch the current user's document
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      // Get the friends array
      final List<dynamic> friendsIds = userDoc['friends'] ?? [];

      // Fetch the friend documents using their IDs
      if (friendsIds.isNotEmpty) {
        final friendsDocs = await FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: friendsIds)
            .get();

        return friendsDocs.docs;
      }
    } catch (e) {
      print('Error fetching friends: $e');
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: MyAppTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1D5D8A),
          title: const Text("Your Friends"),
          elevation: 2.0,
        ),
        body: FutureBuilder<List<DocumentSnapshot>>(
          future: _fetchFriends(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("You have no friends yet."));
            }

            final friends = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                final friendId = friend.id;
                final friendName = friend['userName'] ?? 'Unknown User';
                final friendImage = friend['uploadedImage'] ?? '';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyAppTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color(0xFFBED5DA),
                        width: 2.0,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: friendImage.isNotEmpty
                            ? NetworkImage(friendImage)
                            : const AssetImage('assets/images/pin6_.png')
                                as ImageProvider,
                      ),
                      title: Text(friendName),
                      subtitle: const Text("Friend"),
                      onTap: () {
                        // Navigate to the friend's profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FriendProfileWidget(userId: friendId),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
