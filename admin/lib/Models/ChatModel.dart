import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String visitedUserId;
  Timestamp lastMessagetimestamp;
  Timestamp addedUserat;
  String lastMessagetext;
  Timestamp lastSeen;
  String tpyeChat;
  bool isDarkMode;
  ChatModel({
    required this.visitedUserId,
    required this.addedUserat,
    required this.tpyeChat,
    required this.lastMessagetimestamp,
    required this.lastMessagetext,
    required this.lastSeen,
    required this.isDarkMode,
  });

  factory ChatModel.fromDoc(DocumentSnapshot doc) {
    return ChatModel(
        visitedUserId: doc['visitedUserId'],
        addedUserat: doc['added User at '],
        lastMessagetext: doc['lastMessage text'],
        lastMessagetimestamp: doc['lastMessage Timestamp'],
        lastSeen: doc['lastSeen'],
        isDarkMode: doc['isDarkMode'],
        tpyeChat: doc['Typechat']);
  }
}
