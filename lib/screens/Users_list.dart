import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/bloc/user/users_bloc.dart';
import 'package:libro_admin/bloc/user/users_event.dart';
import 'package:libro_admin/bloc/user/users_state.dart';
import 'package:libro_admin/screens/user_details.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/filter.dart';
import 'package:libro_admin/widgets/search_bar.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  Map<String, dynamic>? selectedUser;
  final TextEditingController searchController = TextEditingController();

  final FilterController filterController2 = FilterController([
    'Fiction',
    'Non-Fiction',
    'Science',
  ]);
    String? _selectedSort;
  final List<String> _sortOptions = ['Alphabetical', 'Latest'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.all(1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(
                    controller: searchController,
                    onchanged: (query) {
                      context.read<UserBloc>().add(SearchUsers(query));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Users Infos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          return DropdownButton<String>(
                            underline: const SizedBox(),
                            hint: Text(_selectedSort ?? 'Sort by'),
                            value: _selectedSort,
                            items:
                                _sortOptions.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _selectedSort = newValue;
                                context.read<UserBloc>().add(
                                  SortChanged(newValue),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.filter_alt),
                            label: const Text('Filter'),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.grey,
                              foregroundColor: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Gap(10),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is UserLoaded) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              bool isSelected =
                                  state.selectedUser != null &&
                                  state.selectedUser!.uid == user.uid;

                              return InkWell(
                                onTap: () {
                                  context.read<UserBloc>().add(
                                    SelectUser(user),
                                  );
                                },

                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? AppColors.color10
                                            : (index % 2 == 0
                                                ? AppColors.white
                                                : AppColors.color60),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
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
                                                  borderRadius:
                                                      BorderRadius.circular(80),
                                                  child:
                                                     Image.network(
                                                            user.imgeUrl,
                                                            fit: BoxFit.fill,
                                                          ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(user.userName),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(user.uid),
                                        ),
                                        Expanded(child: Text(user.email)),
                                        Expanded(child: Text(user.place)),
                                        Expanded(
                                          child: Text(user.phoneNumber),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: const BoxDecoration(
                                                  color: AppColors.secondary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                    user.isBlock.toString(),
                                                  ),
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
                        );
                      } else if (state is UserError) {
                        return Center(child: Text(state.message));
                      } else {
                        return Center(child: Text('something went wrong'));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          UserDetails(),
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
}
