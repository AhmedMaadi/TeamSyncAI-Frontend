import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/model/message_model.dart';
import 'package:teamsyncai/providers/chatroom_provider.dart';
import 'package:teamsyncai/providers/message_provider.dart';
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/providers/userprovider.dart'; // Assuming ChatModel is defined in chat_model.dart

class ChatPage extends StatefulWidget {
  final ChatroomModel chatRoomModel;
  final String receiverEmail;

  const ChatPage({Key? key, required this.chatRoomModel, required this.receiverEmail}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();

  void _sendMessage(ChatroomProvider provider, UserProvider userProvider, String receiverEmail) async {
    String? userEmail = await userProvider.getUserEmail();

    if (userEmail != null && receiverEmail != null) {
      final String text = textEditingController.text.trim();
      if (text.isNotEmpty) {
        final Message message = Message(
          id: DateTime.now().toString(),
          text: text,
          senderEmail: userEmail,
          receiverEmail: receiverEmail,
        );
        provider.sendMessage(message);
        textEditingController.clear();
      }
    } else {
      print('User email or receiver email not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Message> messages = Provider.of<ChatroomProvider>(context).getMessagesForChatID(widget.chatRoomModel.chatID);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomModel.topic),
        leading: const BackButton(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final Message message = messages[index];
                final bool isSentByMe = message.senderEmail == widget.chatRoomModel.userEmail;
                return ListTile(
                  title: Text(message.text),
                  subtitle: Text(isSentByMe ? 'You' : widget.chatRoomModel.userEmail),
                  trailing: isSentByMe ? const Icon(Icons.done) : null,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    String? receiverEmail = await Provider.of<ChatroomProvider>(context, listen: false).getUserEmail();
                    if (receiverEmail != null) {
                      _sendMessage(
                        Provider.of<ChatroomProvider>(context, listen: false),
                        Provider.of<UserProvider>(context, listen: false),
                        receiverEmail,
                      );
                    } else {
                      print('Receiver email not found');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}