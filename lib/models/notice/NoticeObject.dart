class NoticeObject {

  final String subject;
  final String fromId;
  final String fromName;
  final String content;

  NoticeObject(
      {
        this.subject,
        this.fromName,
        this.fromId,
        this.content,
      }
      );

  factory NoticeObject.fromJson(Map<String, dynamic> json) {
    return NoticeObject(
      subject: json['data']['subject'],
      fromId: json['data']['fromId'],
      fromName: json['data']['fromName'],
      content: json['data']['content'],
    );
  }

}