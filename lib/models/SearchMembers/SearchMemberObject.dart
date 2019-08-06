class SearchMemberObject {

  final String userId;
  final String userName;
  final String isToken;
  final String schoolName;

  SearchMemberObject({this.userId, this.userName, this.isToken, this.schoolName});

  factory SearchMemberObject.fromJson(Map<String, dynamic> jsonRows) {
    return SearchMemberObject(
      userId : jsonRows['userId'],
      userName : jsonRows['userName'],
      isToken : jsonRows['isToken'],
      schoolName : jsonRows['schoolName'],
    );
  }
}