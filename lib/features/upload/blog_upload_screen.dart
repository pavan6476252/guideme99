import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/utils/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:simple_markdown_editor/widgets/markdown_form_field.dart';

class BlogUploadScreen extends StatefulWidget {
  const BlogUploadScreen({super.key});

  @override
  _BlogUploadScreenState createState() => _BlogUploadScreenState();
}

class _BlogUploadScreenState extends State<BlogUploadScreen> {
  // Define the text editing controllers for the form fields
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _hashTagsController = TextEditingController();
  final _categoryController = TextEditingController();

  // Define variables for the image picker
  File? _imageFile;
  final _picker = ImagePicker();

  // Define a method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Define a method to upload the blog to Firebase
  Future<void> _uploadBlog() async {
    try {
      // Get the current user's name and email
      final currentUser = FirebaseAuth.instance.currentUser;
      final userName = currentUser?.displayName ?? '';
      final userEmail = currentUser?.email ?? '';
      final userProfile = currentUser?.photoURL ?? '';

      // Upload the image to Firebase Storage and get the download URL
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('blog_images')
          .child(path.basename(_imageFile!.path));
      final uploadTask = storageRef.putFile(_imageFile!);
      final downloadUrl = await (await uploadTask).ref.getDownloadURL();

      // Create a new blog document in Firebase Firestore
      final blogRef = FirebaseFirestore.instance.collection('blogs').doc();
      final markdownBody = _bodyController.text;
      final currentDate = DateTime.now();
      await blogRef.set({
        'title': _titleController.text,
        'authorProfile': userProfile,
        'authorName': userName,
        'authorEmail': userEmail,
        'date': currentDate,
        'image': downloadUrl,
        'hashTags': _hashTagsController.text.split(','),
        'category': _categoryController.text,
        'body': markdownBody,
      });

      // Show a success message
      showToast("Successfully uploaded");

      // Clear the form fields
      _titleController.clear();
      _bodyController.clear();
      _hashTagsController.clear();
      _categoryController.clear();
      setState(() {
        _imageFile = null;
      });
    } catch (error) {
      print(error);
      // Show an error message
      showToast("error", isError: true);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload Blog'),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 300.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: _imageFile != null
                              ? Image.file(_imageFile!, fit: BoxFit.cover)
                              : Icon(Icons.add_a_photo, size: 50.0),
                        ),
                      ),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _hashTagsController,
                        decoration: const InputDecoration(
                          labelText: 'Hash Tags (Space Separated)',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one hash tag';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Categories (Space Separated)',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one category';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 300,
                        width: double.maxFinite,
                        child: MarkdownFormField(
                          style: const TextStyle(fontSize: 20),
                          controller: _bodyController,
                          enableToolBar: true,
                          emojiConvert: true,
                          autoCloseAfterSelectEmoji: false,
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  showToast("uploading post", isLoading: true);
                                  _uploadBlog();
                                }
                              },
                              child: const Text("submit"))),
                    ]),
              ),
            )));
  }
}
