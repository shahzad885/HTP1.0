import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htp/Admin/Blogs/AllBlogs.dart';
import 'package:htp/Admin/DashboardServiceProvider.dart';
import 'package:provider/provider.dart';
import 'package:htp/Admin/TestHitory/AllHtpHistory.dart';
import 'package:htp/Admin/Users/AllUsers.dart';
import 'package:htp/Admin/adminDrawer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer:  AdminDrawer(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
        child: Consumer<AdminDashboardProvider>(
          builder: (context, provider, child) {
            return Column(
//mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 40),
                  child: Text(
                    'Welcome to HTP' , style: GoogleFonts.pacifico(
                      fontSize: 30
                    ),
                  ),
                ),
                // Container for total users
                Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.01), // 1% of screen height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03), // 3% of screen width
                   // color: Colors.blueAccent,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person, 
                    // color: Colors.white, 
                    size: screenWidth * 0.1), // 10% of screen width
                    title: Text(
                      'Total Users',
                      style: GoogleFonts.montserrat(

                         //color: Colors.white,
                       fontSize: screenWidth * 0.045,
                      )
                    
                
                    ),
                    trailing: Text(
                      '${provider.getTotalUsers}',
                      style:  GoogleFonts.montserrat(

                         //color: Colors.white,
                       fontSize: screenWidth * 0.045,
                      )
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllUsersScreen(),
                        ),
                      );
                    },
                  ),
                ),

                // Container for total blogs
                Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.01), // 1% of screen height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03), // 3% of screen width
                      color: Colors.grey.withOpacity(0.2),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.article, 
                    // color: Colors.white, 
                    size: screenWidth * 0.1),
                    title: Text(
                      'Total Blogs',
                      style: GoogleFonts.montserrat(

                        //  color: Colors.white,
                       fontSize: screenWidth * 0.045,
                      )
                    ),
                    trailing: Text(
                      '${provider.getTotalBlogs}',
                      style:  GoogleFonts.montserrat(

                        //  color: Colors.white,
                       fontSize: screenWidth * 0.045,
                      )
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllBlogs(),
                        ),
                      );
                    },
                  ),
                ),

                // Container for total image analyses
                Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                     color: Colors.grey.withOpacity(0.2),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.image_search,
                    //  color: Colors.white, 
                     size: screenWidth * 0.1),
                    title: Text(
                      'Total Image Analyses',
                      style: GoogleFonts.montserrat(

                        //  color: Colors.white,
                       fontSize: screenWidth * 0.045,
                      )
                    ),
                    trailing: Text(
                      '${provider.getTotalImageAnalyses}',
                      style: GoogleFonts.montserrat(

                        //  color: Colors.white,
                       fontSize: screenWidth * 0.045,
                      )
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Allhtphistory(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
