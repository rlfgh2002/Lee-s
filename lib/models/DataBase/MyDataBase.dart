import 'dart:convert';

import 'package:haegisa2/models/Vote/VoteObject.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class _StaticDbInformation
{
  static const String dbName = 'my_db_sina.db';
  static const String tblConversation = 'tblConversations';
  static const String tblVotes = 'tblVotes';
  static const String tblVotesAnswers = 'tblVotesAnswers';
  static const String tblSurveysAnswers = 'tblSurveysAnswers';
  static const String tblChats = 'tblChats';
  static const String tblSurveys = 'tblSurveys';

  static const String tblConversationFieldId = 'convId';
  static const String tblConversationCreateDate = 'createDate';
  static const String tblConversationOtherSideUserId = 'otherSideUserId';
  static const String tblConversationOtherSideUserFromName = 'otherSideUserName';


  static const String tblChatsChatId = 'chatId';
  static const String tblChatsChatDate = 'chatDate';
  static const String tblChatsConvId = 'convId';
  static const String tblChatsContent = 'content';
  static const String tblChatsIsYours = 'isYours';

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
  static const String tblAnswersSurveyTitle = 'title';
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
}

class MyDataBase
{
  SharedPreferences prefs;

  MyDataBase()
  {
    //_deleteDataBase();
    _checkDataBaseIsCreated();
  }

