import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trivia_2/theme/widgets.dart';
import '../../theme/theme.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? profileImageUrl;

  User? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Get the current authenticated user
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Fetch user data from Firestore using the UID
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      final data = userDoc.data();

      if (data != null) {
        setState(() {
          profileImageUrl = data['uploadedImage'] ?? '';
          nameController.text = data['userName'] ?? '';
          bioController.text = data['bio'] ?? '';
          emailController.text = currentUser!.email ?? ''; // From Auth
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      try {
        // Upload the new profile image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${currentUser!.uid}.jpg');
        final uploadTask = storageRef.putFile(File(pickedImage.path));
        final snapshot = await uploadTask.whenComplete(() => null);
        final downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          profileImageUrl = downloadUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _saveProfileChanges() async {
    try {
      final userName = nameController.text.trim();
      final bio = bioController.text.trim();

      // Update Firestore user data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({
        'userName': userName,
        'bio': bio,
        'uploadedImage': profileImageUrl,
      });

      // Update Firebase Auth email if changed
      if (emailController.text.trim() != currentUser!.email) {
        await currentUser!.updateEmail(emailController.text.trim());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error saving profile changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile changes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: MyAppTheme.of(context).secondaryBackground,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: MyAppTheme.of(context).secondaryBackground,
        elevation: 0.0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                Colors.grey[300], // Background for empty state
                            backgroundImage: profileImageUrl != null &&
                                    profileImageUrl!.isNotEmpty
                                ? NetworkImage(profileImageUrl!)
                                : null, // No image if URL is null/empty
                            child: profileImageUrl == null ||
                                    profileImageUrl!.isEmpty
                                ? Icon(Icons.person,
                                    size: 50, color: Colors.grey[600])
                                : null,
                          ),
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue,
                            child:
                                Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Your Name'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        controller: bioController,
                        decoration:
                            const InputDecoration(labelText: 'Your Bio'),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration:
                            const InputDecoration(labelText: 'Your Email'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FFButtonWidget(
                      onPressed: _saveProfileChanges,
                      text: 'Save Changes',
                      options: FFButtonOptions(
                        width: 200,
                        height: 50,
                        color: Colors.blue,
                        textStyle: MyAppTheme.of(context).titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
