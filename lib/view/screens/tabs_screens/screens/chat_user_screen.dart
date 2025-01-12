// ignore_for_file: library_private_types_in_public_api
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/chat/userChat/get_messages_provider.dart';
import 'package:food2go_app/controllers/chat/userChat/send_message_provider.dart';
import 'package:food2go_app/models/chat/user_chat_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatUserScreen extends StatefulWidget {
  final int? orderidd;
  final int? deliveryyid;

  const ChatUserScreen({
    this.orderidd,
    this.deliveryyid,
    super.key,
  });

  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.orderidd != null && widget.deliveryyid != null) {
        final provider =
            Provider.of<GetMessagesProvider>(context, listen: false);
        provider.fetchMessages(context, widget.orderidd!, widget.deliveryyid!);
        provider.startRefreshing(
            context, widget.orderidd!, widget.deliveryyid!);
      }
    });
  }

  @override
  void dispose() {
    Provider.of<GetMessagesProvider>(context, listen: false).stopRefreshing();
    _messageController.dispose();
    super.dispose();
  }

  String _formatCreatedAt(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(createdAt);
      return DateFormat('hh:mm a').format(dateTime); // Format to 12-hour format
    } catch (e) {
      return ''; // Return empty string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<GetMessagesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<ChatResponses>(
        stream: chatProvider.chatStream,
        builder: (context, snapshot) {
          final messages = snapshot.data?.chat ?? [];
          messages.sort((a, b) {
            final aDate = DateTime.tryParse(a.createdAt ?? '');
            final bDate = DateTime.tryParse(b.createdAt ?? '');
            if (aDate == null || bDate == null) return 0;
            return bDate.compareTo(aDate); // Sort in descending order
          });
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE6E9F0), Color(0xFFF5F7FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: messages.isNotEmpty
                      ? ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isMe =
                                message.userSender == 1; // Adjust based on API
                            return Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: isMe ? maincolor : Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(15),
                                    topRight: const Radius.circular(15),
                                    bottomLeft: isMe
                                        ? const Radius.circular(15)
                                        : Radius.zero,
                                    bottomRight: isMe
                                        ? Radius.zero
                                        : const Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(2, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.message ?? '',
                                      style: TextStyle(
                                        color:
                                            isMe ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _formatCreatedAt(message.createdAt),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isMe
                                            ? Colors.white.withOpacity(0.8)
                                            : Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('No messages yet.'),
                        ),
                ),
                const Divider(height: 1, thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: maincolor,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            final message = _messageController.text.trim();
                            if (message.isNotEmpty) {
                              _messageController.clear();
                              if (widget.orderidd != null &&
                                  widget.deliveryyid != null) {
                                Provider.of<SendMessageProvider>(context,
                                        listen: false)
                                    .sendMessages(
                                  context,
                                  widget.orderidd!,
                                  widget.deliveryyid!,
                                  message,
                                );
                              } else {
                                log('Order ID or Delivery ID is null');
                              }
                            }
                          },
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
    );
  }
}
