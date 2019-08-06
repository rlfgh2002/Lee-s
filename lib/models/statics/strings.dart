class Strings {
  static Strings shared = Strings();
  _Strings() {}

  _StringsControllers controllers = _StringsControllers();
  _StringsDialogs dialogs = _StringsDialogs();
}

class _StringsDialogs {
  String vote = "투표";
  String votingPeriod = "투표기간";
  String bottomLableVoteDialog = "비밀투표를 원칙으로 진행됩니다.";
  String closeBtnTitle = "닫기";
  String applyVoteBtn = "투표하기";

  String toVoteKeyword = "투표에";
  String pleaseJoinUsThankYouKeyword = "참여해주셔서 감사합니다";
  String descriptionUnderCompleteDialog = "결과는 투표종료 후 협회에서 알려드릴 예정입니다.";

  String survey = "설문조사";
  String surveyingPeriod = "설문기간";
  String submitBtnTitle = "제출하기";

  String wouldYouLikeToBlockPart1Red = "차단";
  String wouldYouLikeToBlockPart2 = "하시겠어요?";
  String blockPopUpCaption = "차단하시면 다시 대화를 하실 수 없어요";
  String btnBlockTitle = "차단";
}

class _StringsControllers {
  _StringsControllerHome home = _StringsControllerHome();
  _StringsControllerFindUser findUser = _StringsControllerFindUser();
  _StringsControllerChats chats = _StringsControllerChats();
  _StringsControllerChat chat = _StringsControllerChat();
  _StringsControllerNotices notices = _StringsControllerNotices();
  _StringsControllerProfile profile = _StringsControllerProfile();
  _StringsSignInController signIn = _StringsSignInController();
  _StringSignSelectController signSelect = _StringSignSelectController();
  _StringTermController term = _StringTermController();
  _StringJsonURL jsonURL = _StringJsonURL();
}

// HOME Controller //
class _StringsControllerHome {}
// HOME Controller //

// FIND USER Controller //
class _StringsControllerFindUser {}
// FIND USER Controller //

// CHATS Controller //
class _StringsControllerChats {
  String pageTitle = "채팅";
}
// CHATS Controller //

// Single Chat Controller //
class _StringsControllerChat {
  String hintChatTextField = "메시지를 입력하세요"; // please enter your message
  String conversationPermission = "대화허락";
  String conversationBlock = "대화차단";
  String errorWhileSendingChatMessage = "메시지가 전송되지 않았습니다!"; // Message Not Sent
}
// Single Chat Controller //

// NOTICES Controller //
class _StringsControllerNotices {
  String pageTitle = "푸시알림";
  String noPushNotificationYet = "푸시알림이 아직 없습니다";
  _StringsControllerNoticesSnackBar snackBar =
      _StringsControllerNoticesSnackBar();
}

class _StringsControllerNoticesSnackBar {
  String votingPeriodIsOver = "투표기간이 종료되었습니다.";
}
// NOTICES Controller //

// PROFILE Controller //
class _StringsControllerProfile {}
// PROFILE Controller //

// SIGN IN Controller //
class _StringsSignInController {
  String title1 = "내 손안의";
  String title2 = "한국해기사협회";
  String subTitle = "홈페이지 가입시 사용한 계정으로 로그인 할 수 있습니다.";
  String txtHintUser = "아이디";
  String txtHintPass = "비밀번호";
  String txtHintPass2 = "비밀번호 확인";
  String forgetPasswordTitle = "비밀번호 찾기";
  String findIDTitle = "아이디 찾기";
  String loginBtnTitle = "로그인";
  String enterID = "아이디를 입력하세요.";
  String enterPass = "비밀번호를 입력하세요.";
  String wrongID = "아이디를 확인하세요.";
  String wrongPass = "비밀번호가 불일치합니다. 다시 입력해주세요.";
  String findID1 = "회원님의 아이디는";
  String findID2 = "입니다.";
  String findID3 = "아이디는 6자리 이상 입력해주세요.";
  String findPass = "비밀번호가 다릅니다.";
  String findPass2 = "비밀번호는 영문,숫자,특수문자 조합 6~16자리 입니다.";
  String error = "사용할수 없는 계정입니다. 관리자에게 연락해주세요.";
  String error2 = "이미 사용중인 계정입니다.";
  String change = "변경하기";
}
// SIGN IN Controller //

