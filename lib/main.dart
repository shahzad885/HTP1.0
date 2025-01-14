import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:htp/Admin/Blogs/blogServicesProvider.dart';
import 'package:htp/Admin/DashboardServiceProvider.dart';
import 'package:htp/Admin/Users/UserServicesProvider.dart';
import 'package:htp/IntroScreens/IntroProvider.dart';
import 'package:htp/IntroScreens/intro_screen.dart';
import 'package:htp/User/SplashScreen/SplashServicesProvider.dart';
import 'package:htp/User/SplashScreen/Splash_Screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:htp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    name: 'imageHTP',
    options: DefaultFirebaseOptions.currentPlatform, // Firebase options
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  final prefs = await SharedPreferences.getInstance();
  final introCompleted = prefs.getBool('intro_completed') ?? false;

  runApp(MyApp(introCompleted: introCompleted));
}

class MyApp extends StatelessWidget {
  final bool introCompleted;

  const MyApp({super.key, required this.introCompleted});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashScreenProvider()),
        ChangeNotifierProvider(create: (context) => IntroProvider()),
        ChangeNotifierProvider(create: (context) => BlogservicesProvider()),
        ChangeNotifierProvider(create: (context) => AdminDashboardProvider()),
        ChangeNotifierProvider(create: (context) => UserServicesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
         home: introCompleted ? const SplashScreen() : const IntroScreen(), 
      ),
    );
  }
}
