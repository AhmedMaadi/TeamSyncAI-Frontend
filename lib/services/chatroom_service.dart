import 'dart:convert'; // for json.decode
import 'package:http/http.dart' as http; // for http requests
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/model/user_model.dart';
import 'package:teamsyncai/model/message_model.dart'; // Import Message model

class ChatroomService {
  List<User> users = []; // Initialize an empty list of users
  User currentUser = const User.empty(); // Use User.empty() to initialize currentUser
  List<User> friendList = [];
  List<Message> messages = [];

  Future<List<ChatroomModel>> getChatrooms() async {
    // Mocking API response, replace with actual API call
    String apiUrl = 'http://192.168.1.10:3000/chatrooms/get';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<ChatroomModel> chatrooms =
          data.map((item) => ChatroomModel.fromJson(item)).toList();
      return chatrooms;
    } else {
      throw Exception('Failed to load chatrooms');
    }
  }

Future<void> createChatroom(String name, String userEmail, String topic, List<Message> messages) async {
  // Print the values of name, userEmail, and topic before making the API call
  print('Name: $name');
  print('User Email: $userEmail');
  print('Topic: $topic');

  // Mocking API call, replace with actual API call
  String apiUrl = 'http://192.168.1.10:3000/chatrooms/create';
  var body = json.encode({
    'name': name,
    'userEmail': userEmail,
    'topic': topic,
  });
  var headers = {'Content-Type': 'application/json'};

  var response =
      await http.post(Uri.parse(apiUrl), body: body, headers: headers);

  if (response.statusCode != 201) {
    throw Exception('Failed to create chatroom');
  }
}



  Future<void> sendMessage(Message message) async {
    messages.add(message); // Add the message to the list of messages
    // Send message to backend server
    final response = await http.post(
      Uri.parse('http://localhost:3000/send_message'),
      body: jsonEncode({
        'receiverChatID': message.receiverID,
        'senderChatID': message.senderID,
        'content': message.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Message sent successfully
      print('Message sent successfully');
    } else {
      // Error sending message
      print('Error sending message: ${response.statusCode}');
    }
  }

  List<Message> getMessagesForChatID(String chatID) {
    return messages
        .where((msg) =>
            msg.senderID == chatID || msg.receiverID == chatID)
        .toList();
  }
}