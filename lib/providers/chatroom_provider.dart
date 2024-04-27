import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/model/user_model.dart';

import 'package:teamsyncai/model/message_model.dart';
import 'package:teamsyncai/services/chatroom_service.dart';

class ChatroomProvider extends ChangeNotifier {
  final ChatroomService _service = ChatroomService();

  List<ChatroomModel> _chatrooms = [];
  List<User> _friendList = [];
    String? _receiverEmail; // Instance variable for receiver email
    late SharedPreferences _prefs; // Instance variable for shared preferences
  ChatroomModel? _currentChatroom;
    List<ChatroomModel> _chatroomsWithTopics = []; // List to hold chatrooms filtered by topics

  List<ChatroomModel> get chatroomsWithTopics => _chatroomsWithTopics; // Getter for chatrooms with topics


  late String _userEmail; // Instance variable for user email
  List<ChatroomModel> get chatrooms => _chatrooms;
  List<User> get friendList => _friendList;
  void setCurrentChatroom(ChatroomModel chatroom) {
    _currentChatroom = chatroom;
    notifyListeners();
  }
Future<void> saveUserEmail(String email) async {
    _userEmail = email;
    await _prefs.setString('userEmail', email); // Save user email to shared preferences
  }
   
  void init() {
    _chatrooms.clear(); // Ensure chatrooms list is empty during initialization
    // Any other initialization logic can go here
  }
   Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _userEmail = _prefs.getString('userEmail') ?? ''; // Fetch user email from shared preferences
  }
  Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userEmail');
}


  Future<void> fetchChatrooms() async {
    try {
      _chatrooms = await _service.getChatrooms();
      notifyListeners();
    } catch (e) {
      print('Error fetching chatrooms: $e');
    }
  }
Future<void> createChatroom(String name, String receiverEmail, String topic) async {
  String? userEmail = await getUserEmail();
  if (userEmail != null) {
    List<Message> messages = []; // Initialize messages as an empty list
    try {
      await _service.createChatroom(name, receiverEmail, topic, messages);
      
      // Save the topic locally
      await _prefs.setString('chatroomTopic', topic);
      
      // Call saveUserEmail here
      await saveUserEmail(userEmail);

      await fetchChatrooms();
    } catch (e) {
      print('Error creating chatroom: $e');
    }
  } else {
    print('User email not found');
  }
}


Future<String?> getLocalChatroomTopic() async {
  return _prefs.getString('chatroomTopic');
}




   List<Message> getMessagesForChatID(String chatID) {
    return _service.getMessagesForChatID(chatID); // Use getMessagesForChatID instead of get
  }

 Future<void> sendMessage(Message message) async {
  try {
    await _service.sendMessage(message);
    notifyListeners();
  } catch (e) {
    print('Error sending message: $e');
  }
}

    String? getCurrentChatroomReceiverEmail() {
    return _currentChatroom?.receiverEmail;
  }
  void filterChatroomsByTopics() async {
  String? topic = await getLocalChatroomTopic();
  if (topic != null) {
    _chatroomsWithTopics = _chatrooms.where((chatroom) => chatroom.topic == topic).toList();
    notifyListeners(); // Notify listeners after filtering
  }
}

}