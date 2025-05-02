import 'package:flutter/material.dart';
import 'package:libro_admin/screens/Users_list.dart';
import 'package:libro_admin/screens/Books_list.dart';
import 'package:libro_admin/screens/ad_screen.dart';
import 'package:libro_admin/screens/add_book.dart';
import 'package:libro_admin/screens/home_screen.dart';
import 'package:libro_admin/screens/login_screen.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
   void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        var fadeAnimation = Tween(
          begin: begin,
          end: end,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        return FadeTransition(opacity: fadeAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void _navigateToScreen(BuildContext context, String screenName) {
    if (screenName == widget.currentScreen) return;

    Widget nextScreen;

    switch (screenName) {
      case 'Home':
        nextScreen = LibroWebLayout(
          currentScreen: 'Home',
          child: HomeScreen(),
        );
        break;
      case 'Users':
        nextScreen = LibroWebLayout(
          currentScreen: 'Users',
          child: UserManagementScreen(),
        );
        break;
         case 'AD':
        nextScreen = LibroWebLayout(
          currentScreen: 'AD',
          child: AdScreen(),
        );
        break;
      case 'Books':
        nextScreen = LibroWebLayout(
          currentScreen: 'Books',
          child: LibraryManagementScreen(),
        );
        break;
      case 'AddBook':
        nextScreen = LibroWebLayout(currentScreen: 'AddBook', child: AddBook());
        break;
      default:
        nextScreen = LibroWebLayout(
          currentScreen: 'Dashboard',
          child: LoginScreen(),
        );
    }

    Navigator.pushReplacement(context, _createPageRoute(nextScreen));
  }

  final List<Map<String, dynamic>> _sidebarItems = [
    {'title': 'Home', 'icon': Icons.home},
    {'title': 'Users', 'icon': Icons.verified_user},
    {'title': 'Books', 'icon': Icons.book},
    {'title': 'AddBook', 'icon': Icons.add},
    {'title': 'AD', 'icon': Icons.newspaper},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
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
                color: AppColors.color30,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
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
                            _isExpanded
                                ? Icons.chevron_left
                                : Icons.chevron_right,
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sidebarItems.length,
                      itemBuilder: (context, index) {
                        final item = _sidebarItems[index];
                        final isSelected =
                            widget.currentScreen == item['title'];

                        return InkWell(
                          onTap: () {
                            _navigateToScreen(context, item['title']);
                          },
                          child: Container(
                            height: 50,
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(


// something new

                              children: [
                                Icon(
                                  item['icon'],
                                  color:
                                      isSelected
                                          ?  AppColors.color10
                                          : Colors.black54,
                                ),
                                if (_isExpanded) ...[
                                  const SizedBox(width: 15),
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? AppColors.color10
                                              : Colors.black87,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Row(
                        children: [
                          IconButton(onPressed: (){
                            _logout(context);
                          }, icon: Icon(Icons.logout)) ,
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
                ],
              ),
            ),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
