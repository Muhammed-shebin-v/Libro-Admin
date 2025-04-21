// import 'package:flutter/material.dart';
// import 'package:libro_admin/screens/ad_screen.dart';
// import 'package:libro_admin/screens/add_book.dart';
// import 'package:libro_admin/screens/home_screen.dart';
// import 'package:libro_admin/screens/login_screen.dart';


// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0; // Track selected page
//   bool _isCollapsed = false; // Track sidebar state

//   final List<Widget> _pages = [
//     HomeScreen(),
//     AddBook(),
//     AdScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // Side Navigation Bar
//           AnimatedContainer(
//             duration: Duration(milliseconds: 300), // Smooth animation
//             width: _isCollapsed ? 70 : 250, // Toggle width
//             color: Colors.blue.shade900,
//             child: Column(
//               children: [
//                 // Toggle Button
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: IconButton(
//                     icon: Icon(_isCollapsed ? Icons.menu_open : Icons.menu, color: Colors.white),
//                     onPressed: () {
//                       setState(() {
//                         _isCollapsed = !_isCollapsed;
//                       });
//                     },
//                   ),
//                 ),

//                 // App Logo & Name (Only if expanded)
//                 if (!_isCollapsed)
//                   Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Row(
//                       children: [
//                         Icon(Icons.ac_unit, color: Colors.white, size: 30),
//                         SizedBox(width: 10),
//                         Text("My App", style: TextStyle(color: Colors.white, fontSize: 18)),
//                       ],
//                     ),
//                   ),

//                 Divider(color: Colors.white54),

//                 // Navigation Buttons
//                 _buildNavItem(Icons.home, "Home", 0),
//                 _buildNavItem(Icons.settings, "Settings", 1),
//                 _buildNavItem(Icons.person, "Profile", 2),
//               ],
//             ),
//           ),

//           // Main Content Area
//           Expanded(
//             child: _pages[_selectedIndex],
//           ),
//         ],
//       ),
//     );
//   }

//   // Navigation Item Widget
//   Widget _buildNavItem(IconData icon, String label, int index) {
//     return ListTile(
//       leading: Icon(icon, color: _selectedIndex == index ? Colors.white : Colors.white54),
//       title: _isCollapsed ? null : Text(label, style: TextStyle(color: Colors.white)),
//       tileColor: _selectedIndex == index ? Colors.blueAccent : Colors.transparent,
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//     );}}