class MagazineObject
{
  String subject = "";
  String serverFileName = "";
  String realFileName = "";
  String fileUrl = "";

  MagazineObject({
    String subject,
    String serverFileName,
    String realFileName,
    String fileUrl,
  }){
    this.subject = subject;
    this.serverFileName = serverFileName;
    this.realFileName = realFileName;
    this.fileUrl = fileUrl;
  }
}