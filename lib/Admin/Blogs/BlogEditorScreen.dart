import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:htp/Admin/Blogs/blogServicesProvider.dart';
import 'package:htp/User/HTP-Services/ImageServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class BlogEditorScreen extends StatefulWidget {
  const BlogEditorScreen({super.key});

  @override
  State<BlogEditorScreen> createState() => _BlogEditorScreenState();
}

class _BlogEditorScreenState extends State<BlogEditorScreen> {
  final TextEditingController _blogTitleController = TextEditingController();
  final QuillController _controller = QuillController.basic();
  final ImageService imageService = ImageService();

  String? blogImageUrl;
  String? uid;

  @override
  void initState() {
    super.initState();
    _initializeUid();
  }

  void _initializeUid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  Future<void> handleImageSelectionAndUpload() async {
    try {
      await imageService.pickFile(context);
      final uploadedUrl = await imageService.uploadToServer(context);

      if (uploadedUrl != null) {
        setState(() {
          blogImageUrl = uploadedUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void saveBlogToFirestore() async {
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in!')),
      );
      return;
    }

    final blogContent = _controller.document.toPlainText();
    final title = _blogTitleController.text;

    if (title.isEmpty || blogContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title or content cannot be empty!')),
      );
      return;
    }

    if (blogImageUrl == null || blogImageUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload an image first!')),
      );
      return;
    }

    final blogServices = Provider.of<BlogservicesProvider>(context, listen: false);
    await blogServices.saveBlog(title, blogContent, blogImageUrl!, uid!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Blog saved ')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveBlogToFirestore,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              QuillSimpleToolbar(
                controller: _controller,
                configurations: const QuillSimpleToolbarConfigurations(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _blogTitleController,
                    decoration: const InputDecoration(
                      hintText: '                                  Blog Title',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Image Upload Button 
                  IconButton(onPressed: 
                    handleImageSelectionAndUpload,
                   icon: const Icon(Icons.image)),
                  // ElevatedButton(
                  //   onPressed: handleImageSelectionAndUpload,
                  //   child: const Text('Pick and Upload Image'),
                  // ),

                  // Display the uploaded image (if available)
                  if (blogImageUrl != null)
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                      child: Image.network(
                        blogImageUrl!,
                        height: screenHeight * 0.2,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Content',
                    style: TextStyle(
                     // color: Colors.grey[500],
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  QuillEditor.basic(
                    controller: _controller,
                    configurations: const QuillEditorConfigurations(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
