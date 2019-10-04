class SearchMemberObject {
  final String userId;
  final String userName;
  final String isToken;
  final String schoolName;
  final String schoolGisu;

  SearchMemberObject(
      {this.userId,
      this.userName,
      this.isToken,
      this.schoolName,
      this.schoolGisu});

  factory SearchMemberObject.fromJson(Map<String, dynamic> jsonRows) {
    return SearchMemberObject(
      userId: jsonRows['userId'],
      userName: jsonRows['userName'],
      isToken: jsonRows['isToken'],
      schoolName: jsonRows['schoolName'],
      schoolGisu: jsonRows['schoolGisu'],
    );
  }
}
