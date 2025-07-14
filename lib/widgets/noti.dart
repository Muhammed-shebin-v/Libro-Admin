// // admin_bloc.dart
// import 'dart:convert';
// import 'dart:developer';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
// import 'package:libro_admin/models/user.dart';
// import 'package:meta/meta.dart';

// class AdminBloc extends Bloc<AdminEvent, AdminState> {
//   final FirebaseFirestore firestore;
//   final FirebaseMessaging messaging;

//   AdminBloc({required this.firestore, required this.messaging})
//       : super(AdminInitial()) {
//     on<LoadUsersEvent>(_onLoadUsers);
//     on<SendNotificationEvent>(_onSendNotification);
//   }

//   Future<void> _onLoadUsers(
//       LoadUsersEvent event, Emitter<AdminState> emit) async {
//     emit(AdminLoading());
//     try {
//      final snapshot = await firestore.collection('users').get();
//       final userList =
//           snapshot.docs.map((e) => UserModel.fromMap(e.data())).toList();
//       emit(UsersLoaded(users: userList));
//     } catch (e) {
//       emit(AdminError(message: 'Failed to load users: $e'));
//     }
//   }

//   Future<void> _onSendNotification(
//       SendNotificationEvent event, Emitter<AdminState> emit) async {
//     emit(NotificationSending());
//     try {
//       // log('enetred');
//       if (event.user.fcmToken!.isEmpty) {
//         log('notoken');
//         throw Exception('User has no FCM token');
//       }

//       // Send notification via FCM
//       await _sendFcmNotification(
//         token: event.user.fcmToken!,
//         username: event.user.userName,
//       );

//       emit(NotificationSentSuccess());
//       add(LoadUsersEvent()); // Refresh user list
//     } catch (e) {
//       emit(NotificationError(message: 'Failed to send notification: $e'));
//     }
//   }

//   Future<void> _sendFcmNotification({
//     required String token,
//     required String username,
//   }) async {
//       log('enetered');
//     const serverKey = 'YOUR_FIREBASE_SERVER_KEY';
//     final response = await http.post(
//       Uri.parse('https://fcm.googleapis.com/fcm/send'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'key=$serverKey',
//       },
//       body: jsonEncode({
//         'to': token,
//         'notification': {
//           'title': 'Request Approved',
//           'body': 'Admin approved your request, Mr. $username',
//         },
//         'data': {
//           'type': 'admin_approval',
//           'username': username,
//           'route': '/approved',
//           'timestamp': DateTime.now().toIso8601String(),
//         }
//       }),
//     );

//     if (response.statusCode != 200) {
//       log('completed');
//       throw Exception('FCM error: ${response.body}');
//     }
//   }
// }

// // admin_event.dart


// @immutable
// abstract class AdminEvent {}

// class LoadUsersEvent extends AdminEvent {}

// class SendNotificationEvent extends AdminEvent {
//   final UserModel user;

//   SendNotificationEvent({required this.user});
// }

// // admin_state.dart


// @immutable
// abstract class AdminState {}

// class AdminInitial extends AdminState {}

// class AdminLoading extends AdminState {}

// class UsersLoaded extends AdminState {
//   final List<UserModel> users;

//   UsersLoaded({required this.users});
// }

// class NotificationSending extends AdminState {}

// class NotificationSentSuccess extends AdminState {}

// class AdminError extends AdminState {
//   final String message;

//   AdminError({required this.message});
// }

// class NotificationError extends AdminState {
//   final String message;

//   NotificationError({required this.message});
// }


