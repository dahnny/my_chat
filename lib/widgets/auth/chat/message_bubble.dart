import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.username, this.userImage, this.isMe,
      {this.key});

  final Key key;
  final String username;
  final String userImage;
  final isMe;
  final message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
//      messages should be rendered at the left if it is not us and vice versa
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8
              ),
              width: 140,
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
//              sets the radius if it is us or not
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.title.color,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.title.color),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
//        The positioned widget is used to move the widgets in the stack widget
        Positioned(
          top: 0,
          left: isMe ? 200 : null,
          right: isMe ? null : 200,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        )
      ],
      overflow: Overflow.visible,
    );
  }
}
