class URLS {
  String sendChatServer = "http://mariners.or.kr/app_middle/chat/chatSend.php";
  String searchMembers =
      "http://mariners.or.kr/app_middle/chat/search_json.php";

  String searchSurveys(String uid, String mode, String idx) {
    return "http://mariners.or.kr/app_middle/survey/survey_json.php?userId=${uid.toString()}&mode=${mode.toString()}&bd_idx=${idx.toString()}&page_number=99";
  }

  String submitVote(String uid, String voteIdx, String answerId) {
    return "http://mariners.or.kr/app_middle/vote/vote_json.php?mode=submit&userId=${uid.toString()}&idx=${voteIdx.toString()}&check=${answerId.toString()}";
  }

  String searchSurveysAnswers(String uid, String idx) {
    return "http://mariners.or.kr/app_middle/survey/survey_json.php?bd_idx=${idx.toString()}&mode=view&userId=${uid.toString()}";
  }

  String submitSurvey() {
    return "http://mariners.or.kr/app_middle/survey/survey_json.php";
  }

  String magazines({int page = 0}) {
    return "http://mariners.or.kr/app_middle/etc/magazine_json.php?mode=list&pageNum=${page.toString()}";
  }

  String map({int page = 0, String keyword}) {
    return "http://mariners.or.kr/app_middle/owner/owner_json.php?mode=list&pageNum=${page.toString()}&keyword=${keyword.toString()}";
  }

  String noticesList({int page = 0}) {
    return "http://mariners.or.kr/app_middle/etc/notice_json.php?mode=list&pageNum=${page.toString()}";
  }

  String inquiry({String mode, String userId, int page = 0}) {
    return "http://mariners.or.kr/app_middle/etc/qna_json.php?&mode=${mode.toString()}&userId=${userId.toString()}&pageNum=${page.toString()}";
  }

  String occasion({String mode, String user_id, int page = 0}) {
    return "http://mariners.or.kr/app_middle/etc/occasion_json.php?&mode=${mode.toString()}&user_id=${user_id.toString()}&pageNum=${page.toString()}";
  }

  String galleryList({int page = 0}) {
    return "http://mariners.or.kr/app_middle/etc/gallery_json2.php?mode=list&pageNum=${page.toString()}";
  }

  String iO({int page = 0}) {
    return "http://mariners.or.kr/app_middle/etc/introduction_json.php?mode=list&pageNum=${page.toString()}";
  }

  String licenseTestQuestions({int page = 0}) {
    return "http://mariners.or.kr/app_middle/etc/exam_json.php?mode=list&pageNum=${page.toString()}";
  }
}
