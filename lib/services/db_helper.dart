import 'dart:async';
import 'package:mytat/model/AssesmentQuestionsModel.dart';
import 'package:mytat/model/AssessmentAllLanguagesListModel.dart';
import 'package:mytat/model/AssessorDocumentsModel.dart';
import 'package:mytat/model/CandidateExamTimeModel.dart';
import 'package:mytat/model/CandidateModel.dart';
import 'package:mytat/model/CandidateSubmitDocumentsModel.dart';
import 'package:mytat/model/FeedbackAnswersModel.dart';
import 'package:mytat/model/FeedbackFormQuestionsListModel.dart';
import 'package:mytat/model/QuestStepsListModel.dart';
import 'package:mytat/model/QuestionStepMarkingAnswerModel.dart';
import 'package:mytat/model/ReferenceLanguageTableModel.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorAnnexureListUploadModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateMCQAnswersModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateMcqSyncingVerificationModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateScreenshotUploadModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateVivaSyncingVerificationModel.dart';
import 'package:mytat/model/VivaPracticalMarkingModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Syncing-Models/AssessorQuestionAnswerReplyModel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'assessment.db');
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // Create tables for each data model.
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MQuestions (
        id TEXT PRIMARY KEY,
        questime TEXT,
        masterqid TEXT,
        title TEXT,
        titleImg TEXT,
        marks TEXT,
        option1 TEXT,
        option1Img TEXT,
        option2 TEXT,
        option2Img TEXT,
        option3 TEXT,
        option3Img TEXT,
        option4 TEXT,
        option4Img TEXT,
        assmentId TEXT,
        option5 TEXT,
        option5Img TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS VQuestions (
        id TEXT PRIMARY KEY,
        questime TEXT,
        masterqid TEXT,
        title TEXT,
        titleImg TEXT,
        marks TEXT,
        option1 TEXT,
        option1Img TEXT,
        option2 TEXT,
        option2Img TEXT,
        option3 TEXT,
        option3Img TEXT,
        option4 TEXT,
        option4Img TEXT,
        assmentId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS PQuestions (
        id TEXT PRIMARY KEY,
        questime TEXT,
        masterqid TEXT,
        title TEXT,
        titleImg TEXT,
        marks TEXT,
        option1 TEXT,
        option1Img TEXT,
        option2 TEXT,
        option2Img TEXT,
        option3 TEXT,
        option3Img TEXT,
        option4 TEXT,
        option4Img TEXT,
        assmentId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Batch (
        id TEXT PRIMARY KEY,
        assmentId TEXT,
        name TEXT,
        userEmail TEXT,
        enrollmentNo TEXT,
        password TEXT,
        institutionID TEXT,
        T TEXT,
        P TEXT,
        V TEXT,
        P_img,
        V_img
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Candidate (
        candidateId TEXT PRIMARY KEY,
        candidateAadharFront TEXT,
        candidateAadharBack TEXT,
        candidateProfile TEXT,
        assessorId,
        latitude,
        longitude,
        type
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS CandidatesVivaAnswers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        videoUrl TEXT,
        assessorId TEXT,
        assesmentId INTEGER,
        marksTitle TEXT,
        questionId TEXT,
        lat TEXT,
        long TEXT,
        studentId TEXT,
        assesorMarks TEXT,
        timeTaken TEXT,
        pStartTime TEXT,
        pEndTime TEXT,
        pDate TEXT,
        vStartTime TEXT,
        vEndTime TEXT,
        vDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS CandidatesPracticleAnswers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        videoUrl TEXT,
        assessorId TEXT,
        assesmentId INTEGER,
        marksTitle TEXT,
        questionId TEXT,
        lat TEXT,
        long TEXT,
        studentId TEXT,
        assesorMarks TEXT,
        timeTaken TEXT,
        pStartTime TEXT,
        pEndTime TEXT,
        pDate TEXT,
        vStartTime TEXT,
        vEndTime TEXT,
        vDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE AnnexureDocumentsList (
        id TEXT PRIMARY KEY,
        name TEXT,
        image TEXT
      )
    ''');

    db.execute('''
          CREATE TABLE AnnexureDocumentsDataList (
            image TEXT PRIMARY KEY,
            id TEXT,
            name TEXT,
            lat TEXT,
            long TEXT,
            time TEXT
          )
        ''');

    await db.execute(
      '''
          CREATE TABLE DurationData(
            assmentId TEXT PRIMARY KEY,
            testDuration TEXT,
            imgInterval TEXT,
            assmentName TEXT,
            webProctoring TEXT,
            mandatoryQuestion TEXT,
            randomQuestions TEXT,
            tabSwitchesAllowed TEXT,
            numberTabSwitchesAllowed TEXT,
            vernacularLanguage TEXT,
            moveForward TEXT,
            appoint_time TEXT,
            appointed_time_duration TEXT,
            tensorflow TEXT,
            access_location TEXT,
            screenshare TEXT
          )
          ''',
    );

    await db.execute('''
          CREATE TABLE CandidatesMcqAnswers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            questionId TEXT,
            answerId TEXT,
            candidateId TEXT,
            markForReview INTEGER,
            assessmentId TEXT,
            answerTime TEXT
          )
        ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS CompletedMcqStudents (
        id TEXT PRIMARY KEY,
        assmentId TEXT,
        name TEXT,
        userEmail TEXT,
        enrollmentNo TEXT,
        password TEXT,
        institutionID TEXT,
        T TEXT,
        P TEXT,
        V TEXT,
        P_img,
        V_img
      )
    ''');

    await db.execute('''
          CREATE TABLE CandidateScreenshots (
            serialnumber INTEGER PRIMARY KEY AUTOINCREMENT,
            assmentId TEXT,
            userId TEXT,
            faceCount TEXT,
            userimg TEXT,
            dateTime TEXT
          )
        ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS CandidateDocumentsList (
        candidateId TEXT PRIMARY KEY,
        candidateAadharFront TEXT,
        candidateAadharBack TEXT,
        candidateProfile TEXT,
        latitude TEXT,
        longitude TEXT,
        type TEXT
      )
    ''');

    await db.execute(
      '''
          CREATE TABLE McqVerificationTable(
            candidateIds TEXT PRIMARY KEY,
            isDocumentsSynced TEXT,
            isScreenshotsSynced TEXT,
            isAnswersSynced TEXT
          )
          ''',
    );

    await db.execute('''
          CREATE TABLE VivaSyncingVerification (
            candidateIds TEXT PRIMARY KEY,
            isDocumentsSynced TEXT,
            isPracticalSynced TEXT,
            isVivaSynced TEXT
          )
        ''');

    await db.execute('''
      CREATE TABLE AssessmentAvailableLanguages (
        id TEXT PRIMARY KEY,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE McqLanguageReferanceTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        langId TEXT,
        question_id TEXT,
        option1 TEXT,
        option1Img TEXT,
        option2 TEXT,
        option2Img TEXT,
        option3 TEXT,
        option3Img TEXT,
        option4 TEXT,
        option4Img TEXT
      )
    ''');

    await db.execute('''CREATE TABLE VivaPracticalMarksTable (
      title TEXT PRIMARY KEY,
      marks TEXT
    )''');

    await db.execute('''
          CREATE TABLE FeedbackFormQuestionsTable (
            bfq_id TEXT PRIMARY KEY,
            title TEXT
          )
        ''');

    await db.execute('''
      CREATE TABLE CandidateFeedbackAnswersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questionId TEXT,
        answer TEXT,
        candidateId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ExamTimeTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        start_time TEXT,
        end_time TEXT,
        user_id TEXT,
        tab_switch TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE QuestionStepsTable (
        step_id TEXT PRIMARY KEY,
        assess_id TEXT,
        question_id TEXT,
        s_title TEXT,
        s_mark TEXT
      )
    ''');

    await db.execute('''
          CREATE TABLE QuestionStepMarkingAnswerTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            step_id TEXT,
            assess_id TEXT,
            question_id TEXT,
            s_title TEXT,
            s_mark TEXT,
            marking_title TEXT,
            candidateId TEXT,
            answerType TEXT
          )
        ''');
  }

  // Create operation
  Future<int> insertMQuestion(MQuestions question) async {
    var dbClient = await db;
    return await dbClient!.insert('MQuestions', question.toJson());
  }

  Future<int> insertVQuestion(VQuestions question) async {
    var dbClient = await db;
    return await dbClient!.insert('VQuestions', question.toJson());
  }

  Future<int> insertPQuestion(PQuestions question) async {
    var dbClient = await db;
    return await dbClient!.insert('PQuestions', question.toJson());
  }

  // Read operations
  Future<List<MQuestions>> getMQuestions() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('MQuestions');
    return List.generate(maps.length, (i) => MQuestions.fromJson(maps[i]));
  }

  Future<List<VQuestions>> getVQuestions() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('VQuestions');
    return List.generate(maps.length, (i) => VQuestions.fromJson(maps[i]));
  }

  Future<List<PQuestions>> getPQuestions() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('PQuestions');
    return List.generate(maps.length, (i) => PQuestions.fromJson(maps[i]));
  }

  // Update operation
  Future<int> updateMQuestion(MQuestions question) async {
    var dbClient = await db;
    return await dbClient!.update(
      'MQuestions',
      question.toJson(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  Future<int> updateVQuestion(VQuestions question) async {
    var dbClient = await db;
    return await dbClient!.update(
      'VQuestions',
      question.toJson(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  Future<int> updatePQuestion(PQuestions question) async {
    var dbClient = await db;
    return await dbClient!.update(
      'PQuestions',
      question.toJson(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  // Delete operation
  Future<int> deleteMQuestion(String id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'MQuestions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteVQuestion(String id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'VQuestions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePQuestion(String id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'PQuestions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future close() async {
    var dbClient = await db;
    return dbClient!.close();
  }

// Clear the database
  Future<void> clearDatabase() async {
    var dbClient = await db;

    // Delete all records from the MQuestions table
    await dbClient!.delete('MQuestions');

    // Delete all records from the VQuestions table
    await dbClient.delete('VQuestions');

    // Delete all records from the PQuestions table
    await dbClient.delete('PQuestions');

    // Delete all records from the Batch table
    await dbClient.delete('Batch');

    // Delete all records from the Candidate table
    await dbClient.delete('Candidate');

    // Delete all records from the CandidatesVivaAnswers table
    await dbClient.delete('CandidatesVivaAnswers');

    // Delete all records from the CandidatesPracticleAnswers table
    await dbClient.delete('CandidatesPracticleAnswers');

    // Delete all records from the AnnexureDocumentsList table
    await dbClient.delete('AnnexureDocumentsList');

    // Delete all records from the DurationData table
    await dbClient.delete('DurationData');

    // Delete all records from the CandidatesMcqAnswers table
    await dbClient.delete('CandidatesMcqAnswers');

    // Delete all records from the CompletedMcqStudents table
    await dbClient.delete('CompletedMcqStudents');

    // Delete all records from the CandidateDocumentsList table
    await dbClient.delete('CandidateDocumentsList');

    // Delete all records from the CandidateScreenshots table
    await dbClient.delete('CandidateScreenshots');

    // Delete all records from the McqVerificationTable table
    await dbClient.delete('McqVerificationTable');

    // Delete all records from the AnnexureDocumentsDataList table
    await dbClient.delete('AnnexureDocumentsDataList');

    // Delete all records from the VivaSyncingVerification table
    await dbClient.delete('VivaSyncingVerification');

    // Delete all records from the AssessmentAvailableLanguages table
    await dbClient.delete('AssessmentAvailableLanguages');

    // Delete all records from the McqLanguageReferanceTable table
    await dbClient.delete('McqLanguageReferanceTable');

    // Delete all records from the VivaPracticalMarksTable table
    await dbClient.delete('VivaPracticalMarksTable');

    // Delete all records from the FeedbackFormQuestionsTable table
    await dbClient.delete('FeedbackFormQuestionsTable');

    // Delete all records from the CandidateFeedbackAnswersTable table
    await dbClient.delete('CandidateFeedbackAnswersTable');

    // Delete all records from the ExamTimeTable table
    await dbClient.delete('ExamTimeTable');

    // Delete all records from the QuestionStepsTable table
    await dbClient.delete('QuestionStepsTable');

    // Delete all records from the QuestionStepMarkingAnswerTable table
    await dbClient.delete('QuestionStepMarkingAnswerTable');
  }

// clear batch database local data
  Future<void> refreshDatabase() async {
    var dbClient = await db;

    // Delete all records from the Batch table
    await dbClient!.delete('Batch');

    // Delete all records from the PQuestions table
    await dbClient.delete('PQuestions');

    // Delete all records from the VQuestions table
    await dbClient.delete('VQuestions');

    // Delete all records from the VivaPracticalMarksTable table
    await dbClient.delete('VivaPracticalMarksTable');

    // Delete all records from the QuestionStepsTable table
    await dbClient.delete('QuestionStepsTable');
  }

  Future<void> refreshAssessorDatabase() async {
    var dbClient = await db;

    // Delete all records from the AnnexureDocumentsList table
    await dbClient!.delete('AnnexureDocumentsList');
  }

  // CODE FOR INSERTING THE DATA
  // Insert PQuestions
  Future<void> insertPQuestions(List<PQuestions> questions) async {
    var dbClient = await db;
    for (var question in questions) {
      await dbClient!.insert('PQuestions', question.toJson());
    }
  }

  // Insert MQuestions
  Future<void> insertMQuestions(List<MQuestions> questions) async {
    var dbClient = await db;
    for (var question in questions) {
      await dbClient!.insert('MQuestions', question.toJson());
    }
  }

  // Insert VQuestions
  Future<void> insertVQuestions(List<VQuestions> questions) async {
    var dbClient = await db;
    for (var question in questions) {
      await dbClient!.insert('VQuestions', question.toJson());
    }
  }

  // CRUD operations for Batch table
  Future<void> insertBatchList(List<Batches> batchList) async {
    var dbClient = await db;
    for (var batch in batchList) {
      await dbClient!.insert('Batch', batch.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Batches>> getBatchList() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('Batch');
    return List.generate(maps.length, (i) => Batches.fromJson(maps[i]));
  }

  Future<void> updateBatch(Batches batch) async {
    var dbClient = await db;
    await dbClient!.update(
      'Batch',
      batch.toJson(),
      where: 'id = ?',
      whereArgs: [batch.id],
    );
  }

  Future<void> deleteBatch(int id) async {
    var dbClient = await db;
    await dbClient!.delete(
      'Batch',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Batches?> getCandidateDetailsFromDb(
      String institutionID, String enrollmentNo, String password) async {
    var dbClient = await db;

    // Execute the query and retrieve the candidate ID.
    List<Map<String, dynamic>> result = await dbClient!.rawQuery('''
    SELECT id, assmentId, name, userEmail, password, institutionID FROM Batch
    WHERE institutionID = ? AND enrollmentNo = ? AND password = ?
  ''', [institutionID, enrollmentNo, password]);

    print("Printing Result ======> $result");

    // Check if there is a match, and return the candidate ID.
    if (result.isNotEmpty) {
      Batches currentStudent = Batches.fromJson(result[0]);
      return currentStudent;
    }

    // Return null if no match is found.
    return null;
  }

  // CRUD operations for Candidate table
  Future<int> insertCandidate(CandidateModel candidate) async {
    var dbClient = await db;
    // Check if the candidate ID already exists in the database
    List<Map<String, dynamic>> candidateData = await dbClient!.query(
      'Candidate',
      where: 'candidateId = ?',
      whereArgs: [candidate.candidateId],
    );
    if (candidateData.isNotEmpty) {
      return 0;
    } else {
      return await dbClient.insert('Candidate', candidate.toJson());
    }
  }

  // Duplicate Entries Working code -->

  Future<List<CandidateModel>> getCandidates() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('Candidate');
    return List.generate(maps.length, (i) => CandidateModel.fromJson(maps[i]));
  }

  Future<int> updateCandidate(CandidateModel candidate) async {
    var dbClient = await db;
    return await dbClient!.update(
      'Candidate',
      candidate.toJson(),
      where: 'candidateId = ?',
      whereArgs: [candidate.candidateId],
    );
  }

  Future<int> deleteCandidate(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'Candidate',
      where: 'candidateId = ?',
      whereArgs: [id],
    );
  }

  // question answers for viva response storing CURD operations

  Future<int> insertCandidatesVivaAnswersReply(
      AssessorQuestionAnswersReplyModel model) async {
    var dbClient = await db;
    return await dbClient!.insert('CandidatesVivaAnswers', model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AssessorQuestionAnswersReplyModel>>
      getCandidatesVivaAnswers() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query('CandidatesVivaAnswers');
    return List.generate(maps.length, (i) {
      return AssessorQuestionAnswersReplyModel(
          assesmentId: maps[i]['assesmentId'],
          assesorMarks: maps[i]['assesorMarks'],
          assessorId: maps[i]['assessorId'],
          lat: maps[i]['lat'],
          long: maps[i]['long'],
          marksTitle: maps[i]['marksTitle'],
          pDate: maps[i]['pDate'],
          pEndTime: maps[i]['pEndTime'],
          pStartTime: maps[i]['pStartTime'],
          questionId: maps[i]['questionId'],
          studentId: maps[i]['studentId'],
          timeTaken: maps[i]['timeTaken'],
          vDate: maps[i]['vDate'],
          vEndTime: maps[i]['vEndTime'],
          vStartTime: maps[i]['vStartTime'],
          videoUrl: maps[i]['videoUrl']);
      // return AssessorQuestionAnswersReplyModel.fromJson(maps[i]);
    });
  }

  Future<int> updateCandidateVivaAnswers(
      AssessorQuestionAnswersReplyModel model) async {
    var dbClient = await db;

    return await dbClient!.update('CandidatesVivaAnswers', model.toJson(),
        where: 'videoUrl = ?', whereArgs: [model.videoUrl]);
  }

  Future<int> deleteCandidateVivaAnswer(String videoUrl) async {
    var dbClient = await db;

    return await dbClient!.delete('CandidatesVivaAnswers',
        where: 'videoUrl = ?', whereArgs: [videoUrl]);
  }

  // question answers for viva response storing CURD operations

  Future<int> insertCandidatesPracticleAnswersReply(
      AssessorQuestionAnswersReplyModel model) async {
    var dbClient = await db;
    return await dbClient!.insert('CandidatesPracticleAnswers', model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AssessorQuestionAnswersReplyModel>>
      getCandidatesPracticleAnswers() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query('CandidatesPracticleAnswers');
    return List.generate(maps.length, (i) {
      return AssessorQuestionAnswersReplyModel(
          assesmentId: maps[i]['assesmentId'],
          assesorMarks: maps[i]['assesorMarks'],
          assessorId: maps[i]['assessorId'],
          lat: maps[i]['lat'],
          long: maps[i]['long'],
          marksTitle: maps[i]['marksTitle'],
          pDate: maps[i]['pDate'],
          pEndTime: maps[i]['pEndTime'],
          pStartTime: maps[i]['pStartTime'],
          questionId: maps[i]['questionId'],
          studentId: maps[i]['studentId'],
          timeTaken: maps[i]['timeTaken'],
          vDate: maps[i]['vDate'],
          vEndTime: maps[i]['vEndTime'],
          vStartTime: maps[i]['vStartTime'],
          videoUrl: maps[i]['videoUrl']);
      // AssessorQuestionAnswersReplyModel.fromJson(maps[i]);
    });
  }

  Future<int> updateCandidatePracticleAnswers(
      AssessorQuestionAnswersReplyModel model) async {
    var dbClient = await db;

    return await dbClient!.update('CandidatesPracticleAnswers', model.toJson(),
        where: 'videoUrl = ?', whereArgs: [model.videoUrl]);
  }

  Future<int> deleteCandidatePracticleAnswer(String videoUrl) async {
    var dbClient = await db;

    return await dbClient!.delete('CandidatesPracticleAnswers',
        where: 'videoUrl = ?', whereArgs: [videoUrl]);
  }

// CRUD Operations for Annexurelist
  Future<int> insertAnnexureDocumentsList(Annexurelist annexurelist) async {
    var dbClient = await db;
    return await dbClient!
        .insert('AnnexureDocumentsList', annexurelist.toJson());
  }

  Future<List<Annexurelist>> getAllAnnexureDocumentsList() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient!.query('AnnexureDocumentsList');
    return List.generate(maps.length, (i) {
      return Annexurelist.fromJson(maps[i]);
    });
  }

  Future<int> updateAnnexureDocumentsList(Annexurelist annexurelist) async {
    var dbClient = await db;
    return await dbClient!.update(
      'AnnexureDocumentsList',
      annexurelist.toJson(),
      where: 'id = ?',
      whereArgs: [annexurelist.id],
    );
  }

  Future<int> deleteAnnexureDocumentsList(String id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'AnnexureDocumentsList',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Duration table
  Future<void> insertDuration(DurationModel durationData) async {
    var dbClient = await db;

    await dbClient!.insert(
      'DurationData',
      durationData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<dynamic> getDuration(String assmentId) async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient!.query(
      'DurationData',
      where: 'assmentId = ?',
      whereArgs: [assmentId],
    );

    if (maps.isNotEmpty) {
      return DurationModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateDuration(DurationModel durationData) async {
    var dbClient = await db;

    await dbClient!.update(
      'DurationData',
      durationData.toJson(),
      where: 'assmentId = ?',
      whereArgs: [durationData.assmentId],
    );
  }

  Future<void> deleteDuration(int assmentId) async {
    var dbClient = await db;

    await dbClient!.delete(
      'DurationData',
      where: 'assmentId = ?',
      whereArgs: [assmentId],
    );
  }

  // mcq candidates answers CURD
  Future<int> insertMcqAnswers(McqAnswers answer) async {
    var dbClient = await db;
    return await dbClient!.insert('CandidatesMcqAnswers', answer.toJson());
  }

  Future<List<McqAnswers>> getAllCandidatesMcqAnswers() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient!.query('CandidatesMcqAnswers');
    return List.generate(maps.length, (i) {
      return McqAnswers(
        id: maps[i]['id'],
        questionId: maps[i]['questionId'],
        answerId: maps[i]['answerId'],
        candidateId: maps[i]['candidateId'],
        markForReview: maps[i]['markForReview'],
        assessmentId: maps[i]['assessmentId'],
        answerTime: maps[i]['answerTime'],
      );
    });
  }

  Future<int> updateMcqAnswers(McqAnswers answer) async {
    var dbClient = await db;
    return await dbClient!.update(
      'CandidatesMcqAnswers',
      answer.toJson(),
      where: 'id = ?',
      whereArgs: [answer.id],
    );
  }

  Future<int> deleteMcqAnswers(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'CandidatesMcqAnswers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// completed mcq students data
  Future<void> insertCompletedMcqStudent(Batches student) async {
    print("Printing Data: ${student.toJson()}");
    var dbClient = await db;
    await dbClient!.insert('CompletedMcqStudents', student.toJson());
  }

  Future<List<Batches>> getAllCompletedMcqStudents() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient!.query('CompletedMcqStudents');
    return List.generate(maps.length, (i) {
      return Batches.fromJson(maps[i]);
    });
  }

  Future<void> updateCompletedMcqStudent(Batches student) async {
    var dbClient = await db;
    await dbClient!.update(
      'CompletedMcqStudents',
      student.toJson(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<void> deleteCompletedMcqStudent(String id) async {
    var dbClient = await db;
    await dbClient!.delete(
      'CompletedMcqStudents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // curd operatoins for storing the mcq candidate screenshots
  Future<int> insertCandidateScreenshot(
      CandidateScreenshotUploadModel screenshot) async {
    var dbClient = await db;
    return await dbClient!.insert('CandidateScreenshots', screenshot.toJson());
  }

  Future<List<CandidateScreenshotUploadModel>> getCandidateScreenshots() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query('CandidateScreenshots');

    return List.generate(maps.length, (i) {
      return CandidateScreenshotUploadModel(
          assmentId: maps[i]['assmentId'],
          userId: maps[i]['userId'],
          faceCount: maps[i]['faceCount'],
          userimg: maps[i]['userimg'],
          serialnumber: maps[i]['serialnumber'],
          dateTime: maps[i]['dateTime']);
    });
  }

  Future<int> updateCandidateScreenshot(
      CandidateScreenshotUploadModel candidate) async {
    var dbClient = await db;

    return await dbClient!.update(
      'CandidateScreenshots',
      candidate.toJson(),
      where: 'serialnumber = ?',
      whereArgs: [candidate.serialnumber],
    );
  }

  Future<int> deleteCandidateScreenshot(int serialnumber) async {
    var dbClient = await db;

    return await dbClient!.delete(
      'CandidateScreenshots',
      where: 'serialnumber = ?',
      whereArgs: [serialnumber],
    );
  }

  // curd opertaions for the candidate submitted documents table
  Future<int> insertCandidateSubmittedDocuments(
      CandidateSubmitDocumentsModel candidate) async {
    var dbClient = await db;
    // Check if the candidate ID already exists in the database
    List<Map<String, dynamic>> candidateData = await dbClient!.query(
      'CandidateDocumentsList',
      where: 'candidateId = ?',
      whereArgs: [candidate.candidateId],
    );
    if (candidateData.isNotEmpty) {
      return 0;
    } else {
      return await dbClient.insert(
          'CandidateDocumentsList', candidate.toJson());
    }
  }

  // Duplicate Entries Working code -->

  Future<List<CandidateSubmitDocumentsModel>>
      getCandidatesSubmittedDocuments() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient!.query('CandidateDocumentsList');
    return List.generate(
        maps.length, (i) => CandidateSubmitDocumentsModel.fromJson(maps[i]));
  }

  Future<int> updateCandidateSubmittedDocuments(
      CandidateSubmitDocumentsModel candidate) async {
    var dbClient = await db;
    return await dbClient!.update(
      'CandidateDocumentsList',
      candidate.toJson(),
      where: 'candidateId = ?',
      whereArgs: [candidate.candidateId],
    );
  }

  Future<int> deleteCandidateSubmittedDocuments(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'CandidateDocumentsList',
      where: 'candidateId = ?',
      whereArgs: [id],
    );
  }

  // CURD Operatoins for the Successfully Synced MCQ data
  Future<int> insertMcqVerification(
      McqSyncingVerificationModel mcqVerification) async {
    var dbClient = await db;

    return await dbClient!.insert(
      'McqVerificationTable',
      mcqVerification.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<McqSyncingVerificationModel>> getMcqVerifications() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query('McqVerificationTable');
    return List.generate(maps.length, (i) {
      return McqSyncingVerificationModel(
        candidateIds: maps[i]['candidateIds'],
        isDocumentsSynced: maps[i]['isDocumentsSynced'],
        isScreenshotsSynced: maps[i]['isScreenshotsSynced'],
        isAnswersSynced: maps[i]['isAnswersSynced'],
      );
    });
  }

  Future<int> updateMcqVerification(
      McqSyncingVerificationModel mcqVerification) async {
    var dbClient = await db;

    return await dbClient!.update(
      'McqVerificationTable',
      mcqVerification.toJson(),
      where: 'candidateIds = ?',
      whereArgs: [mcqVerification.candidateIds],
    );
  }

  Future<int> deleteMcqVerification(String candidateIds) async {
    var dbClient = await db;

    return await dbClient!.delete(
      'McqVerificationTable',
      where: 'candidateIds = ?',
      whereArgs: [candidateIds],
    );
  }

  // CURD Operations for Storing the data of Annexure Documents List
  Future<void> insertAnnexureDocumentDatas(
      AssessorAnnexurelistUploadModel annexure) async {
    var dbClient = await db;

    await dbClient!.insert(
      'AnnexureDocumentsDataList',
      annexure.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AssessorAnnexurelistUploadModel>>
      getAllAnnexureDocumentsData() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query('AnnexureDocumentsDataList');
    return List.generate(maps.length, (i) {
      return AssessorAnnexurelistUploadModel.fromJson(maps[i]);
    });
  }

  Future<void> updateAnnexureDocumentData(
      AssessorAnnexurelistUploadModel annexure) async {
    var dbClient = await db;

    await dbClient!.update(
      'AnnexureDocumentsDataList',
      annexure.toJson(),
      where: 'image = ?',
      whereArgs: [annexure.image],
    );
  }

  Future<void> deleteAnnexureDocumentData(String image) async {
    var dbClient = await db;

    await dbClient!.delete(
      'AnnexureDocumentsDataList',
      where: 'image = ?',
      whereArgs: [image],
    );
  }

  // CURD Operatoins for storing the synced viva and practical status

  Future<void> insertVivaSyncingVerification(
      VivaSyncingVerificationModel model) async {
    var dbClient = await db;

    await dbClient!.insert(
      'VivaSyncingVerification',
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<VivaSyncingVerificationModel>>
      getVivaSyncingVerifications() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query('VivaSyncingVerification');

    return List.generate(maps.length, (index) {
      return VivaSyncingVerificationModel.fromJson(maps[index]);
    });
  }

  Future<void> updateVivaSyncingVerification(
      VivaSyncingVerificationModel model) async {
    var dbClient = await db;

    await dbClient!.update(
      'VivaSyncingVerification',
      model.toJson(),
      where: 'candidateIds = ?',
      whereArgs: [model.candidateIds],
    );
  }

  Future<void> deleteVivaSyncingVerification(String candidateIds) async {
    var dbClient = await db;

    await dbClient!.delete(
      'VivaSyncingVerification',
      where: 'candidateIds = ?',
      whereArgs: [candidateIds],
    );
  }

  // curd opertaions for the mcq language model
  Future<void> insertMcqLanguage(
      AssessmentAvailableLanguageModel language) async {
    var dbClient = await db;

    await dbClient!.insert(
      'AssessmentAvailableLanguages',
      language.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AssessmentAvailableLanguageModel>> getAllMcqLanguages() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query('AssessmentAvailableLanguages');
    return List.generate(maps.length, (index) {
      return AssessmentAvailableLanguageModel.fromJson(maps[index]);
    });
  }

  Future<void> updateMcqLanguage(
      AssessmentAvailableLanguageModel language) async {
    var dbClient = await db;

    await dbClient!.update(
      'AssessmentAvailableLanguages',
      language.toJson(),
      where: 'id = ?',
      whereArgs: [language.id],
    );
  }

  Future<void> deleteMcqLanguage(String languageId) async {
    var dbClient = await db;

    await dbClient!.delete(
      'AssessmentAvailableLanguages',
      where: 'id = ?',
      whereArgs: [languageId],
    );
  }

  // curd opertions for the mcqreferencelanguage table
  Future<void> insertMcqLanguageQuestion(
      MCQuestionsLanguageQuestion question) async {
    var dbClient = await db;

    await dbClient!.insert(
      'McqLanguageReferanceTable',
      question.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MCQuestionsLanguageQuestion>> getAllMcqLanguageQuestions() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> maps =
        await dbClient!.query('McqLanguageReferanceTable');
    return List.generate(maps.length, (index) {
      return MCQuestionsLanguageQuestion.fromJson(maps[index]);
    });
  }

  // Future<void> updateMcqLanguageQuestion(
  //     MCQuestionsLanguageQuestion question) async {
  //   var dbClient = await db;

  //   await dbClient!.update(
  //     'McqLanguageReferanceTable',
  //     question.toJson(),
  //     where: 'langId = ?',
  //     whereArgs: [question.questionId],
  //   );
  // }

  // Future<void> deleteMcqLanguageQuestion(String questionId) async {
  //   var dbClient = await db;

  //   await dbClient!.delete(
  //     'McqLanguageReferanceTable',
  //     where: 'langId = ?',
  //     whereArgs: [questionId],
  //   );
  // }

  // curd opertions for the VivaPracticalMarksTable table

  Future<int> insertVivaPracticalMarking(
      VivaPracticalMarkingModel model) async {
    Database? dbClient = await db;
    return await dbClient!.insert('VivaPracticalMarksTable', model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<VivaPracticalMarkingModel>> getAllVivaPracticalMarkings() async {
    Database? dbClient = await db;
    List<Map<String, dynamic>> result =
        await dbClient!.query('VivaPracticalMarksTable');
    return result
        .map((data) => VivaPracticalMarkingModel.fromJson(data))
        .toList();
  }

  Future<int> updateVivaPracticalMarking(
      VivaPracticalMarkingModel model) async {
    Database? dbClient = await db;
    return await dbClient!.update(
      'VivaPracticalMarksTable',
      model.toJson(),
      where: 'title = ?',
      whereArgs: [model.title],
    );
  }

  Future<int> deleteVivaPracticalMarking(String title) async {
    Database? dbClient = await db;
    return await dbClient!.delete(
      'VivaPracticalMarksTable',
      where: 'title = ?',
      whereArgs: [title],
    );
  }

// curd operations for the FeedbackFormQuestionsTable
  Future<void> insertFeedbackQuestions(
      List<FeedbackQuestionModel> questions) async {
    for (var question in questions) {
      _db!.insert('FeedbackFormQuestionsTable', question.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<FeedbackQuestionModel>> getFeedbackQuestions() async {
    final List<Map<String, dynamic>> maps =
        await _db!.query('FeedbackFormQuestionsTable');

    return List.generate(maps.length, (i) {
      return FeedbackQuestionModel.fromJson(maps[i]);
    });
  }

  Future<void> updateFeedbackQuestion(FeedbackQuestionModel question) async {
    await _db!.update(
      'FeedbackFormQuestionsTable',
      question.toJson(),
      where: 'bfq_id = ?',
      whereArgs: [question.bfqId],
    );
  }

  Future<void> deleteFeedbackQuestion(String bfqId) async {
    await _db!.delete(
      'FeedbackFormQuestionsTable',
      where: 'bfq_id = ?',
      whereArgs: [bfqId],
    );
  }

// curd operations for the CandidateFeedbackAnswersTable
  Future<void> insertFeedbackAnswer(FeedbackAnswersModel feedbackAnswer) async {
    await _db!.insert(
      'CandidateFeedbackAnswersTable',
      feedbackAnswer.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FeedbackAnswersModel>> getAllFeedbackAnswers() async {
    final List<Map<String, dynamic>> maps =
        await _db!.query('CandidateFeedbackAnswersTable');

    return List.generate(maps.length, (i) {
      return FeedbackAnswersModel.fromJson(maps[i]);
    });
  }

  Future<void> updateFeedbackAnswer(FeedbackAnswersModel feedbackAnswer) async {
    await _db!.update(
      'CandidateFeedbackAnswersTable',
      feedbackAnswer.toJson(),
      where: 'id = ?',
      // whereArgs: [feedbackAnswer.id],
    );
  }

  Future<void> deleteFeedbackAnswer(int id) async {
    await _db!.delete(
      'CandidateFeedbackAnswersTable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // curd operations for the ExamTimeTable
  Future<int> insertExamDateTime(CandidateExamTimeModel examTime) async {
    return await _db!.insert('ExamTimeTable', examTime.toJson());
  }

  Future<List<CandidateExamTimeModel>> getAllExamTimes() async {
    List<Map<String, dynamic>> maps = await _db!.query('ExamTimeTable');
    return List.generate(maps.length, (index) {
      return CandidateExamTimeModel(
        date: maps[index]['date'],
        startTime: maps[index]['start_time'],
        endTime: maps[index]['end_time'],
        userId: maps[index]['user_id'],
        switchCount: maps[index]['tab_switch'],
      );
    });
  }

  Future<int> updateExamDateTime(CandidateExamTimeModel examTime) async {
    return await _db!.update(
      'ExamTimeTable',
      examTime.toJson(),
      where:
          'date = ? AND user_id = ?', // Assuming date and user_id are unique identifiers
      whereArgs: [examTime.date, examTime.userId],
    );
  }

  Future<int> deleteExamDateTime(CandidateExamTimeModel examTime) async {
    return await _db!.delete(
      'ExamTimeTable',
      where:
          'date = ? AND user_id = ?', // Assuming date and user_id are unique identifiers
      whereArgs: [examTime.date, examTime.userId],
    );
  }

  // CURD Operations for the QuestionStepsTable Table
  Future<void> insertQuestionStep(QuestionStepsModel questionStep) async {
    await _db!.insert('QuestionStepsTable', questionStep.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Read operation
  Future<List<QuestionStepsModel>> getAllQuestionSteps() async {
    final List<Map<String, dynamic>> maps =
        await _db!.query('QuestionStepsTable');
    return List.generate(maps.length, (i) {
      return QuestionStepsModel.fromJson(maps[i]);
    });
  }

  // Update operation
  Future<void> updateQuestionStep(QuestionStepsModel questionStep) async {
    await _db!.update(
      'QuestionStepsTable',
      questionStep.toJson(),
      where: 'step_id = ?',
      whereArgs: [questionStep.stepId],
    );
  }

  // Delete operation
  Future<void> deleteQuestionStep(String stepId) async {
    await _db!.delete(
      'QuestionStepsTable',
      where: 'step_id = ?',
      whereArgs: [stepId],
    );
  }

  // CURD Operations for the QuestionStepsTable Table

  Future<int> insertStepAnswer(QuestionStepMarkingAnswerModel answer) async {
    return await _db!.insert('QuestionStepMarkingAnswerTable', answer.toJson());
  }

  Future<List<QuestionStepMarkingAnswerModel>> getAllStepAnswers() async {
    final List<Map<String, dynamic>> maps =
        await _db!.query('QuestionStepMarkingAnswerTable');
    return List.generate(maps.length, (i) {
      return QuestionStepMarkingAnswerModel.fromJson(maps[i]);
    });
  }

  Future<int> updateStepAnswer(
      QuestionStepMarkingAnswerModel answer, int id) async {
    return await _db!.update(
      'QuestionStepMarkingAnswerTable',
      answer.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteStepAnswer(int id) async {
    return await _db!.delete(
      'QuestionStepMarkingAnswerTable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
