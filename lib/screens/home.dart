import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:libro_admin/themes/fonts.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int selectedIndex = 0;
  bool isDrawerCollapsed = false;
  int bookcount=0;
  int usercount=0;
  int borrowscount=0;
  

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initializeBookCount();

  }

  Future<void> _initializeBookCount() async {
    bookcount = await findbooklength();
    usercount = await finduserlength();
    borrowscount = await findborrowslength();
    setState(() {});
  }

Future<int> findbooklength()async {
    final snapshot = await FirebaseFirestore.instance.collection('books').get();
     int count = snapshot.docs.length;
     return count;
  }
  Future<int> finduserlength()async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
     int count = snapshot.docs.length;
     return count;
  }
  Future<int> findborrowslength()async {
    final snapshot = await FirebaseFirestore.instance.collection('borrows').get();
     int count = snapshot.docs.length;
     return count;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    setState(() {
      isDrawerCollapsed = !isDrawerCollapsed;
      if (isDrawerCollapsed) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
  
          // Main content
          Container(
              color: AppColors.color60,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                // child: ConstrainedBox(
                //   constraints: const BoxConstraints(
                //     maxWidth: 500,
                //   ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DashBoard',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Row(
                            children: [
                              _buildSearchBar(),
                              const SizedBox(width: 16),
                              _buildNotificationBell(),
                              const SizedBox(width: 16),
                              _buildProfileAvatar(),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Stats row
                      Row(
                        children: [
                          _buildStatCard(
                            'Total Users',
                            usercount.toString(),
                            Icons.person_outline,
                            Colors.blue,
                            '+2.2% from last month',
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            'Total Fines',
                            '₹2,001',
                            Icons.payment_outlined,
                            Colors.orangeAccent,
                            '+2.2% from last month',
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            'Total Books',
                            bookcount.toString(),
                            Icons.book_outlined,
                            Colors.greenAccent,
                            '+2.2% from last month',
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            'Total Borrows',
                            borrowscount.toString(),
                            Icons.bookmark_border_outlined,
                            Colors.purpleAccent,
                            '+2.2% from last month',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Second row (Borrowed books and chart)
                      Flexible(
                        fit: FlexFit.loose,
                        child:
                         Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Borrows table
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 3,
                              child: 
                              _buildBorrowsTable(),
                            ),
                            const SizedBox(width: 16),
                            // Borrows chart and Overdue books
                            Flexible(
                              flex: 2,
                              // child:
                              //  ConstrainedBox(
                              //   constraints: BoxConstraints(maxHeight: 500),
                                 child: Column(
                                  children: [
                                    _buildBorrowsChart(),
                                    const SizedBox(height: 16),
                                    _buildOverdueCard(),
                                  ],
                                 ),
                               ),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Third row (Fine chart and Fines table)
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fine chart and Subscriptions
                            Flexible(
                              flex: 2,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 500),
                                child: Column(
                                  children: [
                                    _buildFineChart(),
                                    const SizedBox(height: 16),
                                    _buildSubscriptionsCard(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Fines table
                            Expanded(
                              flex: 3,
                              child: _buildFinesTable(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // ),
         
     
    );
  }












  Widget _buildSearchBar() {
    return Container(
      width: 300,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.keyboard, size: 16, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBell() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(Icons.notifications_outlined, color: Colors.grey),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepOrange, width: 2),
        shape: BoxShape.circle,
      ),
      child: const CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Flexible(
      fit: FlexFit.loose,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 500),
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBorrowsTable() {
    return Card(
      color: const Color(0xFFF2E2BA),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // child: ConstrainedBox(
        //   constraints: BoxConstraints(maxHeight: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Borrows',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Text('View more'),
                    label: const Icon(Icons.arrow_forward),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.primaries[index % Colors.primaries.length].shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.book, color: Colors.deepOrange),
                          ),
                          const SizedBox(width: 12),
                           Flexible(
                            flex: 2,
                            // child: SingleChildScrollView(
                            //   child: ConstrainedBox(
                            //     constraints: BoxConstraints(maxHeight: 500),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Book Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '655555555',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              // ),
                            // ),
                          ),
                           Flexible(
                            // child: SingleChildScrollView(
                            //   child: ConstrainedBox(
                            //     constraints: BoxConstraints(maxHeight: 500),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Author name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Fiction',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // ),
                          // ),
                          const Text(
                            '208',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'All Borrowed',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      // ),
    );
  }

  Widget _buildBorrowsChart() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // child: SingleChildScrollView(
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints(maxHeight: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Borrows chart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 90,width: double.infinity,),

                
              ],
            ),
        //   ),
        // ),
      ),
    );
  }

  Widget _buildOverdueCard() {
    return Container(
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overdue books',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.people, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  '2,001',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline, size: 14, color: Colors.green.shade400),
                                const SizedBox(width: 4),
                                Text(
                                  'Paid fine',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.warning_amber_outlined, size: 14, color: Colors.orange.shade400),
                                const SizedBox(width: 4),
                                Text(
                                  'Not paid fine',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      // ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.green.shade400,
                              value: 65,
                              title: '',
                              radius: 40,
                            ),
                            PieChartSectionData(
                              color: Colors.orange.shade400,
                              value: 35,
                              title: '',
                              radius: 40,
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                          startDegreeOffset: -90,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildFineChart() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // child: SingleChildScrollView(
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints(maxHeight: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fine Chart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 90),
              
              ],
            ),
          ),
      //   ),
      // ),
    );
  }

  Widget _buildSubscriptionsCard() {
    return Card(
      color: const Color(0xFFF2E2BA),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 500),
            child: Column(
               mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subscriptions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 500),
                        child: Column(
                           mainAxisSize: MainAxisSize.min, 
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.brown.shade300),
                                const SizedBox(width: 4),
                                Text(
                                  'Bronze',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.grey.shade400),
                                const SizedBox(width: 4),
                                Text(
                                  'Silver',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.warning_amber_outlined, size: 14, color: Colors.orange.shade400),
                                const SizedBox(width: 4),
                                Text(
                                  'Diamond',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.brown.shade300,
                              value: 45,
                              title: '',
                              radius: 40,
                            ),
                            PieChartSectionData(
                              color: Colors.grey.shade400,
                              value: 30,
                              title: '',
                              radius: 40,
                            ),
                            PieChartSectionData(
                              color: Colors.orange.shade400,
                              value: 25,
                              title: '',
                              radius: 40,
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                          startDegreeOffset: -90,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinesTable() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight:500 ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fines',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Text('View more'),
                      label: const Icon(Icons.arrow_forward),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                             Flexible(
                              fit: FlexFit.loose,
                              flex: 2,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 500),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Book Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '655555555',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Flexible(
                              fit: FlexFit.loose,
                              flex: 2,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Author name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Fiction',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Text(
                              '208',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'All Borrowed',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 
}