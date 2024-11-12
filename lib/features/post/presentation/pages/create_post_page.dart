import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social/core/presentation/components/blue_button.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String? postImagePath;
  final captionController = TextEditingController();

  void pickImage() async {
    // pick an image
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) Navigator.pop(context);

    // crop image
    final ImageCropper imageCropper = ImageCropper();
    final CroppedFile? cropped = await imageCropper.cropImage(
      sourcePath: image!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (cropped == null) Navigator.pop(context);

    setState(() {
      postImagePath = cropped!.path;
    });
  }

  void createPost() {
    final currUser = context.read<AuthCubit>().currUser;
    context.read<PostCubit>().createPost(
          currUser!.id,
          currUser.name,
          captionController.text,
          postImagePath!,
        );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    pickImage();
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('New post')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // post image
            Image.file(
              File(postImagePath ?? ''),
              width: 250,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),

            const SizedBox(height: 10),

            // caption
            TextField(
              controller: captionController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Add a caption...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
              maxLines: 4,
            ),

            const Expanded(child: SizedBox()),

            // upload button
            BlueButton(
              height: 48,
              text: 'Share',
              onTap: createPost,
            ),
          ],
        ),
      ),
    );
  }
}
