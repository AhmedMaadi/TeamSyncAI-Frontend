class ChatroomModel {
  final String chatID;
  final String name;
  final String userEmail;
  final String receiverEmail;
  final String topic;
  final List<String> messages;
  final DateTime createdAt;

  ChatroomModel({
    this.chatID = '',
    required this.name,
    required this.userEmail,
    required this.receiverEmail,
    required this.topic,
    required this.messages,
    required this.createdAt,
  });
  factory ChatroomModel.fromJson(Map<String, dynamic> json) {
    return ChatroomModel(
      chatID: json['chatID'] ?? '', // Assign a default value if null
      name: json['name'],
      userEmail: json['userEmail'],
      receiverEmail: json['receiverEmail'], // Corrected receiverEmail assignment

      topic: json['topic'],
      messages: List<String>.from(json['messages']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}