// SIGN SELECT Controller //
class _StringSignSelectController {
  String title1 = "기존 홈페이지\n회원이신가요?";
  String title2 = "신규회원이신가요?";
  String title3 = "본 서비스는";
  String title3_1 = "한국해기사협회 정,준회원만\n사용가능한 서비스입니다.";
  String title4 = "본인인증";
  String title5 = "고객님의 본인확인을 위하여\n본인인증이 필요합니다.";
  String button1 = "로그인하기 ";
  String button2 = "회원가입하기 ";
  String confirm = "확인";
}
// SIGN SELECT Controller //

// JSON URL //
class _StringJsonURL {
  String authJson = "http://www.mariners.or.kr/member/mobile_join.php";
  String loginJson =
      "http://www.mariners.or.kr/app_middle/member/login_json.php";
  String logininfoJson =
      "http://www.mariners.or.kr/app_middle/member/login_info_json.php";
  String findPW =
      "http://www.mariners.or.kr/app_middle/member/find_pw_json.php";
  String joinJson = "http://www.mariners.or.kr/app_middle/member/join_json.php";
  String button2 = "회원가입하기 ";
}
// JSON URL //

class _StringTermController {
  //terms and policy
  String terms_title = '약관 동의';
  String terms_title_detial = '본 서비스는 한국해기사협회\n정,준회원만 사용가능한 서비스입니다.';
  String terms_terms_title = '서비스 이용 약관 동의(필수) ';
  String terms_policy_title = '개인정보 수집 및 이용 동의(필수) ';
  String terms_notification_title = '마케팅 정보 앱 푸시알림 수신';
  String terms_accept_all_title = '모두 확인 및 동의합니다.';
  String terms_accept_no = '필수 약관은 모두 동의 해야 서비스가 시작됩니다.';
  String terms_view = '보기';
  String terms_get_started = '시작하기';
  String terms_privacy_statement = '개인정보취급방침';
  String terms_term_detail_tile = '이용약관';
  String terms_term_detail = '''제1조 (목적)
본 이용약관은 Marinesoft가 운영하는 앱 서비스(이하 '앱‘이라 한다)를 이용함에 있어 관리자와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 한다.

제2조 (약관의 효력)
1. 본 약관은 Marinesoft의 서비스 이용약관 동의 시 이용자들에게 통지함으로써 효력을 발생한다.
2. Marinesoft는 이 약관의 내용을 변경할 수 있으며, 변경된 약관은 제1항과 같은 방법으로 공지 또는 통지함으로써 효력을 발생한다.
3. 약관의 변경사항 및 내용은 Marinesoft의 서비스에 게시하는 방법으로 공시한다.

제3조 (약관 이외의 준칙)
이 약관에 명시되지 않은 사항이 전기 통신 기본법, 전기통신 사업법, 기타 관련 법령에 규정되어 있는 경우 그 규정에 따른다.

제4조 (용어의 정의)
이 약관에서 사용하는 용어의 정의는 다음과 같습니다. 
1. 이용자 : Marinesoft와 앱 서비스 이용에 관한 계약을 체결한 자.

제5조 (서비스 제공의 중지)
Marinesoft는 다음 각 호의 1에 해당하는 경우 서비스의 제공을 중지할 수 있습니다.
1. 설비의 보수 등을 위하여 부득이한 경우.
2. 전기통신사업법에 규정된 기간통신사업자가 전기통신서비스를 중지하는 경우.
3. 기타 Marinesoft가 서비스를 제공할 수 없는 사유가 발생한 경우.

제6조 (Marinesoft의 의무)
1. Marinesoft는 계속적, 안정적으로 서비스를 제공할 수 있도록 최선의 노력을 다하여야 한다.
2. Marinesoft는 항상 이용자의 신용정보를 포함한 개인신상정보의 보안에 대하여 관리에 만전을 기함으로서 이용자의 정보보안에 최선을 다하여야 한다.

제7조 (개인정보보호)
1. Marinesoft는 이용자의 정보수집시 서비스의 제공에 필요한 최소한의 정보를 수집한다.
2. 제공된 개인정보는 당해 이용자의 동의 없이 목적외의 이용이나 제3자에게 제공할 수 없으며, 이에 대한 모든 책임은 Marinesoft가 진다. 다만, 다음의 경우에는 예외로 한다. 
① 통계작성, 학술연구 또는 시장조사를 위하여 필요한 경우로서 특정 개인을 식별할 수 없는 형태로 제공하는 경우.
② 전기통신기본법 등 법률의 규정에 의해 국가기관의 요구가 있는 경우.
③ 범죄에 대한 수사상의 목적이 있거나 정보통신윤리위원회의 요청이 있는 경우.
④ 기타 관계법령에서 정한 절차에 따른 요청이 있는 경우.
3. 이용자는 언제든지 Marinesoft가 가지고 있는 자신의 개인정보에 대해 열람 및 오류정정을 요구할 수 있으며 Marinesoft는 이에 대해 지체 없이 처리한다.

제8조 (이용자의 의무)
1. 이용자는 관계법령, 이 약관의 규정, 이용안내 및 주의사항 등 Marinesoft가 통지하는 사항을 준수하여야 하며, 기타 Marinesoft의 업무에 방해되는 행위를 하여서는 안된다.
2. 이용자는 Marinesoft의 사전 승낙 없이 앱 서비스를 이용하여 어떠한 영리 행위도 할 수 없다.
3. 이용자는 앱 서비스를 이용하여 얻은 정보를 Marinesoft의 사전 승낙 없이 복사, 복제, 변경, 번역, 출판, 방송 기타의 방법으로 사용하거나 이를 타인에게 제공할 수 없다.
4. 이용자는 서비스 이용과 관련하여 다음 각 호의 행위를 하여서는 안된다.
① 다른 이용자의 e-mail 아이디(ID)를 부정 사용하는 행위.
② 범죄행위를 목적으로 하거나 기타 범죄행위와 관련된 행위.
③ 선량한 풍속, 기타 사회질서를 해하는 행위.
④ 타인의 명예를 훼손하거나 모욕하는 행위.
⑤ 타인의 지적재산권 등의 권리를 침해하는 행위.
⑥ 해킹행위 또는 컴퓨터바이러스의 유포행위.
⑦ 서비스의 안전적인 운영에 지장을 주거나 줄 우려가 있는 일체의 행위
⑧ 기타 관계법령에 위배되는 행위.

제9조 (면책·배상)
1. Marinesoft는 이용자가 서비스에 게재한 정보, 자료, 사실의 정확성, 신뢰성 등 그 내용에 관하여는 어떠한 책임을 부담하지 아니하고, 이용자는 자기의 책임아래 서비스를 이용하며, 서비스를 이용하여 게시 또는 전송한 자료 등에 관하여 손해가 발생하거나 자료의 취사 선택, 기타서비스 이용과 관련하여 어떠한 불이익이 발생 하더라도 이에 대한 모든 책임은 이용자에게 있다.
2. Marinesoft는 이용자간 또는 이용자와 제3자간에 서비스를 매개로 하여 물품거래 등과 관련하여 어떠한 책임도 부담하지 아니하고, 이용자가 서비스의 이용과 관련하여 기대하는 이익에 관하여 책임을 부담하지 않는다.
3. 이용상의 부주의로 인하여 발생 되는 손해 또는 제3자에 의한 부정사용 등에 대한 책임은 모두 이용자에게 있다.
4. 이용자가 기타 이 약관의 규정을 위반함으로 인하여 Marinesoft가 이용자 또는 제3자에 대하여 책임을 부담하게 되고, 이로써 Marinesoft에게 손해가 발생하게 되는 경우, 이 약관을 위반한 이용자는 Marinesoft에게 발생하는 모든 손해를 배상하여야 하며, 동 손해로부터 Marinesoft를 면책시켜야 한다.

제10조 (분쟁의 해결)
1. Marinesoft와 이용자는 서비스와 관련하여 발생한 분쟁을 원만하게 해결하기 위하여 필요한 모든 노력을 하여야 한다.
2. 1항의 규정에도 불구하고 분쟁으로 인하여 소송이 제기될 경우 소송은 Marinesoft의 소재지를 관할하는 법원의 관할로 한다.
''';
  static const String terms_privacy_detail_tile = '개인정보취급방침';
  static const String terms_privacy_detail = '''반갑습니다.
여러분의 개인정보의 안전한 취급은 마린소프트에게 있어 가장 중요한 일 중 하나입니다.
여러분의 개인정보는 마린소프트 서비스의 원활한 제공을 위하여 여러분이 동의한 목적과 범위 내에서만 이용됩니다. 법령에 의하거나 여러분이 별도로 동의하지 않는 한 마린소프트가 여러분의 개인정보를 제3자에게 제공하는 일은 결코 없으므로, 안심하셔도 좋습니다.
개인정보 취급방침은 항상 공개되어 있으니 지금 당장이 아니더라도 궁금하실 때는 언제든지 읽어보실 수 있습니다. 개인정보 취급방침이 바뀐 때에는 여러분이 언제든지 그 내용과 이유를 쉽게 알 수 있도록 공지를 통하여 알려드리겠습니다.

여러분의 소중한 개인정보는 마린소프트가 여러분에게 더 나은 서비스를 제공하기 위해 활용됩니다.
마린소프트는 앱 서비스를 원활하게 제공하고 더욱 향상된 이용자 경험을 드리기 위해 필요한 여러분의 개인정보를 수집합니다. 여러분에게 개별적으로 알려드릴 사항이 있는 때나, 서비스 이용과 관련하여 문의나 분쟁이 있는 경우, 유료서비스 이용시 컨텐츠 등의 전송이나 배송·요금 정산을 위해서도 필요합니다. 그 외에도, 여러분을 위한 새로운 맞춤형 서비스를 제공해 드리기 위한 통계적 분석, 각종 이벤트나 광고성 정보의 제공, 법령 등에 규정된 의무의 이행, 법령이나 이용약관에 반하여 여러분에게 피해를 줄 수 있는 잘못된 이용행위의 방지를 위해서도 여러분의 개인정보가 활용됩니다.

마린소프트가 더 나은 서비스를 제공해 드리기 위해 수집하는 여러분의 개인정보는 아래와 같습니다.
마린소프트는 여러분의 개별 어플리케이션의 질문&건의를 통하여 이메일 ID를 수집합니다. 그 외에도 여러분이 유료서비스를 이용하는 과정에서 결제 등을 위하여 불가피하게 필요한 때에 따라 신용카드 정보, 통신사 정보, 상품권 번호 등과 같이 결제에 필요한 정보가 수집될 수 있습니다.
마린소프트는 여러분이 개별 어플리케이션을 이용하려 할 때 수집하는 개인정보에 대하여 별도로 알려 드리며 이에 따라 여러분의 동의를 받고 서비스를 제공하게 됩니다.

마린소프트는 여러분의 별도 동의가 있는 경우나 법령에 규정된 경우를 제외하고는 여러분의 개인정보를 절대 제3자에게 제공하지 않습니다.
마린소프트는 여러분이 추후 앱 서비스 이용과정 등에서 따로 동의하는 경우나 법령에 규정된 경우를 제외하고는 여러분의 개인정보를 위에서 말씀 드린 목적 범위를 초과하여 이용하거나 제3자에게 제공 또는 공유하지 않습니다.

여러분의 개인정보는 동의를 받은 개인정보의 수집 및 이용목적이 달성되면 법령 또는 내부방침에 의해 보존할 필요가 있는 경우를 제외하고는 지체 없이 파기됩니다.
여러분의 개인정보는 여러분으로부터 동의를 받은 수집 및 이용목적이 달성된 때에는 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 관계 법령에서 정한 기간 1년 동안 보관한 다음 파기합니다. 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기하고, 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다. 다만, 앱 서비스의 부정한 이용으로 인한 분쟁을 방지하기 위한 마린소프트 내부방침에 따라 앱 서비스의 부정이용기록은 일정한 보존기간 후 다음 위의 방법으로 파기됩니다.

● 보존항목 : 소비자의 불만 또는 분쟁처리에 관한 기록
● 근거법령 : 전자상거래 ��에서의 소비자보호에 관한 법률
● 보존기간 : 3년

● 보존항목 : 전자금융 거래에 관한 기록
● 근거법령 : 전자금융거래법
● 보존기간 : 5년

마린소프트는 여러분의 권리를 보호합니다.
앱 서비스 내 이메일을 통해 개인정보관리책임자에게 연락하시면 지체 없이 조치하겠습니다.

개인정보 취급방침이 변경되는 경우 별도로 알려 드리겠습니다.
마린소프트는 법률이나 앱 서비스의 변경사항을 반영하기 위한 목적 등으로 개인정보 취급방침을 수정할 수 있습니다. 개인정보 취급방침이 변경되는 경우 마린소프트는 변경사항을 게시하며, 변경된 개인정보 취급방침은 게시한 날로부터 7일 후부터 효력이 발생합니다. 여러분의 권리에 중요한 변경이 있을 경우 변경된 내용을 30일 전에 미리 알려드리겠습니다.

궁금하신 사항은...
여러분이 마린소프트 앱 서비스를 이용하면서 발생하는 모든 개인정보보호 관련 문의, 불만, 조언이나 기타 사항은 앱 서비스 내 이메일을 통해 연락해 주시기 바랍니다. 마린소프트는 여러분의 목소리에 귀 기울이고 신속하고 충분한 답변을 드릴 수 있도록 최선을 다하겠습니다.''';
}
