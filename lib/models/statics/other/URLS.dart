class URLS {
  String sendChatServer = "http://mariners.or.kr/app_middle/chat/chatSend.php";
  String searchMembers =
      "http://mariners.or.kr/app_middle/chat/search_json.php";
  String submitVote = "http://mariners.or.kr/app_middle/vote/vote_json.php";
  String searchSurveys(String uid) {
    return "http://mariners.or.kr/app_middle/survey/survey_json.php?userId=${uid.toString()}&mode=search&page_number=1";
  }

  String searchSurveysAnswers(String uid, String idx) {
    return "http://mariners.or.kr/app_middle/survey/survey_json.php?bd_idx=${idx.toString()}&mode=view&userId=${uid.toString()}";
  }

  String submitSurvey() {
    return "http://mariners.or.kr/app_middle/survey/survey_json.php";
  }

  String magazines({int page = 0}){
    return "http://mariners.or.kr/app_middle/etc/magazine_json.php?mode=list&pageNum=${page.toString()}";
  }

  String noticesList({int page = 0}){
    return "http://mariners.or.kr/app_middle/etc/notice_json.php?mode=list&pageNum=${page.toString()}";
  }

  String iO({int page = 0}){
    return "http://mariners.or.kr/app_middle/etc/introduction_json.php?mode=list&pageNum=${page.toString()}";
  }

  String licenseTestQuestions({int page = 0}){
    return "http://mariners.or.kr/app_middle/etc/exam_json.php?mode=list&pageNum=${page.toString()}";
  }
}
