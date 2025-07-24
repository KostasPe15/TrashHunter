import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import '../Constants/Buttons/primary_button.dart';
import '../Constants/TextField/custom_textfield.dart';

class PublishPage extends StatefulWidget {
  final String address;

  const PublishPage(this.address, {super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  File? file;

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerDescription.dispose();
    super.dispose();
  }

  Future<File?> selectImage() async {
    final imagePicker = ImagePicker();
    XFile? picked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      return File(picked.path);
    }
    return null;
  }

  Future<GeoPoint?> getGeoPointFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        return GeoPoint(loc.latitude, loc.longitude);
      }
    } catch (e) {
      print('Error converting address to coordinates: $e');
    }
    return null;
  }

  Future<void> uploadPostToDb() async {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      if (file == null) throw Exception("No image selected");

      final geoPoint = await getGeoPointFromAddress(widget.address);
      if (geoPoint == null)
        throw Exception("Could not get coordinates for address");

      final imageRef = FirebaseStorage.instance
          .ref('images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final snapshot = await imageRef.putFile(file!);
      final imageURL = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection("posts").add({
        "title": controllerTitle.text.trim(),
        "description": controllerDescription.text.trim(),
        "imageURL": imageURL,
        "address": widget.address,
        "location": geoPoint,
        "timestamp": DateTime.now(),
        "user_id": auth.currentUser?.uid ?? "unknown"
      });

      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post uploaded')),
      );

      controllerTitle.clear();
      controllerDescription.clear();
      setState(() {
        file = null;
      });
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Display (Option A)
              Text(
                'Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.address,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 15),

              // Title Field
              CustomTextfield(
                controller: controllerTitle,
                label: 'Title',
              ),
              const SizedBox(height: 15),

              // Description Field
              CustomTextfield(
                controller: controllerDescription,
                label: 'Description',
              ),
              const SizedBox(height: 15),

              // Image Picker
              GestureDetector(
                onTap: () async {
                  final image = await selectImage();
                  if (image != null) {
                    setState(() {
                      file = image;
                    });
                  }
                },
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: file != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(file!, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Icon(Icons.upload_rounded,
                              size: 40, color: Colors.white38),
                        ),
                ),
              ),
              const SizedBox(height: 30),

              // Post Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: PrimaryButton(
                  text: 'POST',
                  height: 50,
                  width: 120,
                  onPressed: () async {
                    if (file == null ||
                        controllerTitle.text.trim().isEmpty ||
                        controllerDescription.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }
                    await uploadPostToDb();
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
