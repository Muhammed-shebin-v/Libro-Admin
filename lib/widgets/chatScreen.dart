import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:libro_admin/db/chat.dart';
import 'package:libro_admin/themes/fonts.dart';

class Chatscreen extends StatefulWidget {
  final String userId;
  final String userName;

  const Chatscreen({super.key, required this.userId,required this.userName});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _auth = ChatService();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      await _auth.sendMessage(widget.userId, message);
      _messageController.clear();
    }
  }

  Widget _buildMessageItem(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final isUser = data['isUser'] ?? false;
    final alignment = isUser ? Alignment.centerLeft : Alignment.centerRight;
    final columnAlignment = isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final Timestamp timestamp = doc['timestamp'];
    final DateTime dateTime = timestamp.toDate();

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: columnAlignment,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? AppColors.color10 : AppColors.color30,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(data['message'] ?? ''),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('hh:mm a').format(dateTime),
            style: AppFonts.body2,
          )
        ],
      ),
    );
  }

 int _previousMessageCount = 0;

Widget _buildMessagesList() {
  return StreamBuilder<QuerySnapshot>(
    stream: _auth.getMessages(widget.userId),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(child: Text('Something went wrong'));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final docs = snapshot.data?.docs ?? [];
      docs.sort((a, b) {
  final aTime = (a['timestamp'] as Timestamp).toDate();
  final bTime = (b['timestamp'] as Timestamp).toDate();
  return aTime.compareTo(bTime); // ascending: oldest first
});

      // Auto-scroll if new messages arrived
      if (docs.length > _previousMessageCount) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
      _previousMessageCount = docs.length;

      // Group by date
      final Map<String, List<QueryDocumentSnapshot>> groupedMessages = {};
      for (var doc in docs) {
        final DateTime dateTime = (doc['timestamp'] as Timestamp).toDate();
        final String dateKey = _getDateKey(dateTime);
        groupedMessages.putIfAbsent(dateKey, () => []).add(doc);
      }

      final sortedKeys = groupedMessages.keys.toList()
        ..sort((a, b) => _parseDateKey(a).compareTo(_parseDateKey(b)));

      final List<Widget> messageWidgets = [];

      for (final dateKey in sortedKeys) {
        final messages = groupedMessages[dateKey]!;

        // Add date header
        messageWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dateKey,
                  style: AppFonts.body2,
                ),
              ),
            ),
          ),
        );

        // Add each message under that date
        for (final doc in messages) {
          messageWidgets.add(_buildMessageItem(doc));
        }
      }

      return ListView(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 20, top: 8),
        children: messageWidgets,
      );
    },
  );
}

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                fillColor: AppColors.color10,
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }

  String _getDateKey(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime); // Example: 19 Jun 2025
    }
  }

  DateTime _parseDateKey(String key) {
    if (key == 'Today') {
      return DateTime.now();
    } else if (key == 'Yesterday') {
      return DateTime.now().subtract(const Duration(days: 1));
    } else {
      return DateFormat('dd MMM yyyy').parse(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(25)
            ),
            width:  MediaQuery.of(context).size.width * 0.50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios)),
                    Text(widget.userName,style: AppFonts.heading3,),
                    Expanded(child: SizedBox())
                  ],
                ),
                Expanded(child: _buildMessagesList()),
                _buildUserInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
