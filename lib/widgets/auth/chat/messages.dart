import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/widgets/auth/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
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
                  itemBuilder: (ctx, index) => MessageBubble(
//                    This gets the documents with a text key
                    chatDocs[index]['text'],
                    chatDocs[index]['userName'],
//                    This sets the key userId to the current user UID
                    chatDocs[index]['userId'] == futureSnapshot.data.uid,
//                    used to efficiently update the list
                    key: ValueKey(chatDocs[index].documentID),
                  ),
                  itemCount: chatDocs.length,
                );
              },
              stream: Firestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots());
        });
  }
}
