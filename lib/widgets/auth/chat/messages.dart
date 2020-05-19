import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/widgets/auth/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) => MessageBubble(chatDocs[index]['text']),
          itemCount: chatDocs.length,
        );
      },
      stream: Firestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
    );
  }
}
