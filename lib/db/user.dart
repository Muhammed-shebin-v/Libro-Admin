import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:libro_admin/models/user.dart';

class UserService {
  final _userRef = FirebaseFirestore.instance.collection('users');

  Future<List<UserModel>> fetchUsersAlphabetically() async {
    try {
      final snapshot = await _userRef.orderBy('userName').get();
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e, stack) {
      log('UserService.fetchUsersAlphabetically: $e', stackTrace: stack);
      rethrow;
    }
  }

  Future<List<UserModel>> fetchUsersAlphabeticallyDesc() async {
    try {
      final snapshot = await _userRef.orderBy('userName', descending: true).get();
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e, stack) {
      log('UserService.fetchUsersAlphabeticallyDesc: $e', stackTrace: stack);
      rethrow;
    }
  }

  Future<List<UserModel>> fetchLatestUsers() async {
    try {
      final snapshot = await _userRef.orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e, stack) {
      log('UserService.fetchLatestUsers: $e', stackTrace: stack);
      rethrow;
    }
  }

  Future<List<UserModel>> fetchOldestUsers() async {
    try {
      final snapshot = await _userRef.orderBy('createdAt').get();
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e, stack) {
      log('UserService.fetchOldestUsers: $e', stackTrace: stack);
      rethrow;
    }
  }
}
