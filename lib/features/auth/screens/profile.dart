import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/models/user_model.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const routeName = '/profile-page';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void updateUserData() async {
    String name = nameController.text.trim();

    if (name.isNotEmpty || image != null) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
        context,
        name,
        image,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final userAsyncValue = ref.watch(userDataAuthProvider);

            return userAsyncValue.when(
              data: (user) {
                if (user != null) {
                  nameController.text = user.name;
                  return Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: image != null
                                  ? FileImage(image!)
                                  : NetworkImage(user.profilePic) as ImageProvider,
                              radius: 64,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: selectImage,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: 18,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: updateUserData,
                          child: Text('Update Profile'),
                        ),
                      ],
                    ),
                  );
                }
                return Center(child: Text('User data not found.'));
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            );
          },
        ),
      ),
    );
  }
}
