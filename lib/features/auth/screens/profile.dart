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
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityDistrictController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  String firebaseImg = '';
  File? image;
  bool isInitialized = false;

  @override
  void dispose() {
    nameController.dispose();
    stateController.dispose();
    cityDistrictController.dispose();
    designationController.dispose();
    professionController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void updateUserData() async {
    String name = nameController.text.trim();
    String state = stateController.text.trim();
    String cityDistrict = cityDistrictController.text.trim();
    String designation = designationController.text.trim();
    String profession = professionController.text.trim();
    print("     firebaseImg ${firebaseImg}");
    final imageToUpload = image;

    ref.read(authControllerProvider).saveUserDataToFirebase(
      context,
      name,
      imageToUpload,
      state,
      cityDistrict,
      designation,
      profession,
        firebaseImg,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
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
                print("user   ${user}");
                if (user != null) {
                  // Set the nameController text only once
                  if (!isInitialized) {
                    firebaseImg =user.profilePic;
                    nameController.text = user.name;
                    stateController.text = user.state!;
                    cityDistrictController.text = user.cityDistrict!;
                    designationController.text = user.designation!;
                    professionController.text = user.profession!;
                    isInitialized = true;
                  }

                  return SingleChildScrollView(
                    child: Center(
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
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              controller: designationController,
                              decoration: InputDecoration(
                                hintText: 'Enter your Designation',
                                labelText: 'Designation',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              controller: professionController,
                              decoration: InputDecoration(
                                hintText: 'Enter your profession',
                                labelText: 'Profession',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              controller: stateController,
                              decoration: InputDecoration(
                                hintText: 'Enter your state',
                                labelText: 'State',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              controller: cityDistrictController,
                              decoration: InputDecoration(
                                hintText: 'Enter your city',
                                labelText: 'City',
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

