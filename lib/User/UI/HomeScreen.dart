import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htp/User/HTP-Services/ImageServices.dart';
import 'package:htp/User/Widgets/CRoundButton.dart';
import 'package:htp/User/UI/Drawer.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final ImageService _imageService = ImageService();  // Initialize ImageService
  bool _isUploading = false;
  String? _jsonResponse;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          const DrawerScreen(),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor),
            duration: const Duration(milliseconds: 250),
            decoration: isDrawerOpen
                ? BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))
                : const BoxDecoration(color: Colors.white),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Analyze Image'),
                leading: IconButton(
                  icon: isDrawerOpen
                      ? const Icon(Icons.arrow_back_ios)
                      : const Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      if (isDrawerOpen) {
                        xOffset = 0;
                        yOffset = 0;
                        scaleFactor = 1;
                        isDrawerOpen = false;
                      } else {
                        xOffset = 230;
                        yOffset = 150;
                        scaleFactor = 0.6;
                        isDrawerOpen = true;
                      }
                    });
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _imageService.pickFile(context);
                          setState(() {
                            _jsonResponse = _imageService.jsonResponse;
                          });
                        },
                        child: Container(
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _imageService.selectedFileBytes == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined, size: 50, color: Colors.grey),
                                    Text('Tap to select an image', style: TextStyle(color: Colors.grey)),
                                  ],
                                )
                              : Image.memory(_imageService.selectedFileBytes!, fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_jsonResponse != null) ...[
                        const Text(' Response:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        const SizedBox(height: 10),
                        Text(
                          _jsonResponse!,
                          style: GoogleFonts.roboto(
                        fontSize: screenWidth * 0.045,
                        color: Colors.black,
                      ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      CRoundButton(
                        buttonText: 'Analyze Image',
                        onTap: () async {
                          setState(() {
                            _isUploading = true;
                          });
                          await _imageService.analyzeImage(context);
                          setState(() {
                            _jsonResponse = _imageService.jsonResponse;
                            _isUploading = false;
                          });
                        },
                        loading: _isUploading,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
