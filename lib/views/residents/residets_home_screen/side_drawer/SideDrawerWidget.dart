import 'package:binpack_residents/views/auth/login_screen/login_screen.dart';
import 'package:binpack_residents/views/global/adoptAcommunity/dummy.dart';
// import 'package:binpack_residents/views/global/AI/SmartRecyclingScreen.dart';
import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/views/global/bank/screens/transactions/transactions_screen.dart';
import 'package:binpack_residents/views/global/e-waste/ewaste_centers_page.dart';
import 'package:binpack_residents/views/global/recycle%20_center/PikitupSitemapPage.dart';
import 'package:binpack_residents/views/residents/report_dump_site/reportDumpsitePage.dart';
import 'package:binpack_residents/views/residents/residets_about_screen/AboutScreen.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/dashboard/dashboard.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/side_drawer/widgets/logoWidget.dart';
import 'package:binpack_residents/views/residents/residets_profile_screen/resident_profile_screen.dart';
import 'package:binpack_residents/views/residents/residets_history_screen/history_screen/HistoryScreen.dart';
import 'package:binpack_residents/views/residents/residets_support_screen/SupportScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawerWidget extends StatefulWidget {
  final Residents resident;

  const SideDrawerWidget({super.key, required this.resident});

  @override
  _SideDrawerWidgetState createState() => _SideDrawerWidgetState();
}

class _SideDrawerWidgetState extends State<SideDrawerWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CenteredLogo(
                assetPath: 'assets/images/accesnts/binpackr-logo-name.png'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  _buildDrawerItem(Icons.person, 'My Profile', 0, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileEditPage(resident: widget.resident),
                      ),
                    );
                  }),
                  _buildDrawerItem(Icons.dashboard, 'Dashboard', 1, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResidentDashboardScreen(
                            userId: widget.resident.userID),
                      ),
                    );
                  }),
                  _buildDrawerItem(Icons.delete, 'E-waste & Bins', 2, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EWasteCentersPage(),
                      ),
                    );
                  }),
                  _buildDrawerItem(Icons.location_city, 'Recycle centers', 3,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PikitupSitemapPage(),
                      ),
                    );
                  }),
                  _buildDrawerItem(Icons.history, 'Bin History', 4, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HistoryScreen(resident: widget.resident),
                      ),
                    );
                  }),
                  _buildDrawerItem(
                      Icons.attach_money_sharp, 'eBins Transactions', 5, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionsScreen(
                              userId: widget.resident.userID)),
                    );
                  }),
                  _buildDrawerItem(
                      Icons.medical_information_outlined, 'About Binpack', 6,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutUsPage()),
                    );
                  }),
                  _buildDrawerItem(
                      Icons.groups_2_rounded, 'Adopt a Community', 7, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdoptCommunityScreen(),
                      ),
                    );
                  }),
                  _buildDrawerItem(Icons.support, 'Binpack Support', 8, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SupportPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.report, 'Report Dumpsite', 9, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportPage()),
                    );
                  }),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 8, 116, 13),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: TextButton(
                      onPressed: () => _logout(context),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Update the user's logged-in status in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'isLoggedIn': false});

        // Clear stored biometric preference and user ID in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('biometricEnabled');
        await prefs.remove('userId');

        // Sign out from Firebase
        await FirebaseAuth.instance.signOut();

        // Navigate back to the Login screen, removing all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } else {
        // If the user is null, show a warning message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently logged in.')),
        );
      }
    } catch (e) {
      // Display an error message in case of failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout. ${e.toString()}')),
      );
    }
  }

  Widget _buildDrawerItem(
      IconData icon, String text, int index, VoidCallback onTap) {
    bool isSelected = index == _selectedIndex;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? const Color.fromARGB(255, 8, 116, 13)
              : Colors.transparent,
          border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        child: Icon(
          icon,
          color:
              isSelected ? Colors.white : const Color.fromARGB(255, 8, 116, 13),
        ),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: isSelected
              ? const Color.fromARGB(255, 8, 116, 13)
              : const Color.fromARGB(255, 51, 49, 49),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        onTap();
      },
    );
  }
}
