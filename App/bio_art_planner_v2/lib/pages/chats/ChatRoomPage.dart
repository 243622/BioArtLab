import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Import ScrollDirection
import 'package:bio_art_planner_v2/models/chats/ChatMessage.dart';
import 'package:bio_art_planner_v2/models/classes/User.dart';
import 'package:bio_art_planner_v2/services/chats/ChatService.dart';
import 'package:bio_art_planner_v2/models/services/UserServices.dart';

class ChatRoomPage extends StatefulWidget {
  final int chatRoomId;
  final int userId;

  ChatRoomPage({required this.chatRoomId, required this.userId});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late StreamController<List<ChatMessage>> _messagesStreamController;
  late Future<Map<int, User>> _usersFuture;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  bool _isUserScrolling = false;
  List<ChatMessage> _currentMessages = [];

  @override
  void initState() {
    super.initState();
    _messagesStreamController = StreamController<List<ChatMessage>>();
    _usersFuture = UserServices().getAll().then((users) {
      return {for (var user in users) user.userId!: user};
    });
    _scrollController.addListener(_onScroll);
    _startFetchingMessages();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
      _isUserScrolling = true;
    } else {
      _isUserScrolling = false;
    }
  }

  void _startFetchingMessages() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final newMessages = await ChatService().getMessages(widget.chatRoomId);
      if (newMessages != _currentMessages) {
        _currentMessages = newMessages;
        _messagesStreamController.add(newMessages);
      }
    });
  }

  void _sendMessage() async {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      final chatRoomId = widget.chatRoomId;
      final userId = widget.userId;
      final newMessage = ChatMessage(
        id: 0, // Assuming the ID will be set by the server
        chat_room_id: chatRoomId,
        user_id: userId,
        message: messageText,
        timestamp: DateTime.now(),
      );

      try {
        await ChatService().sendMessage(chatRoomId, userId, messageText);
        _messageController.clear();

        // Fetch new messages after sending a message
        final messages = await ChatService().getMessages(chatRoomId);
        _currentMessages = messages;
        _messagesStreamController.add(messages);

        // Scroll to the bottom after sending a message if the user is not scrolling
        if (!_isUserScrolling) {
          _scrollToBottom();
        }
      } catch (e) {
        // Handle the error, e.g., show a snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messagesStreamController.close();
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<int, User>>(
              future: _usersFuture,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                } else if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
                  return Center(child: Text('No users available'));
                } else {
                  final users = userSnapshot.data!;
                  return StreamBuilder<List<ChatMessage>>(
                    stream: _messagesStreamController.stream,
                    builder: (context, messageSnapshot) {
                      if (messageSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (messageSnapshot.hasError) {
                        return Center(child: Text('Error: ${messageSnapshot.error}'));
                      } else if (!messageSnapshot.hasData || messageSnapshot.data!.isEmpty) {
                        return Center(child: Text('No messages available'));
                      } else {
                        final messages = messageSnapshot.data!;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!_isUserScrolling) {
                            _scrollToBottom();
                          }
                        });
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final username = users[message.user_id]?.username ?? 'Unknown';
                            return ListTile(
                              title: Text(message.message),
                              subtitle: Text('$username - ${message.timestamp}'),
                            );
                          },
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}