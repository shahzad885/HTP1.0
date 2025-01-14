
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPageContent extends StatelessWidget {
  final String title;
  final String description;
  final String lottieAsset;

  const IntroPageContent({
    required this.title,
    required this.description,
    required this.lottieAsset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          lottieAsset,
          width: screenWidth * 0.7,
          height: screenHeight * 0.4,
          fit: BoxFit.contain,
        ),
        SizedBox(height: screenHeight * 0.04),
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
