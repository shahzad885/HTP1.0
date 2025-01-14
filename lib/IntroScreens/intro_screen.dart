import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htp/IntroScreens/IntroPageContent.dart';
import 'package:htp/IntroScreens/IntroProvider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final introProvider = Provider.of<IntroProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: introProvider.controller,
                  onPageChanged: (index) {
                    introProvider.currentPage = index;
                  },
                  children: const [
                    IntroPageContent(
                      title: "Welcome to HTP!",
                      description:
                          "Your one-stop solution for hassle-free app management.",
                      lottieAsset: "assets/Intro1.json",
                    ),
                    IntroPageContent(
                      title: "Secure and Reliable",
                      description:
                          "We prioritize your data privacy and security.",
                      lottieAsset: "assets/Intro2.json",
                    ),
                    IntroPageContent(
                      title: "Get Started Today!",
                      description:
                          "Sign in and explore the amazing features of HTP.",
                      lottieAsset: "assets/Intro3.json",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: introProvider.controller,
                      count: 3,
                      effect: WormEffect(
                        dotHeight: screenHeight * 0.012,
                        dotWidth: screenWidth * 0.025,
                        spacing: screenWidth * 0.02,
                        activeDotColor: Colors.black,
                        dotColor: Colors.grey,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                   
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.05,
            child: introProvider.currentPage == 2
                ? GestureDetector(
                    onTap: () {
                      if (introProvider.currentPage == 2) {
                        introProvider.completeIntro(context);
                      } else {
                        introProvider.controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      "Get Started",
                      style: GoogleFonts.roboto(
                        fontSize: screenWidth * 0.045,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      introProvider.controller
                          .jumpToPage(2); 
                    },
                    child: Text(
                      "Skip",
                      style: GoogleFonts.roboto(
                        fontSize: screenWidth * 0.045,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

