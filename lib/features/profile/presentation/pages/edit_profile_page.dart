import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/core/presentation/components/my_textfield.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final String id;
  final String name;
  final String profileImageUrl;
  final String bio;

  const EditProfilePage({
    super.key,
    required this.id,
    required this.profileImageUrl,
    required this.bio,
    required this.name,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final nameController = TextEditingController(text: widget.name);
  late final bioController = TextEditingController(text: widget.bio);

  String? newProfileImagePath;

  void pickImage() async {
    // pick an image
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    // crop image
    final ImageCropper imageCropper = ImageCropper();
    final CroppedFile? cropped = await imageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (cropped == null) return;

    setState(() {
      newProfileImagePath = cropped.path;
    });
  }

  void updateProfile() async {
    // name can't be empty
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name can\'t be empty')),
      );
      return;
    }

    // one of the field/pfp is updated
    if (newProfileImagePath != null ||
        nameController.text != widget.name ||
        bioController.text != widget.bio) {
      context.read<ProfileCubit>().updateProfile(
            id: widget.id,
            newName: nameController.text,
            newProfileImagePath: newProfileImagePath,
            newBio: bioController.text,
          );
      Navigator.pop(context);
    }

    // no change made
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to update')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 'appbar'
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: updateProfile,
                  child: const Text('Done'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // profile picture
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: newProfileImagePath == null
                    ? Image.network(
                        widget.profileImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'images/default_pfp.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.file(
                        File(newProfileImagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'images/default_pfp.png',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            // change pfp button
            TextButton(
              onPressed: pickImage,
              child: const Text('Change Profile Picture'),
            ),

            // name text field
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name text field
                    const Text('Name'),
                    MyTextfield(
                      controller: nameController,
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // bio text field
                    const Text('Bio'),
                    MyTextfield(
                      controller: bioController,
                      obscureText: false,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
