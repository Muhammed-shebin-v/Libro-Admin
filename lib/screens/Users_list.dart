import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:libro_admin/bloc/user/users_bloc.dart';
import 'package:libro_admin/bloc/user/users_event.dart';
import 'package:libro_admin/bloc/user/users_state.dart';
import 'package:libro_admin/models/user.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/filter.dart';
import 'package:libro_admin/widgets/long_button.dart';
import 'package:libro_admin/widgets/search_bar.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  // final CollectionReference users = FirebaseFirestore.instance.collection(
  //   'users',
  // );
  // Future<List<QueryDocumentSnapshot>> fetchUsers() async {
  //   try {
  //     QuerySnapshot snapshot = await users.get();
  //     log('fetched users');
  //     return snapshot.docs;
  //   } catch (e) {
  //     log("Error fetching data: $e");
  //     return [];
  //   }
  // }

  Map<String, dynamic>? selectedUser;

  final FilterController filterController2 = FilterController([
    'Fiction',
    'Non-Fiction',
    'Science',
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserLoaded) {
            final user=state.selectedUser;
            return Row(
              children: [
                Expanded(flex: 4, child: _buildMainContent(state)),
                SizedBox(width: 400,
                 child:Container(
      decoration: BoxDecoration(
        color: AppColors.color30,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      child:
          user == null
              ? Center(
                child: Text(
                  'Select a user to view details',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.notifications),
                          const SizedBox(width: 8),
                          Text(user['fullName']),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {},
                        tooltip: 'block',
                      ),
                    ],
                  ),
                  const Divider(),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: user['imgUrl']!=null?
                          ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.network(user['imgUrl'],fit: BoxFit.fill,)):null
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user['username'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user['email'],
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        onPressed: () {},
                        iconSize: 28,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.phone),
                        onPressed: () {},
                        iconSize: 28,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.email_outlined),
                        onPressed: () {},
                        iconSize: 28,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoSection('MemberShip', [
                          InfoItem('Type', 'Platinum'),
                          InfoItem('Exp', '12/2/2025'),
                        ]),
                      ),
                      Expanded(
                        child: _buildInfoSection('Score', [
                          InfoItem('May', user['score'].toString()),
                          InfoItem('Total',user['score'].toString()),
                        ]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoSection('Address', [
                          InfoItem('', user['address']),
                        ]),
                      ),
                      Expanded(
                        child: _buildInfoSection('Phone', [
                          InfoItem('', user['phoneNumber']),
                        ]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Current Borrows',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Gap(10),
                  Container(
                    height: 100,
                    decoration: 
                    BoxDecoration(
                      color: AppColors.color60,
                      border: Border.all()
                    ),
                  ),
                  const Text(
                    'Total Fine Collected',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Gap(10),
                  Container(
                    height: 150,
                    decoration: 
                    BoxDecoration(
                      color: AppColors.color60,
                      border: Border.all()
                    ),
                  ),
                  const SizedBox(height: 20),
                 CustomLongButton(title: 'Show all Info', ontap: (){})
                ],
              ),
    )),
              ],
            );
          }
          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }

  Widget _buildMainContent(UserLoaded state) {
    return Padding(
      padding: EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Users Infos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.sort),
                    label: const Text('Sort'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8E8E8),
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.filter_alt),
                    label: const Text('Filter'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8E8E8),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),

          //  FilterButton(filters: _filters,isBook: false,),
          FilterButton(
            filters: filterController2.filters,
            controller: filterController2,
          ),
          const Divider(),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Gap(50),
                      Text(
                        'Name',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                _buildTableHeader('ID', flex: 2),
                _buildTableHeader('Email'),
                _buildTableHeader('Place'),
                _buildTableHeader('M.type'),
                _buildTableHeader('Block'),
              ],
            ),
          ),
          Expanded(
            // child: FutureBuilder<List<QueryDocumentSnapshot>>(
            //   future: fetchUsers(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(child: CircularProgressIndicator());
            //     }
            //     if (!snapshot.hasData ||
            //         snapshot.data!.isEmpty ||
            //         snapshot.data == null) {
            //       return Center(child: Text("No studentssss found"));
            //     }
            //     var users = snapshot.data!;
            //     return SizedBox(
            //       height: 700,
            child: ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                bool isSelected =
                    state.selectedUser != null && state.selectedUser!['uid'] == user['uid'];
                    
                return InkWell(
                  onTap: () {
                   context.read<UserBloc>().add(SelectUser(user));
                    // setState(() {
                    //   selectedUser = user;
                    // });
                  },
               
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.color10
                              : (index % 2 == 0
                                  ? Colors.white
                                  : AppColors.color60),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: ClipRRect(
                                    
                                    borderRadius: BorderRadius.circular(80),
                                    child: user['imgUrl']==null?
                                     Icon(
                                      Icons.person,
                                      size: 20,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    
                                    ):Image.network(user['imgUrl'],fit: BoxFit.fill,)
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(user['username']),
                              ],
                            ),
                          ),
                          Expanded(flex: 2, child: Text(user['uid'])),
                          Expanded(child: Text(user['email'])),
                          Expanded(child: Text(user['address'])),
                          Expanded(child: Text(user['phoneNumber'])),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                user['isBlock']==null?
                                Text(user['username']):Text(user['isBlock'].toString())
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTableHeader(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoSection(String title, List<InfoItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                if (item.label.isNotEmpty) Text('${item.label}:'),
                if (item.label.isNotEmpty) SizedBox(width: 4),
                Expanded(child: Text(item.value)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class InfoItem {
  final String label;
  final String value;

  InfoItem(this.label, this.value);
}
