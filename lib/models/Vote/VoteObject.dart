class VoteObject {

  final String startDate;
  final String endDate;
  final String subject;
  final String fromId;
  final String fromName;
  final String httpPath;
  final String idx;
  final String content;
  final String regDate;

  VoteObject(
      {
        this.startDate,
        this.subject,
        this.fromName,
        this.fromId,
        this.httpPath,
        this.idx,
        this.content,
        this.regDate,
        this.endDate
      }
      );

  factory VoteObject.fromJson(Map<String, dynamic> json) {
    return VoteObject(
      startDate: json['data']['startDate'],
      endDate: json['data']['endDate'],
      subject: json['data']['subject'],
      fromId: json['data']['fromId'],
      fromName: json['data']['fromName'],
      httpPath: json['data']['httpPath'],
      idx: json['data']['idx'],
      content: json['data']['content'],
      regDate: json['data']['regDate'],
    );
  }

}