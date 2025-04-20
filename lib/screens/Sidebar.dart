import 'package:flutter/material.dart';
import 'package:libro_admin/gpt/gpt1.dart';
import 'package:libro_admin/gpt/gpt2.dart';
import 'package:libro_admin/screens/add_book.dart';
import 'package:libro_admin/screens/login_screen.dart';

class LibroWebLayout extends StatefulWidget {
  final Widget child; 
  final String currentScreen; 

  const LibroWebLayout({
    super.key,
    required this.child,
    required this.currentScreen,
  });

  @override
  State<LibroWebLayout> createState() => _LibroWebLayoutState();
}

class _LibroWebLayoutState extends State<LibroWebLayout> {
  bool _isExpanded = true; 

PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        var fadeAnimation = Tween(begin: begin, end: end).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        );
        
        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
  void _navigateToScreen(BuildContext context, String screenName) {
    if (screenName == widget.currentScreen) return;

    Widget nextScreen;
    

    switch (screenName) {
      case 'Profile':
        nextScreen = LibroWebLayout(
          currentScreen: 'Profile',
          child: LoginScreen()
        );
        break;
      case 'Dashboard':
        nextScreen = LibroWebLayout(
          currentScreen: 'Dashboard',
          child: UserManagementScreen(), 
        );
        break;
      case 'Books':
        nextScreen = LibroWebLayout(
          currentScreen: 'Books',
          child: LibraryManagementScreen(), 
        );
        break;
      default:
        nextScreen = LibroWebLayout(
          currentScreen: 'Dashboard',
          child:  LoginScreen(),
        );
    }


    Navigator.pushReplacement(
      context,
      _createPageRoute(nextScreen),
    );
  }


  final List<Map<String, dynamic>> _sidebarItems = [
    {
      'title': 'Dashboard',
      'icon': Icons.dashboard,
    },
    {
      'title': 'Books',
      'icon': Icons.book,
    },
    // {
    //   'title': 'My Library',
    //   'icon': Icons.library_books,
    // },
    // {
    //   'title': 'Subscriptions',
    //   'icon': Icons.subscriptions,
    // },
    {
      'title': 'Profile',
      'icon': Icons.person,
    },
    // {
    //   'title': 'Settings',
    //   'icon': Icons.settings,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 229, 214),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isExpanded ? 200 : 90,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                border: Border.all(),
                color: const Color.fromARGB(255, 244, 173, 79),
               borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  // App Logo and Toggle button
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        if (_isExpanded) ...[
                          const Text(
                            'Libro',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                        ],
                        IconButton(
                          icon: Icon(
                            _isExpanded ? Icons.chevron_left : Icons.chevron_right,
                          ),
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  
                  // Navigation items
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sidebarItems.length,
                      itemBuilder: (context, index) {
                        final item = _sidebarItems[index];
                        final isSelected = widget.currentScreen == item['title'];
                        
                        return InkWell(
                          onTap: () {
                            // Navigate to the selected screen
                            _navigateToScreen(context, item['title']);
                          },
                          child: Container(
                            height: 50,
                            color: isSelected ? Colors.grey.withOpacity(0.2) : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Icon(
                                  item['icon'],
                                  color: isSelected ? Theme.of(context).primaryColor : Colors.black54,
                                ),
                                if (_isExpanded) ...[
                                  const SizedBox(width: 15),
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Logout button at bottom
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        // Handle logout
                        // Navigate to login screen after logout
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) =>  LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            const Icon(Icons.logout, color: Colors.red),
                            if (_isExpanded) ...[
                              const SizedBox(width: 15),
                              const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