  void _checkDataBaseIsCreated() async
  {
    prefs = await SharedPreferences.getInstance();
    //await prefs.setBool('my_database_iscreated', true);
    bool dbStatus = prefs.getBool('my_database_iscreated');
    print(":::::::::: DB STATUS => [${dbStatus}] ::::::::::");
    if(dbStatus != true){
      _createDataBase();
    }
  }
  void _createDataBase() async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(
        path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute('CREATE TABLE ${_StaticDbInformation.tblConversation} (id INTEGER PRIMARY KEY AUTOINCREMENT ,${_StaticDbInformation.tblConversationFieldId} TEXT,${_StaticDbInformation.tblConversationOtherSideUserId} TEXT,${_StaticDbInformation.tblConversationCreateDate} TEXT, ${_StaticDbInformation.tblConversationOtherSideUserFromName} TEXT)').then((val){
            print(":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblConversation} STATUS => [TRUE] ::::::::::");
          }).catchError((error){
            print(":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
          });

          await db.execute('CREATE TABLE ${_StaticDbInformation.tblChats} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblChatsChatId} TEXT,${_StaticDbInformation.tblChatsConvId} TEXT,${_StaticDbInformation.tblChatsContent} TEXT,${_StaticDbInformation.tblChatsChatDate} TEXT, ${_StaticDbInformation.tblChatsIsYours} TEXT)').then((val){
            print(":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblChats} STATUS => [TRUE] ::::::::::");
          }).catchError((error){
            print(":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
          });

          await db.execute('CREATE TABLE ${_StaticDbInformation.tblVotes} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblVotesContent} TEXT,${_StaticDbInformation.tblVotesFromId} TEXT,${_StaticDbInformation.tblVotesFromName} TEXT,${_StaticDbInformation.tblVotesHttpPath} TEXT, ${_StaticDbInformation.tblVotesIdx} TEXT, ${_StaticDbInformation.tblVotesRegDate} TEXT, ${_StaticDbInformation.tblVotesStartDate} TEXT, ${_StaticDbInformation.tblVotesEndDate} TEXT, ${_StaticDbInformation.tblVotesSubject} TEXT)').then((val){
            print(":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblVotes} STATUS => [TRUE] ::::::::::");
          }).catchError((error){
            print(":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
          });

          await db.execute('CREATE TABLE ${_StaticDbInformation.tblVotesAnswers} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblAnswersVoteIdx} TEXT, ${_StaticDbInformation.tblAnswersVoteDone} TEXT,${_StaticDbInformation.tblAnswersStatus} TEXT,${_StaticDbInformation.tblAnswersAnswer1} TEXT,${_StaticDbInformation.tblAnswersAnswer2} TEXT, ${_StaticDbInformation.tblAnswersAnswer3} TEXT, ${_StaticDbInformation.tblAnswersAnswer4} TEXT, ${_StaticDbInformation.tblAnswersAnswer5} TEXT, ${_StaticDbInformation.tblAnswersAnswer6} TEXT)').then((val){
            print(":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblVotesAnswers} STATUS => [TRUE] ::::::::::");
          }).catchError((error){
            print(":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
          });

          await db.execute('CREATE TABLE ${_StaticDbInformation.tblSurveys} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblSurveysNo} TEXT, ${_StaticDbInformation.tblSurveysDone} TEXT,${_StaticDbInformation.tblSurveysBdIdx} TEXT,${_StaticDbInformation.tblSurveysStartDate} TEXT,${_StaticDbInformation.tblSurveysEndDate} TEXT, ${_StaticDbInformation.tblSurveysSubject} TEXT, ${_StaticDbInformation.tblSurveysContents} TEXT, ${_StaticDbInformation.tblSurveysQcnt} TEXT)').then((val){
            print(":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblSurveys} STATUS => [TRUE] ::::::::::");
          }).catchError((error){
            print(":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
          });

          await db.execute('CREATE TABLE ${_StaticDbInformation.tblSurveysAnswers} (id INTEGER PRIMARY KEY AUTOINCREMENT, ${_StaticDbInformation.tblAnswersSurveyIdx} TEXT, ${_StaticDbInformation.tblAnswersSurveyQN} TEXT,${_StaticDbInformation.tblAnswersSurveyQ1} TEXT,${_StaticDbInformation.tblAnswersSurveyQ2} TEXT,${_StaticDbInformation.tblAnswersSurveyQ3} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ4} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ5} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ6} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ7} TEXT, ${_StaticDbInformation.tblAnswersSurveyQ8} TEXT)').then((val){
            print(":::::::::: DB CREATE TABLE ${_StaticDbInformation.tblSurveysAnswers} STATUS => [TRUE] ::::::::::");
          }).catchError((error){
            print(":::::::::: DB CREATE TABLE ${error.toString()} STATUS => [FALSE] ::::::::::");
          });

          //await db.execute('');
        } // Create DataBase
        ).catchError((er)=>print("Error While Createing Table ${er.toString()}")
    ).then((val){
      prefs.setBool('my_database_iscreated',true);
      print(":::::::::: DB INITIALIZING STATUS => [TRUE] ::::::::::");
      val.close();
    });
  }
  void _deleteDataBase() async
  {
    prefs = await SharedPreferences.getInstance();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    await deleteDatabase(path).then((val){
      prefs.setBool('my_database_iscreated',false);
    });
  }


  void insertConversation({String convId, String userId, String createDate, String fromName, String schoolName, onInserted(), onNoInerted()}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    print(":::::::::: NEW Conversation GENERATING ... ::::::::::");
    await openDatabase(path).then((db){
       db.rawInsert(
          'INSERT INTO ${_StaticDbInformation.tblConversation} (${_StaticDbInformation.tblConversationFieldId},${_StaticDbInformation.tblConversationOtherSideUserId},${_StaticDbInformation.tblConversationCreateDate}, ${_StaticDbInformation.tblConversationOtherSideUserFromName}) VALUES ("${convId.toString()}","${userId.toString()}","${createDate.toString()}","${fromName.toString()}")').catchError((err){
        print(":::::::::: DB INSERT(conversation) ERROR => [${err.toString()}] ::::::::::");
        onNoInerted();
      }).then((val){
        print(":::::::::: DB INSERT(conversation) QUERY => [${val.toString()}] ::::::::::");
        onInserted();
      }).whenComplete((){
        //db.close();
        print(":::::::::: DB CLOSE ::::::::::");
       });
    });
  }
  void selectConversations({onResult(List<Map<String, dynamic>> results)}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      List<Map<String, dynamic>> myList = [];
      db.rawQuery('SELECT * FROM ${_StaticDbInformation.tblConversation}').then((lists){
        for(int i = 0; i < lists.length; i++){
          myList.add(lists[i]);
          print(":::::::::: DB SELECT(conversation) ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        }// for loop
        onResult(myList);
      });
      //db.close();
    });
  }
  void checkConversationExist({onResult(Map<String, dynamic> result), String userId = "", onNoResult()}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      Map<String, dynamic> obj;
      db.rawQuery("SELECT * FROM ${_StaticDbInformation.tblConversation} WHERE ${_StaticDbInformation.tblConversationOtherSideUserId} = '${userId}'").then((lists){
        if(lists.length > 0){
          obj = lists.first;
          print(":::::::::: DB SELECT(conversation) ROW (${0}) => [${lists.first.toString()}] ::::::::::");
          //db.close();
          onResult(obj);
        }else{
          print(":::::::::: DB SELECT(conversation) ROW (${0}) => Not Found Any Items ::::::::::");
          //db.close();
          onNoResult();
        }
      });
    });
  }
  void deleteConversation({String convId = "", onDeleted(bool st)}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){
      db.rawDelete("DELETE FROM ${_StaticDbInformation.tblConversation} WHERE convId = '${convId}'").then((val){
        print(":::::::::: DB DELETE(conversation) ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err){
        print(":::::::::: DB DELETE(conversation) ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void insertChat({String convId, String userId, String date, String content,String isYours = "FALSE", onAdded()}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO ${_StaticDbInformation.tblChats} (${_StaticDbInformation.tblChatsConvId},${_StaticDbInformation.tblChatsContent},${_StaticDbInformation.tblChatsChatDate}, ${_StaticDbInformation.tblChatsIsYours}) VALUES ("${convId.toString()}","${content.toString()}","${date.toString()}","${isYours.toString()}")');
        print(":::::::::: DB INSERT(chat) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      });

    });
  }
  void selectChats({onResult(List<Map<String, dynamic>> results), String convId}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      List<Map<String, dynamic>> myList = [];
      db.rawQuery("SELECT * FROM ${_StaticDbInformation.tblChats} WHERE convId = '${convId}'").then((lists){
        for(int i = 0; i < lists.length; i++){
          myList.add(lists[i]);
          print(":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        }// for loop
        //db.close();
        onResult(myList);
      });
    });
  }
  void deleteChat({String convId = "", onDeleted(bool st)}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){
      db.rawDelete("DELETE FROM ${_StaticDbInformation.tblChats} WHERE convId = '${convId}'").then((val){
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err){
        print(":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void insertSurvey({onAdded(),String no,String isDone,String bd_idx, String start_date, String end_date, String subject, String content, String q_cnt}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO ${_StaticDbInformation.tblSurveys} (${_StaticDbInformation.tblSurveysNo},${_StaticDbInformation.tblSurveysDone},${_StaticDbInformation.tblSurveysBdIdx},${_StaticDbInformation.tblSurveysStartDate}, ${_StaticDbInformation.tblSurveysEndDate}, ${_StaticDbInformation.tblSurveysSubject}, ${_StaticDbInformation.tblSurveysContents}, ${_StaticDbInformation.tblSurveysQcnt}) VALUES ("${no.toString()}","${isDone.toString()}","${bd_idx.toString()}","${start_date.toString()}","${end_date.toString()}","${subject.toString()}","${content.toString()}","${q_cnt.toString()}")');
        print(":::::::::: DB INSERT(survey) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      }).catchError((err){
        print(":::::::::: DB INSERT(survey) QUERY ERROR => [${err.toString()}] ::::::::::");
      });

    });
  }
  void selectSurvey({onResult(List<Map<String, dynamic>> results)}) async
  {
    print(":::::::::: DB SELECTING SURVEY ::::::::::");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      List<Map<String, dynamic>> myList = [];
      db.rawQuery("SELECT * FROM ${_StaticDbInformation.tblSurveys}").then((lists){
        for(int i = 0; i < lists.length; i++){
          myList.add(lists[i]);
          print(":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        }// for loop
        //db.close();
        onResult(myList);
      }).catchError((err){
        print(":::::::::: DB ERROR SELECT SURVEY : ${err.toString()} ::::::::::");
      });
    });
  }
  void deleteSurvey({String no = "", onDeleted(bool st)}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){
      db.rawDelete("DELETE FROM ${_StaticDbInformation.tblSurveys} WHERE no='${no.toString()}'").then((val){
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err){
        print(":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }
  void checkSurveyExist({onResult(Map<String, dynamic> result), String no = "", onNoResult()}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      db.rawQuery("SELECT * FROM ${_StaticDbInformation.tblSurveys} WHERE ${_StaticDbInformation.tblSurveysNo} = '${no.toString()}'").then((lists){
        if(lists.length > 0){
          print(":::::::::: DB SELECT(Survey) ROW (${0}) => [${lists.first.toString()}] ::::::::::");
          //db.close();
          onResult(lists.first);
        }else{
          print(":::::::::: DB SELECT(Survey) ROW (${0}) => Not Found Any Items ::::::::::");
          //db.close();
          onNoResult();
        }
      });

    });
  }

  void insertSurveyAnswer({String idx, String qTitle = "i", String answer1 = "", String answer2 = "", String answer3 = "", String answer4 = "", String answer5 = "", String answer6 = "",String answer7 = "",String answer8 = "", onAdded(),}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO ${_StaticDbInformation.tblSurveysAnswers} (${_StaticDbInformation.tblAnswersSurveyIdx},${_StaticDbInformation.tblAnswersSurveyQN},${_StaticDbInformation.tblAnswersSurveyQ1},${_StaticDbInformation.tblAnswersSurveyQ2}, ${_StaticDbInformation.tblAnswersSurveyQ3}, ${_StaticDbInformation.tblAnswersSurveyQ4}, ${_StaticDbInformation.tblAnswersSurveyQ5}, ${_StaticDbInformation.tblAnswersSurveyQ6}, ${_StaticDbInformation.tblAnswersSurveyQ7}, ${_StaticDbInformation.tblAnswersSurveyQ8}) VALUES ("${idx.toString()}","FALSE","${qTitle.toString()}","${answer1.toString()}","${answer2.toString()}","${answer3.toString()}","${answer4.toString()}","${answer5.toString()}","${answer6.toString()}","${answer7.toString()},"${answer8.toString()}"")');
        print(":::::::::: DB INSERT(answer survey) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      });

    });
  }
  void updateSurveyisDone({String idx, String voteDone = "FALSE" ,onUpdated(),}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'UPDATE ${_StaticDbInformation.tblSurveys} SET ${_StaticDbInformation.tblSurveysDone} = "${voteDone.toString()}" WHERE ${_StaticDbInformation.tblSurveysBdIdx} = "${idx.toString()}"');
        print(":::::::::: DB UPDATE(answer survey) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onUpdated();
      });

    });
  }
  void selectSurveyAnswer({onResult(List<Map<String, dynamic>> results), String idx}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      List<Map<String, dynamic>> myList = [];
      db.rawQuery("SELECT * FROM ${_StaticDbInformation.tblSurveysAnswers} WHERE ${_StaticDbInformation.tblAnswersSurveyIdx} = '${idx}'").then((lists){
        for(int i = 0; i < lists.length; i++){
          myList.add(lists[i]);
          print(":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        }// for loop
        //db.close();
        onResult(myList);
      });
    });
  }
  void deleteSurveyAnswer({String idx = "", onDeleted(bool st)}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){
      db.rawDelete("DELETE FROM ${_StaticDbInformation.tblSurveysAnswers} WHERE ${_StaticDbInformation.tblAnswersSurveyIdx} = '${idx}'").then((val){
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err){
        print(":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  void insertAnswer({String idx, String status = "i", String answer1 = "", String answer2 = "", String answer3 = "", String answer4 = "", String answer5 = "", String answer6 = "", onAdded(),}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO ${_StaticDbInformation.tblVotesAnswers} (${_StaticDbInformation.tblAnswersVoteIdx},${_StaticDbInformation.tblAnswersVoteDone},${_StaticDbInformation.tblAnswersStatus},${_StaticDbInformation.tblAnswersAnswer1}, ${_StaticDbInformation.tblAnswersAnswer2}, ${_StaticDbInformation.tblAnswersAnswer3}, ${_StaticDbInformation.tblAnswersAnswer4}, ${_StaticDbInformation.tblAnswersAnswer5}, ${_StaticDbInformation.tblAnswersAnswer6}) VALUES ("${idx.toString()}","FALSE","${status.toString()}","${answer1.toString()}","${answer2.toString()}","${answer3.toString()}","${answer4.toString()}","${answer5.toString()}","${answer6.toString()}")');
        print(":::::::::: DB INSERT(answer) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      });

    });
  }
  void updateAnswer({String idx, String voteDone = "FALSE" ,onUpdated(),}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'UPDATE ${_StaticDbInformation.tblVotesAnswers} SET ${_StaticDbInformation.tblAnswersVoteDone} = "${voteDone.toString()}" WHERE ${_StaticDbInformation.tblAnswersVoteIdx} = "${idx.toString()}"');
        print(":::::::::: DB UPDATE(answer) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onUpdated();
      });

    });
  }
  void selectAnswer({onResult(List<Map<String, dynamic>> results), String idx}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      List<Map<String, dynamic>> myList = [];
      db.rawQuery("SELECT * FROM ${_StaticDbInformation.tblVotesAnswers} WHERE ${_StaticDbInformation.tblAnswersVoteIdx} = '${idx}'").then((lists){
        for(int i = 0; i < lists.length; i++){
          myList.add(lists[i]);
          print(":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        }// for loop
        //db.close();
        onResult(myList);
      });
    });
  }
  void deleteAnswer({String idx = "", onDeleted(bool st)}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){
      db.rawDelete("DELETE FROM ${_StaticDbInformation.tblVotesAnswers} WHERE ${_StaticDbInformation.tblAnswersVoteIdx} = '${idx}'").then((val){
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err){
        print(":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }


  void insertVote({VoteObject voteItem, onAdded()}) async
  {
    print(":::::::::: INSERTING VOTE ITEM IN DB ::::::::::");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){

      db.transaction((txn) async {
        int id1 = await txn.rawInsert('INSERT INTO ${_StaticDbInformation.tblVotes} (${_StaticDbInformation.tblVotesSubject},${_StaticDbInformation.tblVotesStartDate},${_StaticDbInformation.tblVotesEndDate},${_StaticDbInformation.tblVotesRegDate}, ${_StaticDbInformation.tblVotesIdx}, ${_StaticDbInformation.tblVotesHttpPath}, ${_StaticDbInformation.tblVotesFromName}, ${_StaticDbInformation.tblVotesFromId}, ${_StaticDbInformation.tblVotesContent}) VALUES ("${voteItem.subject.toString()}","${voteItem.startDate.toString()}","${voteItem.endDate.toString()}","${voteItem.regDate.toString()}","${voteItem.idx.toString()}","${voteItem.httpPath.toString()}","${voteItem.fromName.toString()}","${voteItem.fromId.toString()}","${voteItem.content.toString()}")');
        print(":::::::::: DB INSERT(vote) QUERY => [${id1.toString()}] ::::::::::");
        //db.close();
        onAdded();
      }).catchError((error){
        print(":::::::::: DB INSERT(vote) ERROR => [${error.toString()}] ::::::::::");
      });

    });
  }
  void selectVotes({onResult(List<VoteObject> results)}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);

    await openDatabase(path).then((db){
      List<VoteObject> myList = [];
      db.rawQuery("SELECT * FROM ${_StaticDbInformation.tblVotes}").then((lists){
        for(int i = 0; i < lists.length; i++){
          var jso = {'data':lists[i]};
          myList.add(VoteObject.fromJson(jso));
          print(":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        }// for loop
        //db.close();
        onResult(myList);
      }).catchError((err){
        print("::::::::::: [ ERROR DB VOTE : ${err.toString()}] :::::::::::");
      });
    });
  }
  void deleteVote({int voteId = 0, onDeleted(bool st)}) async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _StaticDbInformation.dbName);
    // open the database
    await openDatabase(path).then((db){
      db.rawDelete("DELETE FROM ${_StaticDbInformation.tblVotes} WHERE id = '${voteId}'").then((val){
        print(":::::::::: DB DELETE ROW => [${val}] ::::::::::");
        onDeleted(true);
        //db.close();
      }).catchError((err){
        print(":::::::::: DB DELETE ROW ERROR => [${err.toString()}] ::::::::::");
        onDeleted(false);
        //db.close();
      });
    });
  }

  String generateRandomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(
        length,
            (index){
          return rand.nextInt(33)+89;
        }
    );

    return new String.fromCharCodes(codeUnits);
  }
  String generateRandomNumber(int length){
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