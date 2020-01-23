import 'package:flutter/material.dart';
import 'package:haegisa2/models/Vote/VoteObject.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class _StaticDbInformation {
  static const String dbName = 'my_db_haegisa2.db';
  static const String tblConversation = 'tblConversations';
  static const String tblVotes = 'tblVotes';
  static const String tblVotesAnswers = 'tblVotesAnswers';
  static const String tblSurveysAnswers = 'tblSurveysAnswers';
  static const String tblChats = 'tblChats';
  static const String tblBlockUsers = 'tblBlockUsers';
  static const String tblSurveys = 'tblSurveys';
  static const String tblNotices = 'tblNotices';
  static const String tblQna = 'tblQna';

  static const String tblNoticesId = 'noticeId';
  static const String tblNoticesSubject = 'subject';
  static const String tblNoticesFromId = 'fromId';
  static const String tblNoticesFromName = 'fromName';
  static const String tblNoticesContent = 'content';
  static const String tblNoticesRegDate = 'regDate';
  static const String tblNoticesSeen = 'seen';

  static const String tblConversationFieldId = 'convId';
  static const String tblConversationCreateDate = 'createDate';
  static const String tblConversationUpdaterField = 'updaterField';
  static const String tblConversationOtherSideUserId = 'otherSideUserId';
  static const String tblConversationOtherSideUserFromName =
      'otherSideUserName';

  static const String tblBlockUsersUserId = 'userId';

  static const String tblChatsChatId = 'chatId';
  static const String tblChatsChatDate = 'chatDate';
  static const String tblChatsChatDate2 = 'chatDate2';
  static const String tblChatsConvId = 'convId';
  static const String tblChatsContent = 'content';
  static const String tblChatsIsYours = 'isYours';
  static const String tblChatsSeen = 'seen';

  static const String tblVotesStartDate = 'startDate';
  static const String tblVotesEndDate = 'endDate';
  static const String tblVotesSubject = 'subject';
  static const String tblVotesFromId = 'fromId';
  static const String tblVotesFromName = 'fromName';
  static const String tblVotesHttpPath = 'httpPath';
  static const String tblVotesIdx = 'idx';
  static const String tblVotesContent = 'content';
  static const String tblVotesRegDate = 'regDate';

  static const String tblAnswersVoteIdx = 'voteIdx';
  static const String tblAnswersVoteDone = 'voteDone';
  static const String tblAnswersStatus = 'status';
  static const String tblAnswersAnswer1 = 'answ1';
  static const String tblAnswersAnswer2 = 'answ2';
  static const String tblAnswersAnswer3 = 'answ3';
  static const String tblAnswersAnswer4 = 'answ4';
  static const String tblAnswersAnswer5 = 'answ5';
  static const String tblAnswersAnswer6 = 'answ6';

  static const String tblAnswersSurveyIdx = 'surveyIdx';
  static const String tblAnswersSurveyQN = 'qNumber';
  static const String tblAnswersSurveyCNT = 'qCnt';
  static const String tblAnswersSurveyTitle = 'title';
  static const String tblAnswersSurveyResult1 = 'result1';
  static const String tblAnswersSurveyResult2 = 'result2';
  static const String tblAnswersSurveyResult3 = 'result3';
  static const String tblAnswersSurveyResult4 = 'result4';
  static const String tblAnswersSurveyResult5 = 'result5';
  static const String tblAnswersSurveyResult6 = 'result6';
  static const String tblAnswersSurveyResult7 = 'result7';
  static const String tblAnswersSurveyResult8 = 'result8';
  static const String tblAnswersSurveyQ1 = 'q1';
  static const String tblAnswersSurveyQ2 = 'q2';
  static const String tblAnswersSurveyQ3 = 'q3';
  static const String tblAnswersSurveyQ4 = 'q4';
  static const String tblAnswersSurveyQ5 = 'q5';
  static const String tblAnswersSurveyQ6 = 'q6';
  static const String tblAnswersSurveyQ7 = 'q7';
  static const String tblAnswersSurveyQ8 = 'q8';

  static const String tblSurveysNo = 'no';
  static const String tblSurveysDone = 'isDone';
  static const String tblSurveysBdIdx = 'bd_idx';
  static const String tblSurveysStartDate = 'start_date';
  static const String tblSurveysEndDate = 'end_date';
  static const String tblSurveysSubject = 'subject';
  static const String tblSurveysContents = 'contents';
  static const String tblSurveysQcnt = 'q_cnt';
  static const String tblSurveysRegDate = 'regDate';

  static const String tblQnaIdx = 'idx';
  static const String tblQnaSubject = 'subject';
  static const String tblQnaSeen = 'seen';
  static const String tblQnaRegDate = 'regDate';
}

class MyDataBase {
  SharedPreferences prefs;

  MyDataBase() {
    //_deleteDataBase();
    _checkDataBaseIsCreated();
  }

