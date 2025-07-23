import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro_admin/bloc/user/users_bloc.dart';
import 'package:libro_admin/bloc/user/users_state.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/chatScreen.dart';

class UserDetails extends StatelessWidget {
  UserDetails({super.key});

  final TextEditingController _copy = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.color30,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final user = state.selectedUser;
              _copy.text = user?.phoneNumber ?? '';

              return user == null
                  ? Center(
                      child: Text(
                        'Select a user to view details',
                        style: TextStyle(fontSize: 16, color: AppColors.grey),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         const Icon(Icons.notifications),
                        //         const SizedBox(width: 8),
                        //         Text(user.userName),
                        //       ],
                        //     ),
                        //     IconButton(
                        //       icon: const Icon(Icons.close),
                        //       onPressed: () {},
                        //       tooltip: 'block',
                        //     ),
                        //   ],
                        // ),
                        // const Divider(),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Image.network(
                                    user.imgeUrl,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                user.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.email,
                                style: TextStyle(color: AppColors.black),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Chatscreen(userId: user.uid,userName: user.userName),
                                  ),
                                );
                              },
                              iconSize: 28,
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              icon: const Icon(Icons.phone),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: _copy.text));
                              },
                              iconSize: 28,
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                        const Gap(20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildInfoSection('MemberShip', [
                                InfoItem('Type', user.subType),
                                InfoItem('Exp' ,(DateFormat('dd-MM-yy').format(user.subDate)).toString()),
                              ]),
                            ),
                            Expanded(
                              child: _buildInfoSection('Score', [
                                InfoItem('May', user.score.toString()),
                                InfoItem('Total', user.score.toString()),
                              ]),
                            ),
                          ],
                        ),
                        const Gap(20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildInfoSection('Address', [
                                InfoItem('', user.place),
                              ]),
                            ),
                            Expanded(
                              child: _buildInfoSection('Phone', [
                                InfoItem('', user.phoneNumber),
                              ]),
                            ),
                          ],
                        ),
                        const Gap(20),
                        // const Text(
                        //   'Current Borrows',
                        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        // ),
                        // const Gap(10),
                        // Container(
                        //   height: 100,
                        //   decoration: BoxDecoration(
                        //     color: AppColors.color60,
                        //     border: Border.all(),
                        //   ),
                        // ),
                        // const Gap(10),
                        // const Text(
                        //   'Total Fine Collected',
                        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        // ),
                        // const Gap(10),
                        // Container(
                        //   height: 150,
                        //   decoration: BoxDecoration(
                        //     color: AppColors.color60,
                        //     border: Border.all(),
                        //   ),
                        // ),
                        // const SizedBox(height: 20),
                        // CustomLongButton(title: 'Show all Info', ontap: () {}),
                      ],
                    );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
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
                if (item.label.isNotEmpty) const SizedBox(width: 4),
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
