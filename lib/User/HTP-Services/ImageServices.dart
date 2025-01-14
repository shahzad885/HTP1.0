import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:htp/User/Utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageService {
  final fireStore = FirebaseFirestore.instance.collection('HTP-History');
  final picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;

  Uint8List? selectedFileBytes;
  String? selectedFileName;
  String? jsonResponse;

  Future<void> pickFile(BuildContext context) async {
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        selectedFileBytes = await pickedFile.readAsBytes();
        selectedFileName = pickedFile.name;
        jsonResponse = null;
      } else {
        Utils().ToastMessage('No image selected');
      }
    } catch (e) {
      Utils().ToastMessage('Error selecting file: $e');
    }
  }

  Future<String?> uploadToServer(BuildContext context) async {
    if (selectedFileBytes == null || selectedFileName == null) {
      Utils().ToastMessage('Please select an image first');
      return null;
    }

    try {
      var uri =
          Uri.parse('https://umairpersonalfileuploader-self.vercel.app/upload');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes(
          'image', selectedFileBytes!,
          filename: selectedFileName));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
       Utils().ToastMessage('analyzing image please wait');
        return jsonResponse['imageUrl'];
      } else {
        Utils().ToastMessage('Image upload failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      Utils().ToastMessage('Error uploading file: $e');
      return null;
    }
  }

  Future<void> analyzeImage(BuildContext context) async {
    if (selectedFileBytes == null || selectedFileName == null) {
      Utils().ToastMessage('Please select an image first');
      return;
    }

    try {
      String? imageUrl = await uploadToServer(context);

      if (imageUrl == null) {
        Utils().ToastMessage('Image upload failed, please try again');
        return;
      }

      var uri = Uri.parse(
          'https://htp-model-umairahmedyounas1987gmailcoms-projects.vercel.app/analyze-image');
      var response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'imageUrl': imageUrl}));

      if (response.statusCode == 200) {
        jsonResponse = response.body.replaceAll(RegExp(r'[{}\[\]]'), '').trim();
        await saveToHistory(imageUrl, jsonResponse!);
        Utils().ToastMessage('Image analyzed successfully');
      } else {
        Utils().ToastMessage(' Analysis failed: ${response.statusCode}');
      }
    } catch (e) {
      Utils().ToastMessage('Error analyzing image: $e');
    }
  }

  Future<void> saveToHistory(String imageUrl, String response) async {
    try {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      await fireStore.doc(id).set({
        'uid': user?.uid,
        'imageURL': imageUrl,
        'response': response,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Utils().ToastMessage('Error saving to history: $e');
    }
  }
}
