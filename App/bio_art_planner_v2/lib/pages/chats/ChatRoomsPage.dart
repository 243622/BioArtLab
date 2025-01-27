// lib/pages/chats/ChatRoomsPage.dart
import 'package:flutter/material.dart';
import 'package:bio_art_planner_v2/models/chats/ChatRoom.dart';
import 'package:bio_art_planner_v2/services/chats/ChatService.dart';
import 'package:bio_art_planner_v2/pages/chats/ChatRoomPage.dart';

class ChatRoomsPage extends StatefulWidget {
  final int userId;

  ChatRoomsPage({required this.userId});

  @override
  _ChatRoomsPageState createState() => _ChatRoomsPageState();
}

class _ChatRoomsPageState extends State<ChatRoomsPage> {
  late Future<List<ChatRoom>> _chatRoomsFuture;

  @override
  void initState() {
    super.initState();
    _chatRoomsFuture = ChatService().getUserChatRooms(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: FutureBuilder<List<ChatRoom>>(
        future: _chatRoomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chat rooms available'));
          } else {
            final chatRooms = snapshot.data!;
            return ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatRooms[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomPage(chatRoomId: chatRooms[index].id, userId: widget.userId),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}