import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String userName;
  final String email;
  final String place;
  final String phoneNumber;
  final String imgeUrl;
  final DateTime createdAt;
  final bool isBlock;
  final int score;
  final DateTime subDate;
  final String subType;
  final int borrowLimit;
   String? fcmToken;
  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.place,
    required this.phoneNumber,
    required this.createdAt,
    required this.imgeUrl,
    required this.isBlock,
    required this.score,
    required this.subDate,
  required this.subType,
  required this.borrowLimit,
  this.fcmToken,


  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      userName: data['userName'] ?? '',
      email: data['email'] ?? '',
      place: data['place'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      imgeUrl: data['imgUrl'],
      isBlock: data['isBlock'],
      score: data['score'],
      subDate:( data['subDate'] as Timestamp).toDate(),
      subType: data['subType']??'',
      borrowLimit: data['borrowLimit']??0,
      fcmToken: data['fcmToken']??'',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': userName,
      'email': email,
      'address': place,
      'phoneNumber': phoneNumber,
    };
  }
}