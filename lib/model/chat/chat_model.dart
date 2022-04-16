import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

enum ChatType { One_To_One, Group }

class ChatsModel extends Equatable {
  final List<ChatModel> chats;
  final DocumentSnapshot? firstDoc;
  final DocumentSnapshot? lastDoc;

  const ChatsModel({required this.chats, this.firstDoc, this.lastDoc});

  @override
  List<Object?> get props => [chats, lastDoc];
}

// ignore: must_be_immutable
class ChatModel extends Equatable {
  final String chatId;
  final ChatType type;
  final String? groupName; // required for group chat
  final int? groupDescription; // required for group chat
  final String? groupImage; // required for group chat
  final String? groupCreatedBy;
  List<String> members = [];
  List<String> questions = [];
  final DateTime creationDate;
  final DateTime updateDate;
  final String lastMessage;
  final String? senderId;
  final List<String>? admins;

  ChatModel({
    required this.chatId,
    required this.type,
    this.groupName,
    this.groupDescription,
    this.groupImage,
    this.groupCreatedBy,
    required this.creationDate,
    required this.lastMessage,
    this.senderId,
    required this.members,
    required this.questions,
    required this.updateDate,
    this.admins,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      chatId: data["chatId"] as String,
      type: getChatTpe(data["type"] as String),
      lastMessage: data["lastMessage"] as String,
      members: List<String>.from(data['members'] as List? ?? <String>[]),
      questions: List<String>.from(data['questions'] as List? ?? <String>[]),
      groupName: data['groupName'] as String? ?? "",
      groupDescription: data['groupDescription'] as int,
      groupImage: data['groupImage'] as String? ?? "",
      groupCreatedBy: data['groupCreatedBy'] as String? ?? "",
      senderId: data['senderId'] as String? ?? "",
      creationDate: DateTime.parse(data['creationDate'] as String).toLocal(),
      updateDate: DateTime.parse(data['updateDate'] as String).toLocal(),
      admins: List<String>.from(data['admins'] as List? ?? <String>[]),
    );
  }

  ChatModel copyWith({String? image, String? subject, int? desc}) {
    return ChatModel(
      chatId: chatId,
      type: type,
      groupName: subject ?? groupName,
      groupDescription: (desc ?? groupDescription) ?? 8,
      groupImage: (image ?? groupImage) ?? "",
      groupCreatedBy: groupCreatedBy,
      creationDate: creationDate,
      lastMessage: lastMessage,
      admins: admins ?? [],
      questions: questions,
      members: members,
      senderId: senderId,
      updateDate: updateDate,
    );
  }

  ChatModel copyWithForAdmin(String memberId, bool addAsAdmin) {
    List<String> newAdmins = admins!;
    if (addAsAdmin)
      newAdmins.add(memberId);
    else
      newAdmins.remove(memberId);

    return ChatModel(
      chatId: chatId,
      type: type,
      groupName: groupName,
      groupDescription: groupDescription,
      groupImage: groupImage,
      groupCreatedBy: groupCreatedBy,
      creationDate: creationDate,
      lastMessage: lastMessage,
      admins: newAdmins,
      questions: questions,
      members: members,
      senderId: senderId,
      updateDate: updateDate,
    );
  }

  static ChatType getChatTpe(final String type) {
    switch (type) {
      case "group":
        return ChatType.Group;
      default:
        return ChatType.One_To_One;
    }
  }

  String? getReceipient(final String currentuserId) {
    if (type == ChatType.One_To_One) {
      final users = members.toList();
      users.remove(currentuserId);
      return users.first;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "chatId": chatId,
      "type": "group",
      "lastMessage": lastMessage,
      "groupName": groupName,
      "groupDescription": groupDescription,
      "groupImage": groupImage ?? "",
      "groupCreatedBy": groupCreatedBy,
      "creationDate": creationDate.toUtc().toIso8601String(),
      "updateDate": creationDate.toUtc().toIso8601String(),
      "questions": questions,
      "members": members,
      "admins": <String>[],
    };
  }

  static Map<String, dynamic> toSubjectMap(String subject) {
    return <String, dynamic>{"groupName": subject};
  }

  static Map<String, dynamic> toDescriptionMap(int description) {
    return <String, dynamic>{"groupDescription": description};
  }

  static Map<String, dynamic> toGroupImageMap(String groupImageURL) {
    return <String, dynamic>{"groupImage": groupImageURL};
  }

  bool isAdmin(String userId) {
    return admins!.contains(userId) || userId == groupCreatedBy;
  }

  String chatCreatedDate() {
    return DateFormat("MMM d, yyyy").format(creationDate);
  }

  @override
  List<Object?> get props => [
        chatId,
        type,
        groupName,
        groupDescription,
        groupImage,
        groupCreatedBy,
        creationDate,
        lastMessage,
        questions,
        members,
        admins,
        updateDate,
        senderId,
      ];
}
