class OccasionListObject {
  int no = 0;
  int pTotal = 0;
  int pCurrent = 0;

  String subject = "";
  String contents = "";
  String regDate = "";
  String answer = "";
  String regdate = "";
  String comment = "";
  String commentdate = "";

  OccasionListObject(
      {int no = 0,
      int pTotal = 0,
      int pCurrent = 0,
      String subject,
      String contents,
      String regDate,
      String answer,
      String regdate,
      String comment,
      String commentdate}) {
    this.no = no;
    this.pTotal = pTotal;
    this.pCurrent = pCurrent;
    this.subject = subject;
    this.contents = contents;
    this.regDate = regDate;
    this.answer = answer;
    this.regdate = regdate;
    this.comment = comment;
    this.commentdate = commentdate;
  }
}
