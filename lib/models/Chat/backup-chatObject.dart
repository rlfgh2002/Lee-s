class ChatObject {

  final bool content_available;
  final String priority;
  final String registration_ids;
  final ChatObjectData data;
  final ChatObjectNotification notification;

  ChatObject(
      {
        this.content_available,
        this.priority,
        this.registration_ids,
        this.data,
        this.notification
      }
      );

  factory ChatObject.fromJson(Map<String, dynamic> json) {
    return ChatObject(
      content_available: json['content_available'],
      priority: json['priority'],
      registration_ids: json['registration_ids'],
      data: ChatObjectData.fromJson(json["data"]),
      notification: ChatObjectNotification.fromJson(json["notification"]),
    );
  }
}

class ChatObjectData
{
  final String conversationId;
  final String message;
  final String fromId;
  final String fromName;
  final String regDate;
  final String toId;

  ChatObjectData(
      {
        this.conversationId,
        this.message,
        this.fromId,
        this.fromName,
        this.regDate,
        this.toId,
      }
      );

  factory ChatObjectData.fromJson(Map<String, dynamic> json) {
    return ChatObjectData(
      conversationId: json['conversationId'],
      message: json['message'],
      fromId: json['fromId'],
      fromName: json['fromName'],
      regDate: json['regDate'],
      toId: json['toId'],
    );
  }

}

class ChatObjectNotification
{
  final String notificationType;
  final String date;
  final String time;
  final String conversationId;
  final String content;
  final String kind;
  final String file;
  final int badge;
  final ChatObjectNotificationChat chat;

  ChatObjectNotification(
      {
        this.notificationType,
        this.date,
        this.time,
        this.conversationId,
        this.content,
        this.kind,
        this.file,
        this.badge,
        this.chat
      }
      );

  factory ChatObjectNotification.fromJson(Map<String, dynamic> json) {
    return ChatObjectNotification(
      notificationType: json['notificationType'],
      date: json['date'],
      time: json['time'],
      content: json['content'],
      conversationId: json['conversationId'],
      kind: json['kind'],
      file: json['file'],
      badge: json['badge'],
      chat: ChatObjectNotificationChat.fromJson(json['chat']['sender']),
    );
  }

}

class ChatObjectNotificationChat
{
  final String userId;
  final String userName;
  final String fullName;
  final String avatar;
  final String bio;

  ChatObjectNotificationChat(
      {
        this.userId,
        this.userName,
        this.fullName,
        this.avatar,
        this.bio,
      }
      );

  factory ChatObjectNotificationChat.fromJson(Map<String, dynamic> json) {
    return ChatObjectNotificationChat(
      userId: json['userId'],
      userName: json['userName'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      bio: json['bio'],
    );
  }

}