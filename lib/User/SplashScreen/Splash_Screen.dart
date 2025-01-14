import 'package:flutter/material.dart';
import 'package:htp/User/SplashScreen/SplashServicesProvider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashScreenProvider = Provider.of<SplashScreenProvider>(context);

    // Trigger checkLoginStatus after the first frame
    Future.delayed(Duration.zero, () {
      splashScreenProvider.checkLoginStatus(context);
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: splashScreenProvider.isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Use Image.asset instead of Lottie
                  Image.asset(
                    'assets/splashImage.png', // Replace with your image asset
                    width: screenWidth * 0.15, // 60% of screen width
                    height: screenHeight * 0.15, // 30% of screen height
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  // Text(
                  //   'Welcome to HTP!',
                  //   style: GoogleFonts.roboto(
                  //       fontSize: screenWidth * 0.06, // Scalable font size
                  //       fontWeight: FontWeight.bold),
                  // ),
                ],
              )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/splashImage.png', 
                  width: screenWidth * 0.15, 
                  height: screenHeight * 0.15, 
                  fit: BoxFit.contain,
                ),
                SizedBox(height: screenHeight * 0.02), 
                         
              ],
            ),
      ),
    );
  }
}
