import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  Future<void> sendMessage(String recieverId, String text) async {
    //get user info
    final Timestamp timestamp = Timestamp.now();

    //create message
    MessageModel message = MessageModel(
      message: text,
      timestamp: timestamp,
      isUser: false,
    );

    //send msg
    await FirebaseFirestore.instance
        .collection('users')
        .doc(recieverId)
        .collection('message')
        .add(message.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId){
    return  FirebaseFirestore.instance.collection('users').doc(userId).collection('message').orderBy('timestamp',descending: true).snapshots();
  }
}

class MessageModel {
  final bool isUser;
  final String message;
  final Timestamp timestamp;

  MessageModel({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {'isUser': isUser, 'message': message, 'timestamp': timestamp};
  }

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      message: data['message'],
      isUser: data['isUser'],
      timestamp: data['timestamp'],
    );
  }
}