  void _checkDataBaseIsCreated() async {
    await SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      bool dbStatus = prefs.getBool('my_database_iscreated');
      print(":::::::::: DB STATUS => [${dbStatus}] ::::::::::");
      if (dbStatus != true) {
        print("CREATION:::::");
        _createDataBase();
      }
    });
  }

  void _createDataBase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db
          .execute(
              'CREATE TABLE ${_StaticDbInformation.tblConversation} (id INTEGER PRIMARY KEY AUTOINCREMENT , ${_StaticDbInformation.tblConversationUpdaterField} INTEGER,${_StaticDbInformation.tblConversationFieldId} TEXT,${_StaticDbInformation.tblConversationOtherSideUserId} TEXT,${_StaticDbInformation.tblConversationCreateDate} TEXT, ${_StaticDbInformation.tblConversationOtherSideUserFromName} TEXT)')
          .then((val) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblConversation} STATUS => [TRUE] ::::::::::");
      }).catchError((error) {
        print(
            ":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
      });

      await db
          .execute(
              'CREATE TABLE ${_StaticDbInformation.tblChats} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblChatsChatId} TEXT,${_StaticDbInformation.tblChatsSeen} TEXT,${_StaticDbInformation.tblChatsConvId} TEXT,${_StaticDbInformation.tblChatsContent} TEXT,${_StaticDbInformation.tblChatsChatDate} TEXT,${_StaticDbInformation.tblChatsChatDate2} TEXT, ${_StaticDbInformation.tblChatsIsYours} TEXT)')
          .then((val) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblChats} STATUS => [TRUE] ::::::::::");
      }).catchError((error) {
        print(
            ":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
      });

      await db
          .execute(
              'CREATE TABLE ${_StaticDbInformation.tblNotices} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblNoticesId} TEXT,${_StaticDbInformation.tblNoticesRegDate} TEXT,${_StaticDbInformation.tblNoticesFromId} TEXT,${_StaticDbInformation.tblNoticesFromName} TEXT,${_StaticDbInformation.tblNoticesSubject} TEXT,${_StaticDbInformation.tblNoticesContent} TEXT,${_StaticDbInformation.tblNoticesSeen} TEXT)')
          .then((val) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblNotices} STATUS => [TRUE] ::::::::::");
      }).catchError((error) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblNotices} ${error.toString()} STATUS => [FALSE] ::::::::::");
      });

      await db
          .execute(
              'CREATE TABLE ${_StaticDbInformation.tblBlockUsers} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblBlockUsersUserId} TEXT)')
          .then((val) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblChats} STATUS => [TRUE] ::::::::::");
      }).catchError((error) {
        print(
            ":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
      });

      await db
          .execute(
              'CREATE TABLE ${_StaticDbInformation.tblVotes} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblVotesContent} TEXT,${_StaticDbInformation.tblVotesFromId} TEXT,${_StaticDbInformation.tblVotesFromName} TEXT,${_StaticDbInformation.tblVotesHttpPath} TEXT, ${_StaticDbInformation.tblVotesIdx} TEXT, ${_StaticDbInformation.tblVotesRegDate} TEXT, ${_StaticDbInformation.tblVotesStartDate} TEXT, ${_StaticDbInformation.tblVotesEndDate} TEXT, ${_StaticDbInformation.tblVotesSubject} TEXT)')
          .then((val) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblVotes} STATUS => [TRUE] ::::::::::");
      }).catchError((error) {
        print(
            ":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
      });

      await db
          .execute(
              'CREATE TABLE ${_StaticDbInformation.tblVotesAnswers} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblAnswersVoteIdx} TEXT, ${_StaticDbInformation.tblAnswersVoteDone} TEXT,${_StaticDbInformation.tblAnswersStatus} TEXT,${_StaticDbInformation.tblAnswersAnswer1} TEXT,${_StaticDbInformation.tblAnswersAnswer2} TEXT, ${_StaticDbInformation.tblAnswersAnswer3} TEXT, ${_StaticDbInformation.tblAnswersAnswer4} TEXT, ${_StaticDbInformation.tblAnswersAnswer5} TEXT, ${_StaticDbInformation.tblAnswersAnswer6} TEXT)')
          .then((val) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblVotesAnswers} STATUS => [TRUE] ::::::::::");
      }).catchError((error) {
        print(
            ":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
      });

      await db
          .execute(
              'CREATE TABLE ${_StaticDbInformation.tblSurveys} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblSurveysNo} TEXT, ${_StaticDbInformation.tblSurveysRegDate} TEXT, ${_StaticDbInformation.tblSurveysDone} TEXT,${_StaticDbInformation.tblSurveysBdIdx} TEXT,${_StaticDbInformation.tblSurveysStartDate} TEXT,${_StaticDbInformation.tblSurveysEndDate} TEXT, ${_StaticDbInformation.tblSurveysSubject} TEXT, ${_StaticDbInformation.tblSurveysContents} TEXT, ${_StaticDbInformation.tblSurveysQcnt} TEXT)')
          .then((val) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblSurveys} STATUS => [TRUE] ::::::::::");
      }).catchError((error) {
        print(
            ":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
      });

      await db
          .execute(
              'CREATE TABLE ${_StaticDbInformation.tblSurveysAnswers} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblAnswersSurveyIdx} TEXT,${_StaticDbInformation.tblAnswersSurveyResult1} TEXT,${_StaticDbInformation.tblAnswersSurveyResult2} TEXT,${_StaticDbInformation.tblAnswersSurveyResult3} TEXT,${_StaticDbInformation.tblAnswersSurveyResult4} TEXT,${_StaticDbInformation.tblAnswersSurveyResult5} TEXT,${_StaticDbInformation.tblAnswersSurveyResult6} TEXT,${_StaticDbInformation.tblAnswersSurveyResult7} TEXT,${_StaticDbInformation.tblAnswersSurveyResult8} TEXT, ${_StaticDbInformation.tblAnswersSurveyQN} TEXT, ${_StaticDbInformation.tblAnswersSurveyTitle} TEXT,${_StaticDbInformation.tblAnswersSurveyCNT} TEXT,${_StaticDbInformation.tblAnswersSurveyQ1} TEXT,${_StaticDbInformation.tblAnswersSurveyQ2} TEXT,${_StaticDbInformation.tblAnswersSurveyQ3} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ4} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ5} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ6} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ7} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ8} TEXT)')
          .then((val) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblSurveysAnswers} STATUS => [TRUE] ::::::::::");
      }).catchError((error) {
        print(
            ":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
      });

      await db
          .execute(
              'CREATE TABLE ${_StaticDbInformation.tblQna} (${_StaticDbInformation.tblQnaIdx} TEXT PRIMARY KEY, ${_StaticDbInformation.tblQnaSubject} TEXT,${_StaticDbInformation.tblQnaSeen} TEXT,${_StaticDbInformation.tblQnaRegDate} TEXT)')
          .then((val) {
        print(
            ":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblQna} STATUS => [TRUE] ::::::::::");
      }).catchError((error) {
        print(
            ":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
      });

      //await db.execute('');
    } // Create DataBase
            )
        .catchError(
            (er) => print("Error While Createing Table ${er.toString()}"))
        .then((val) {
      prefs.setBool('my_database_iscreated', true);
      print(":::::::::: DB INITIALIZING STATUS => [TRUE] ::::::::::");
      //val.close();
    });
  }

  void _deleteDataBase() async {
    prefs = await SharedPreferences.getInstance();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    await deleteDatabase(path).then((val) {
      prefs.setBool('my_database_iscreated', false);
    });
  }

  void firstWelcomeMessage({VoidCallback whenComplete}) {
    print(
        ":::::::::::::::::::::::: [Initializing First Welcome Message] ::::::::::::::::::::::::");
    const adminConvId = 'x0x0';
    const adminUserId = '0';
    this.checkConversationExist(
        convId: adminConvId,
        userId: adminUserId,
        onResult: (res) {
          print(
              ":::::::::: WELCOME MESSAGE ALREADY ADDED SUCCESFULLY ::::::::::");
        },
        onNoResult: () {
          this.insertConversation(
              convId: adminConvId,
              userId: adminUserId,
              createDate: DateTime.now().toString(),
              fromName: '한국해기사협회',
              schoolName: 'Haegisa Company',
              schoolGisu: '',
              onNoInerted: () {
                print(
                    ":::::::::::::::::::::::: [Initialization First Conversation Welcome Message Failed!] ::::::::::::::::::::::::");
              },
              onInserted: () {
                print(
                    ":::::::::::::::::::::::: [Initialization First Conversation Welcome Message Done.] ::::::::::::::::::::::::");
                this.insertChat(
                    userId: adminUserId,
                    convId: adminConvId,
                    isYours: 'FALSE',
                    seen: "0",
                    date: DateTime.now().toString(),
                    content:
                        "반갑습니다. 한국해기사협회입니다. 앞으로 다양한 소식과 정보를 앱으로 받아보실 수 있습니다.",
                    onAdded: () {
                      whenComplete();
                      print(
                          ":::::::::::::::::::::::: [Initialization First Chat Welcome Message Done.] ::::::::::::::::::::::::");
                    });
              });
        });
  }

  void insertBlockUsers({String userId, onBlock(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    print(":::::::::: NEW Users Block GENERATING ... ::::::::::");
    await openDatabase(path).then((db) {
      db
          .rawInsert(
              'INSERT INTO ${_StaticDbInformation.tblBlockUsers} (${_StaticDbInformation.tblBlockUsersUserId}) VALUES ("${userId}")')
          .catchError((err) {
        print(
            ":::::::::: DB INSERT(NEW Users Block) ERROR => [${err.toString()}] ::::::::::");
        onBlock(false);
      }).then((val) {
        print(
            ":::::::::: DB INSERT(NEW Users Block) QUERY => [${val.toString()}] ::::::::::");
        onBlock(true);
      }).whenComplete(() {
        //db.close();
        print(":::::::::: DB CLOSE ::::::::::");
      });
    });
  }

  void checkUsersBlock({String userId = "", isBlocked(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      Map<String, dynamic> obj;
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblBlockUsers} WHERE ${_StaticDbInformation.tblBlockUsersUserId} = '${userId}'")
          .then((lists) {
        if (lists.length > 0) {
          print(
              ":::::::::: DB SELECT(BlockUsers) ROW (${0}) => [${lists.first.toString()}] ::::::::::");
          //db.close();
          isBlocked(true);
        } else {
          print(
              ":::::::::: DB SELECT(BlockUsers) ROW (${0}) => Not Found Any Items ::::::::::");
          //db.close();
          isBlocked(false);
        }
      });
    });
  }

  void unBlockUsers({String userId, onUpdated(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    print(":::::::::: Un Block User ... ::::::::::");
    await openDatabase(path).then((db) {
      db
          .rawInsert(
              "DELETE FROM ${_StaticDbInformation.tblBlockUsers} WHERE ${_StaticDbInformation.tblBlockUsersUserId} = '${userId.toString()}'")
          .catchError((err) {
        print(
            ":::::::::: DB Update(Un Users Block) ERROR => [${err.toString()}] ::::::::::");
        onUpdated(false);
      }).then((val) {
        print(
            ":::::::::: DB Update(Un Users Block) QUERY => [${val.toString()}] ::::::::::");
        onUpdated(true);
      }).whenComplete(() {
        //db.close();
        print(":::::::::: DB CLOSE ::::::::::");
      });
    });
  }

  void insertConversation(
      {String convId,
      String userId,
      String createDate,
      String fromName,
      String schoolName,
      String schoolGisu,
      onInserted(),
      onNoInerted()}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    print(":::::::::: NEW Conversation GENERATING ... ::::::::::");
    await openDatabase(path).then((db) {
      db
          .rawInsert(
              'INSERT INTO ${_StaticDbInformation.tblConversation} (${_StaticDbInformation.tblConversationFieldId},${_StaticDbInformation.tblConversationUpdaterField},${_StaticDbInformation.tblConversationOtherSideUserId},${_StaticDbInformation.tblConversationCreateDate}, ${_StaticDbInformation.tblConversationOtherSideUserFromName}) VALUES ("${convId.toString()}","0","${userId.toString()}","${createDate.toString()}","${fromName.toString()}")')
          .catchError((err) {
        print(
            ":::::::::: DB INSERT(conversation) ERROR => [${err.toString()}] ::::::::::");
        onNoInerted();
      }).then((val) {
        print(
            ":::::::::: DB INSERT(conversation) QUERY => [${val.toString()}] ::::::::::");
        onInserted();
      }).whenComplete(() {
        //db.close();
        print(":::::::::: DB CLOSE ::::::::::");
      });
    });
  }

  void insertNotice(
      {String noticeId = "",
      String subject,
      String fromId,
      String fromName,
      String content,
      String seen = "0",
      onInserted(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    print(":::::::::: NEW Notice GENERATING ... ::::::::::");
    await openDatabase(path).then((db) {
      db
          .rawInsert(
              'INSERT INTO ${_StaticDbInformation.tblNotices} (${_StaticDbInformation.tblNoticesId},${_StaticDbInformation.tblNoticesRegDate},${_StaticDbInformation.tblNoticesFromId},${_StaticDbInformation.tblNoticesFromName},${_StaticDbInformation.tblNoticesSubject}, ${_StaticDbInformation.tblNoticesContent}, ${_StaticDbInformation.tblNoticesSeen}) VALUES ("${noticeId.toString()}","${DateTime.now().toString()}","${fromId.toString()}","${fromName.toString()}","${subject.toString()}","${content.toString()}","${seen.toString()}")')
          .catchError((err) {
        print(
            ":::::::::: DB INSERT(Notices) ERROR => [${err.toString()}] ::::::::::");
        onInserted(false);
      }).then((val) {
        print(
            ":::::::::: DB INSERT(Notices) QUERY => [${val.toString()}] ::::::::::");
        onInserted(true);
      }).whenComplete(() {
        //db.close();
        print(":::::::::: DB CLOSE ::::::::::");
      });
    });
  }

  void updateSeenNotice({String id}) async {
    //why did you update chatDate2?? chatDate2 is last chat response date
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawQuery(
              "UPDATE ${_StaticDbInformation.tblNotices} SET seen = '1' WHERE id='${id.toString()}'")
          //"UPDATE ${_StaticDbInformation.tblChats} SET seen = '1', chatDate2 = '${lastDate.toString()}' WHERE convId = '${convId}'"
          .then((lists) {
        print(":::::::::: DB UPDATE SEEN Notices(${lists.length}) ::::::::::");
        //db.close();
      }).catchError((error) {
        print(
            ":::::::::: DB UPDATE SEEN Notices ERROR => [${error.toString()}] ::::::::::");
      });
    });
  }

  void selectConversations(
      {onResult(List<Map<String, dynamic>> results)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      List<Map<String, dynamic>> myList = [];
      db
          .rawQuery(
              'SELECT * FROM ${_StaticDbInformation.tblConversation} GROUP BY convId ORDER BY id DESC')
          .then((lists) {
        for (int i = 0; i < lists.length; i++) {
          myList.add(lists[i]);
          print(
              ":::::::::: DB SELECT(conversation) ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        } // for loop
        onResult(myList);
      });
      //db.close();
    });
  }

  void checkConversationExist(
      {onResult(Map<String, dynamic> result),
      String convId = "",
      String userId = "",
      onNoResult()}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      Map<String, dynamic> obj;
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblConversation} WHERE ${_StaticDbInformation.tblConversationOtherSideUserId} = '${userId}' and ${_StaticDbInformation.tblConversationFieldId} = '${convId}'")
          .then((lists) {
        if (lists.length > 0) {
          obj = lists.first;
          print(
              ":::::::::: DB SELECT(conversation) ROW (${0}) => [${lists.first.toString()}] ::::::::::");
          //db.close();
          onResult(obj);
        } else {
          print(
              ":::::::::: DB SELECT(conversation) ROW (${0}) => Not Found Any Items ::::::::::");
          //db.close();
          onNoResult();
        }
      });
    });
  }

  void checkConversationExistByUser(
      {onResult(Map<String, dynamic> result),
      String userId = "",
      onNoResult()}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      Map<String, dynamic> obj;
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblConversation} WHERE ${_StaticDbInformation.tblConversationOtherSideUserId} = '${userId}'")
          .then((lists) {
        if (lists.length > 0) {
          obj = lists.first;
          print(
              ":::::::::: DB SELECT(conversation) ROW (${0}) => [${lists.first.toString()}] ::::::::::");
          //db.close();
          onResult(obj);
        } else {
          print(
              ":::::::::: DB SELECT(conversation) ROW (${0}) => Not Found Any Items ::::::::::");
          //db.close();
          onNoResult();
        }
      });
    });
  }

  void deleteConversation({String convId = "", onDeleted(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawDelete(
              "DELETE FROM ${_StaticDbInformation.tblConversation} WHERE convId = '${convId}'")
          .then((val) {
        print(":::::::::: DB DELETE(conversation) ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err) {
        print(
            ":::::::::: DB DELETE(conversation) ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void updateConversation({String convId, VoidCallback onComplete}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      List<Map<String, dynamic>> myList = [];
      db
          .rawQuery(
              'UPDATE ${_StaticDbInformation.tblConversation} SET ${_StaticDbInformation.tblConversationUpdaterField} = (id + 1) WHERE ${_StaticDbInformation.tblConversationFieldId} = "${convId.toString()}"')
          .then((lists) {
        if (lists.length > 0) {
          print(
              ":::::::::: DB UPDATE(conversation) Was Successfull. ::::::::::");
          onComplete();
        } else {
          print(":::::::::: DB UPDATE(conversation) Was Failed. ::::::::::");
        }
      });
      //db.close();
    });
  }

  void checkChatExistByUser(
      {onResult(Map<String, dynamic> result),
      String chatId = "",
      onNoResult()}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      Map<String, dynamic> obj;
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblChats} WHERE ${_StaticDbInformation.tblChatsChatId} = '${chatId.toString()}'")
          .then((lists) {
        if (lists.length > 0) {
          obj = lists.first;
          print(
              ":::::::::: DB SELECT(chats) ROW (${0}) => [${lists.first.toString()}] ::::::::::");
          //db.close();
          onResult(obj);
        } else {
          print(
              ":::::::::: DB SELECT(chats) ROW (${0}) => Not Found Any Items ::::::::::");
          //db.close();
          onNoResult();
        }
      });
    });
  }

  void insertChat(
      {String convId,
      String seen = "1",
      String chatId = "",
      String userId,
      String date,
      String content,
      String isYours = "FALSE",
      onAdded()}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      String dt = "";
      dt =
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";

      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO ${_StaticDbInformation.tblChats} (${_StaticDbInformation.tblChatsChatId},${_StaticDbInformation.tblChatsConvId},${_StaticDbInformation.tblChatsSeen},${_StaticDbInformation.tblChatsContent},${_StaticDbInformation.tblChatsChatDate},${_StaticDbInformation.tblChatsChatDate2}, ${_StaticDbInformation.tblChatsIsYours}) VALUES ("${chatId.toString()}","${convId.toString()}","${seen.toString()}","${content.toString()}","${date.toString()}","${dt.toString()}","${isYours.toString()}")');
        print(
            ":::::::::: DB INSERT(chat) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      });
    });
  }

  void selectChats(
      {onResult(List<Map<String, dynamic>> results), String convId}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      List<Map<String, dynamic>> myList = [];
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblChats} WHERE convId = '${convId}' ORDER BY id ASC")
          .then((lists) {
        for (int i = 0; i < lists.length; i++) {
          myList.add(lists[i]);
          print(
              ":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        } // for loop
        //db.close();
        onResult(myList);
      });
    });
  }

  void selectLastChatContent(
      {onResult(Map<String, dynamic> res), String convId}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawQuery(
              "SELECT content,seen,chatDate,chatDate2,chatId FROM ${_StaticDbInformation.tblChats} WHERE convId = '${convId}'  ORDER BY id DESC LIMIT 1")
          .then((lists) {
        print(
            ":::::::::: DB SELECT ROW LIMIT 1(${lists.length}) => [${lists.first.toString()}] ::::::::::");
        //db.close();
        if (lists.length > 0) {
          onResult(lists.first);
        } else {
          onResult(null);
        }
      }).catchError((error) {
        print(
            ":::::::::: DB SELECT ROW LIMIT 1 ERROR => [${error.toString()}] ::::::::::");
        onResult(null);
      });
    });
  }

  void deleteChat({String convId = "", onDeleted(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawDelete(
              "DELETE FROM ${_StaticDbInformation.tblChats} WHERE convId = '${convId}'")
          .then((val) {
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err) {
        print(
            ":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void updateSeenChats({String convId}) async {
    //why did you update chatDate2?? chatDate2 is last chat response date
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      String lastDate =
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
      db
          .rawQuery(
              "UPDATE ${_StaticDbInformation.tblChats} SET seen = '1' WHERE convId = '${convId}'")
          //"UPDATE ${_StaticDbInformation.tblChats} SET seen = '1', chatDate2 = '${lastDate.toString()}' WHERE convId = '${convId}'"
          .then((lists) {
        print(":::::::::: DB UPDATE SEEN CHATS(${lists.length}) ::::::::::");
        //db.close();
      }).catchError((error) {
        print(
            ":::::::::: DB UPDATE SEEN CHATS ERROR => [${error.toString()}] ::::::::::");
      });
    });
  }

  void insertSurvey(
      {onAdded(),
      String no,
      String isDone,
      String bd_idx,
      String start_date,
      String end_date,
      String subject,
      String content,
      String q_cnt}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO ${_StaticDbInformation.tblSurveys} (${_StaticDbInformation.tblSurveysNo},${_StaticDbInformation.tblSurveysRegDate},${_StaticDbInformation.tblSurveysDone},${_StaticDbInformation.tblSurveysBdIdx},${_StaticDbInformation.tblSurveysStartDate}, ${_StaticDbInformation.tblSurveysEndDate}, ${_StaticDbInformation.tblSurveysSubject}, ${_StaticDbInformation.tblSurveysContents}, ${_StaticDbInformation.tblSurveysQcnt}) VALUES ("${no.toString()}","${DateTime.now().toString()}","${isDone.toString()}","${bd_idx.toString()}","${start_date.toString()}","${end_date.toString()}","${subject.toString()}","${content.toString()}","${q_cnt.toString()}")');
        print(
            ":::::::::: DB INSERT(survey) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      }).catchError((err) {
        print(
            ":::::::::: DB INSERT(survey) QUERY ERROR => [${err.toString()}] ::::::::::");
      });
    });
  }

  void selectSurvey({onResult(List<Map<String, dynamic>> results)}) async {
    print(":::::::::: DB SELECTING SURVEY ::::::::::");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      List<Map<String, dynamic>> myList = [];
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblSurveys}  ORDER BY id DESC")
          .then((lists) {
        for (int i = 0; i < lists.length; i++) {
          myList.add(lists[i]);
          print(
              ":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        } // for loop
        //db.close();
        onResult(myList);
      }).catchError((err) {
        print(
            ":::::::::: DB ERROR SELECT SURVEY : ${err.toString()} ::::::::::");
      });
    });
  }

  void selectNotices({onResult(List<Map<String, dynamic>> results)}) async {
    print(":::::::::: DB SELECTING Notices ::::::::::");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      List<Map<String, dynamic>> myList = [];
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblNotices}  ORDER BY id DESC")
          .then((lists) {
        for (int i = 0; i < lists.length; i++) {
          myList.add(lists[i]);
          print(
              ":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        } // for loop
        //db.close();
        onResult(myList);
      }).catchError((err) {
        print(
            ":::::::::: DB ERROR SELECT Notices : ${err.toString()} ::::::::::");
      });
    });
  }

  void deleteNotices({int id, onDeleted(bool st)}) async {
    print(":::::::::: DB DELETE Notices ::::::::::");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database

    await openDatabase(path).then((db) {
      db
          .rawDelete(
              "DELETE FROM ${_StaticDbInformation.tblNotices} WHERE id='${id}'")
          .then((val) {
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err) {
        print(
            ":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void deleteSurvey({String no = "", onDeleted(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          // .rawDelete(
          //     "DELETE FROM ${_StaticDbInformation.tblSurveys} WHERE no='${no.toString()}'")
          .rawDelete("DELETE FROM ${_StaticDbInformation.tblSurveys}")
          .then((val) {
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err) {
        print(
            ":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void checkSurveyExist(
      {onResult(Map<String, dynamic> result),
      String no = "",
      onNoResult()}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblSurveys} WHERE ${_StaticDbInformation.tblSurveysNo} = '${no.toString()}'")
          .then((lists) {
        if (lists.length > 0) {
          print(
              ":::::::::: DB SELECT(Survey) ROW (${0}) => [${lists.first.toString()}] ::::::::::");
          //db.close();
          onResult(lists.first);
        } else {
          print(
              ":::::::::: DB SELECT(Survey) ROW (${0}) => Not Found Any Items ::::::::::");
          //db.close();
          onNoResult();
        }
      });
    });
  }

  void checkSurveyIsDone({onResult(bool st), String no = ""}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblSurveys} WHERE ${_StaticDbInformation.tblSurveysNo} = '${no.toString()}' and ${_StaticDbInformation.tblSurveysDone} = 'TRUE'")
          .then((lists) {
        if (lists.length > 0) {
          print(
              ":::::::::: DB SELECT(Survey is done) ROW (${0}) => [${lists.first.toString()}] ::::::::::");
          //db.close();
          onResult(true);
        } else {
          print(
              ":::::::::: DB SELECT(Survey is done) ROW (${0}) => Not Found Any Items ::::::::::");
          //db.close();
          onResult(false);
        }
      });
    });
  }

  void insertSurveyAnswer({
    String idx,
    String cnt = "0",
    String qTitle = "",
    String qN,
    String answer1 = "",
    String answer2 = "",
    String answer3 = "",
    String answer4 = "",
    String answer5 = "",
    String answer6 = "",
    String answer7 = "",
    String answer8 = "",
    onAdded(),
  }) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db.transaction((txn) async {
        String query =
            'INSERT INTO ${_StaticDbInformation.tblSurveysAnswers} (${_StaticDbInformation.tblAnswersSurveyIdx},${_StaticDbInformation.tblAnswersSurveyQN},${_StaticDbInformation.tblAnswersSurveyTitle},${_StaticDbInformation.tblAnswersSurveyCNT},${_StaticDbInformation.tblAnswersSurveyQ1},${_StaticDbInformation.tblAnswersSurveyQ2}, ${_StaticDbInformation.tblAnswersSurveyQ3}, ${_StaticDbInformation.tblAnswersSurveyQ4}, ${_StaticDbInformation.tblAnswersSurveyQ5}, ${_StaticDbInformation.tblAnswersSurveyQ6}, ${_StaticDbInformation.tblAnswersSurveyQ7}, ${_StaticDbInformation.tblAnswersSurveyQ8}) VALUES ("${idx.toString()}","${qN.toString()}","${qTitle.toString()}","${cnt.toString()}","${answer1.toString()}","${answer2.toString()}","${answer3.toString()}","${answer4.toString()}","${answer5.toString()}","${answer6.toString()}","${answer7.toString()}","${answer8.toString()}")';
        int id1 = await txn.rawInsert(query);
        print(
            ":::::::::: DB INSERT(answer survey) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      });
    });
  }

  void updateSurveyResult({
    String idx,
    String qNumber,
    String resNum,
    String result = "",
    onUpdated(),
  }) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db.transaction((txn) async {
        print(
            "QUERY ==> ${'UPDATE ${_StaticDbInformation.tblSurveysAnswers} SET result${resNum.toString()} = "${result.toString()}" WHERE ${_StaticDbInformation.tblAnswersSurveyIdx} = "${idx.toString()}" and ${_StaticDbInformation.tblAnswersSurveyQN} = "${qNumber.toString()}"'}");
        int id1 = await txn.rawInsert(
            'UPDATE ${_StaticDbInformation.tblSurveysAnswers} SET result${resNum.toString()} = "${result.toString()}" WHERE ${_StaticDbInformation.tblAnswersSurveyIdx} = "${idx.toString()}" and ${_StaticDbInformation.tblAnswersSurveyQN} = "${qNumber.toString()}"');
        print(
            ":::::::::: DB UPDATE(answer survey Resultxxxy) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onUpdated();
      });
    });
  }

  void updateSurveyisDone({
    String idx,
    String surveyDone = "FALSE",
    onUpdated(),
  }) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'UPDATE ${_StaticDbInformation.tblSurveys} SET ${_StaticDbInformation.tblSurveysDone} = "${surveyDone.toString()}" WHERE ${_StaticDbInformation.tblSurveysBdIdx} = "${idx.toString()}"');
        print(
            ":::::::::: DB UPDATE(answer survey) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onUpdated();
      });
    });
  }

  void selectSurveyAnswer(
      {onResult(List<Map<String, dynamic>> results),
      String idx,
      String qNumber = ""}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      List<Map<String, dynamic>> myList = [];
      String query = "";
      if (qNumber != "") {
        query =
            "SELECT * FROM ${_StaticDbInformation.tblSurveysAnswers} WHERE ${_StaticDbInformation.tblAnswersSurveyIdx} = '${idx}' and ${_StaticDbInformation.tblAnswersSurveyQN} = '${qNumber.toString()}'";
      } else {
        query =
            "SELECT * FROM ${_StaticDbInformation.tblSurveysAnswers} WHERE ${_StaticDbInformation.tblAnswersSurveyIdx} = '${idx}'";
      }
      db.rawQuery(query).then((lists) {
        for (int i = 0; i < lists.length; i++) {
          myList.add(lists[i]);
          print(
              ":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        } // for loop
        //db.close();
        onResult(myList);
      });
    });
  }

  void selectAllSurveyAnswer(
      {onResult(List<Map<String, dynamic>> results)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      List<Map<String, dynamic>> myList = [];
      String query = "";
      query = "SELECT * FROM ${_StaticDbInformation.tblSurveysAnswers}";
      db.rawQuery(query).then((lists) {
        for (int i = 0; i < lists.length; i++) {
          myList.add(lists[i]);
          print(
              ":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        } // for loop
        //db.close();
        onResult(myList);
      });
    });
  }

  void deleteSurveyAnswer({String idx = "", onDeleted(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          // .rawDelete(
          //     "DELETE FROM ${_StaticDbInformation.tblSurveysAnswers} WHERE ${_StaticDbInformation.tblAnswersSurveyIdx} = '${idx}'")
          .rawDelete("DELETE FROM ${_StaticDbInformation.tblSurveysAnswers}")
          .then((val) {
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err) {
        print(
            ":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void insertAnswer(
      {String idx,
      String status = "i",
      String answer1 = "",
      String answer2 = "",
      String answer3 = "",
      String answer4 = "",
      String answer5 = "",
      String answer6 = "",
      onAdded()}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO ${_StaticDbInformation.tblVotesAnswers} (${_StaticDbInformation.tblAnswersVoteIdx},${_StaticDbInformation.tblAnswersVoteDone},${_StaticDbInformation.tblAnswersStatus},${_StaticDbInformation.tblAnswersAnswer1}, ${_StaticDbInformation.tblAnswersAnswer2}, ${_StaticDbInformation.tblAnswersAnswer3}, ${_StaticDbInformation.tblAnswersAnswer4}, ${_StaticDbInformation.tblAnswersAnswer5}, ${_StaticDbInformation.tblAnswersAnswer6}) VALUES ("${idx.toString()}","FALSE","${status.toString()}","${answer1.toString()}","${answer2.toString()}","${answer3.toString()}","${answer4.toString()}","${answer5.toString()}","${answer6.toString()}")');
        print(
            ":::::::::: DB INSERT(answer) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      });
    });
  }

  void updateAnswer({
    String idx,
    String voteDone = "FALSE",
    onUpdated(),
  }) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'UPDATE ${_StaticDbInformation.tblVotesAnswers} SET ${_StaticDbInformation.tblAnswersVoteDone} = "${voteDone.toString()}" WHERE ${_StaticDbInformation.tblAnswersVoteIdx} = "${idx.toString()}"');
        print(
            ":::::::::: DB UPDATE(answer) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onUpdated();
      });
    });
  }

  void selectAnswer(
      {onResult(List<Map<String, dynamic>> results), String idx}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      List<Map<String, dynamic>> myList = [];
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblVotesAnswers} WHERE ${_StaticDbInformation.tblAnswersVoteIdx} = '${idx}'")
          .then((lists) {
        for (int i = 0; i < lists.length; i++) {
          myList.add(lists[i]);
          print(
              ":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        } // for loop
        //db.close();
        onResult(myList);
      });
    });
  }

  void deleteAnswer({String idx = "", onDeleted(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawDelete(
              "DELETE FROM ${_StaticDbInformation.tblVotesAnswers} WHERE ${_StaticDbInformation.tblAnswersVoteIdx} = '${idx}'")
          .then((val) {
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err) {
        print(
            ":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void checkVoteExist(
      {VoidCallback onRes, String bd_idx = "", onNoResult()}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblVotes} WHERE ${_StaticDbInformation.tblVotesIdx} = '${bd_idx.toString()}'")
          .then((lists) {
        if (lists.length > 0) {
          print(
              ":::::::::: DB SELECT(Votes) ROW (${0}) => [${lists.first.toString()}] ::::::::::");
          //db.close();
          onRes();
        } else {
          print(
              ":::::::::: DB SELECT(Votes) ROW (${0}) => Not Found Any Items ::::::::::");
          //db.close();
          onNoResult();
        }
      });
    });
  }

  void insertVote({VoteObject voteItem, onAdded()}) async {
    print(":::::::::: INSERTING VOTE ITEM IN DB ::::::::::");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO ${_StaticDbInformation.tblVotes} (${_StaticDbInformation.tblVotesSubject},${_StaticDbInformation.tblVotesStartDate},${_StaticDbInformation.tblVotesEndDate},${_StaticDbInformation.tblVotesRegDate}, ${_StaticDbInformation.tblVotesIdx}, ${_StaticDbInformation.tblVotesHttpPath}, ${_StaticDbInformation.tblVotesFromName}, ${_StaticDbInformation.tblVotesFromId}, ${_StaticDbInformation.tblVotesContent}) VALUES ("${voteItem.subject.toString()}","${voteItem.startDate.toString()}","${voteItem.endDate.toString()}","${voteItem.regDate.toString()}","${voteItem.idx.toString()}","${voteItem.httpPath.toString()}","${voteItem.fromName.toString()}","${voteItem.fromId.toString()}","${voteItem.content.toString()}")');
        print(
            ":::::::::: DB INSERT(vote) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      }).catchError((error) {
        print(
            ":::::::::: DB INSERT(vote) ERROR => [${error.toString()}] ::::::::::");
      });
    });
  }

  void selectVotes({onResult(List<VoteObject> results)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);

    await openDatabase(path).then((db) {
      List<VoteObject> myList = [];
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblVotes}  ORDER BY id DESC")
          .then((lists) {
        for (int i = 0; i < lists.length; i++) {
          var jso = {'data': lists[i]};
          myList.add(VoteObject.fromJson(jso));
          print(
              ":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        } // for loop
        //db.close();
        onResult(myList);
      }).catchError((err) {
        print("::::::::::: [ ERROR DB VOTE : ${err.toString()}] :::::::::::");
      });
    });
  }

  void deleteVote({int voteId = 0, onDeleted(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawDelete(
              "DELETE FROM ${_StaticDbInformation.tblVotes} WHERE id = '${voteId}'")
          .then((val) {
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err) {
        print(
            ":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void insertQna(
      {String idx = "",
      String regDate = "",
      String subject = "",
      String seen = "0",
      onInserted(bool st)}) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    print(":::::::::: NEW QNA GENERATING ... ::::::::::");
    await openDatabase(path).then((db) {
      db
          .rawInsert(
              'REPLACE INTO ${_StaticDbInformation.tblQna}(${_StaticDbInformation.tblQnaIdx}, ${_StaticDbInformation.tblQnaRegDate}, ${_StaticDbInformation.tblQnaSubject}, ${_StaticDbInformation.tblQnaSeen}) VALUES ("${idx.toString()}", "${regDate.toString()}", "${subject.toString()}", "${seen.toString()}")')
          .catchError((err) {
        print(
            ":::::::::: DB INSERT(QNA) ERROR => [${err.toString()}] ::::::::::");
        onInserted(false);
      }).then((val) {
        print(
            ":::::::::: DB INSERT(QNA) QUERY => [${val.toString()}] ::::::::::");
        onInserted(true);
      }).whenComplete(() {
        //db.close();
        print(":::::::::: DB CLOSE ::::::::::");
      });
    });
  }

  void selectQna({onResult(List<Map<String, dynamic>> results)}) async {
    print(":::::::::: DB SELECTING Qna ::::::::::");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      List<Map<String, dynamic>> myList = [];
      db
          .rawQuery(
              "SELECT * FROM ${_StaticDbInformation.tblQna}  ORDER BY idx DESC")
          .then((lists) {
        for (int i = 0; i < lists.length; i++) {
          myList.add(lists[i]);
          print(
              ":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        } // for loop
        //db.close();
        onResult(myList);
      }).catchError((err) {
        print(":::::::::: DB ERROR SELECT Qna : ${err.toString()} ::::::::::");
      });
    });
  }

  void updateSeenQna({String idx}) async {
    //why did you update chatDate2?? chatDate2 is last chat response date
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db) {
      db
          .rawQuery(
              "UPDATE ${_StaticDbInformation.tblQna} SET seen = '1' WHERE idx='${idx.toString()}'")
          //"UPDATE ${_StaticDbInformation.tblChats} SET seen = '1', chatDate2 = '${lastDate.toString()}' WHERE convId = '${convId}'"
          .then((lists) {
        print(":::::::::: DB UPDATE SEEN Notices(${lists.length}) ::::::::::");
        //db.close();
      }).catchError((error) {
        print(
            ":::::::::: DB UPDATE SEEN Notices ERROR => [${error.toString()}] ::::::::::");
      });
    });
  }

  String generateRandomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return new String.fromCharCodes(codeUnits);
  }

  String generateRandomNumber(int length) {
    var rng = new Random();
    String number = "";
    for (var i = 0; i < length; i++) {
      number += rng.nextInt(10).toString();
    }
    return number;
  }
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//////////////////////////// METHODS SAMPLES ////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//
//db.insertChat(chatId: '3',convId: '0123',userId: 'test2',date: DateTime.now().toString(), content: "Khooobi?");
//    db.selectConversations(onResult: (items){
//      print("ITEMS SELCTION COUNT : ${items.length}");
//    });

//db.insertConversation(convId: '0123',userId: 'test2',createDate: DateTime.now().toString());
//    db.selectConversations(onResult: (items){
//      print("ITEMS SELCTION COUNT : ${items.length}");
//    });

//    db.deleteConversation(convId: "0123",onDeleted: (val){
//      if(val){
//        print("OOOOOK");
//      }else{
//        print("NOOOO OOOOOK");
//      }
//    });
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//////////////////////////// METHODS SAMPLES ////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
