// // admin_home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:libro_admin/models/user.dart';
// import 'package:libro_admin/widgets/noti.dart';

// class AdminHomeScreen extends StatelessWidget {
//   const AdminHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Dashboard')),
//       body: BlocConsumer<AdminBloc, AdminState>(
//         listener: (context, state) {
//           if (state is AdminError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//           if (state is NotificationSentSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Notification sent successfully')),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is AdminLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
          
//           if (state is UsersLoaded) {

//             return  _buildUserList(state.users);
//           }
          
//           return const Center(child: Text('No user data available'));
//         },
//       ),
//     );
//   }

//   Widget _buildUserList(List<UserModel> users) {
//     return Container(
//       height: 700,
//       child: ListView.separated(
//         separatorBuilder: (context,index){
//           return Divider();
//         },
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           final user = users[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: ListTile(
//               title: Text(user.userName),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(user.email),
//                   const SizedBox(height: 4),
//                   Text('Token: ${user.fcmToken}...'),
//                 ],
//               ),
//               trailing: IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: () => context.read<AdminBloc>().add(
//                   SendNotificationEvent(user: user)
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }