class URLS
{
  String sendChatServer = "http://mariners.or.kr/app_middle/chat/chatSend.php";
  String searchMembers = "http://mariners.or.kr/app_middle/chat/search_json.php";
  String submitVote = "http://mariners.or.kr/app_middle/vote/vote_json.php";
  String searchSurveys(String uid){
    return "http://mariners.or.kr/app_middle/survey/survey_json.php?userId=${uid.toString()}&mode=search&page_number=1";
  }
  String searchSurveysAnswers(String uid, String idx){
    return "http://mariners.or.kr/app_middle/vote/vote_json.php?idx=${idx}&mode=view&userId=${uid}";
  }
}