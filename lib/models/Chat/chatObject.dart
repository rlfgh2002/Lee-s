class ChatObject {

  final String notificationKind;
  final String notificationRegDate;
  final String notificationFromId;
  final String notificationContent;

  final String notificationFromName;
  final String notificationConversationId;
  final String notificationType;
  final String chatId;

  ChatObject(
      {
        this.notificationKind,
        this.notificationRegDate,
        this.notificationFromId,
        this.notificationContent,
        this.notificationConversationId,
        this.notificationFromName,
        this.notificationType,
        this.chatId
      }
      );

  factory ChatObject.fromJson(Map<String, dynamic> json) {
    return ChatObject(
      notificationKind: json['data']['kind'],
      notificationRegDate: json['data']['regDate'],
      notificationFromId: json['data']['fromId'],
      notificationContent: json['data']['content'],

      notificationFromName: json['data']['fromName'],
      notificationConversationId: json['data']['conversationId'],
      notificationType: json['data']['notificationType'],
      chatId: json['data']['chatId'],
    );
  }
}