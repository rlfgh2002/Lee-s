class SurveyObject {

  final String no;
  final String bdIdx;
  final String startDate;
  final String endDate;
  final String subject;
  final String contents;
  final String qCnt;

  SurveyObject(
      {
        this.no,
        this.subject,
        this.startDate,
        this.endDate,
        this.bdIdx,
        this.contents,
        this.qCnt,
      }
      );

  factory SurveyObject.fromJson(Map<String, dynamic> json) {
    return SurveyObject(
      startDate: json['start_date'],
      endDate: json['end_date'],
      subject: json['subject'],
      contents: json['contents'],
      qCnt: json['q_cnt'],
      bdIdx: json['bd_idx'],
      no: json['no'],
    );
  }

}