class LicenseTestQuestionObject
{
  int no = 0;
  String subject = "";
  String writer = "";
  String content = "";
  String regDate = "";

  String serverFileName_1 = "";
  String realFileName1 = "";
  String fileUrl_1 = "";

  String serverFileName_2 = "";
  String realFileName2 = "";
  String fileUrl_2 = "";

  String serverFileName_3 = "";
  String realFileName3 = "";
  String fileUrl_3 = "";

  String serverFileName_4 = "";
  String realFileName4 = "";
  String fileUrl_4 = "";

  LicenseTestQuestionObject({
    int no = 0,
    String subject,
    String writer,
    String content,
    String regDate,
    String serverFileName_1,
    String realFileName1,
    String fileUrl_1,
    String serverFileName_2,
    String realFileName2,
    String fileUrl_2,
    String serverFileName_3,
    String realFileName3,
    String fileUrl_3,
    String serverFileName_4,
    String realFileName4,
    String fileUrl_4,
  }){
    this.no = no;
    this.subject = subject;
    this.writer = writer;
    this.content = content;
    this.regDate = regDate;
    this.serverFileName_1 = serverFileName_1;
    this.realFileName1 = realFileName1;
    this.fileUrl_1 = fileUrl_1;
    this.serverFileName_2 = serverFileName_2;
    this.realFileName2 = realFileName2;
    this.fileUrl_2 = fileUrl_2;
    this.serverFileName_3 = serverFileName_3;
    this.realFileName3 = realFileName3;
    this.fileUrl_3 = fileUrl_3;
    this.serverFileName_4 = serverFileName_4;
    this.realFileName4 = realFileName4;
    this.fileUrl_4 = fileUrl_4;
  }
}
