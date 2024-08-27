import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/AssesmentQuestionsModel.dart';
import 'package:mytat/model/AssessmentAllLanguagesListModel.dart';
import 'package:mytat/model/AssessorDocumentsModel.dart';
import 'package:mytat/model/CandidateExamTimeModel.dart';
import 'package:mytat/model/CandidateModel.dart';
import 'package:mytat/model/CandidateSubmitDocumentsModel.dart';
import 'package:mytat/model/FeedbackFormQuestionsListModel.dart';
import 'package:mytat/model/GridCardModel.dart';
import 'package:mytat/model/Online-Models/OnlineGetCompletedCandidateModel.dart';
import 'package:mytat/model/Online-Models/ServerDateTimeModel.dart';
import 'package:mytat/model/QuestStepsListModel.dart';
import 'package:mytat/model/QuestionStepMarkingAnswerModel.dart';
import 'package:mytat/model/ReferenceLanguageTableModel.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorAnnexureListUploadModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorDocumentsUploadModels.dart';
import 'package:mytat/model/Syncing-Models/AssessorQuestionAnswerReplyModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateMCQAnswersModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateMcqSyncingVerificationModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateScreenshotUploadModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateTotalAnswerSyncedCountModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateVivaSyncingVerificationModel.dart';
import 'package:mytat/model/VivaPracticalMarkingModel.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/ApiClient.dart';
import 'package:mytat/utilities/ApiEndpoints.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';
import 'package:mytat/view/Assessor-Module/assessor_completed_students_theory_screen.dart';
import 'package:mytat/view/Assessor-Module/student_list_screen.dart';
import 'package:mytat/view/Authorization/login_screen.dart';
import 'package:mytat/view/syncing_progress_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/Assessor-Module/assessor_documents_management_Screen.dart';

import 'package:image/image.dart' as img;

class AssessorDashboardController extends GetxController {
  bool _isLoadingResponse = false;
  bool get isLodaingResponse => _isLoadingResponse;

  bool _fetchingLatestData = false;
  bool get fetchingLatestData => _fetchingLatestData;

  String? _companyId;
  String? get companyId => _companyId;

  String? _studentDetailsToShow;
  String? get studentDetailsToShow => _studentDetailsToShow;

  List<PQuestions> _pQuestions = [];
  List<PQuestions> get pQuestions => _pQuestions;

  List<MQuestions> _mQuestions = [];
  List<MQuestions> get mQuestions => _mQuestions;

  List<VQuestions> _vQuestions = [];
  List<VQuestions> get vQuestions => _vQuestions;

  List<Batches> _studentsBatch = [];
  List<Batches> get studentsBatch => _studentsBatch;

  List<Batches> _completedStudentsMcqList = [];
  List<Batches> get completedStudentsMcqList => _completedStudentsMcqList;

  final List<String> _temporaryDocumentsList = [];
  List<String> get temporaryDocumentsList => _temporaryDocumentsList;

  List<Annexurelist> _assessorDocumentsList = [];
  List<Annexurelist> get assessorDocumentsList => _assessorDocumentsList;

  List<GridCardModel> get documentManagement => _documentManagement;
  List<GridCardModel> get vivaManagement => _vivaManagement;
  List<GridCardModel> get studentTheory => _studentTheory;

  final List<Batches> _batchesDetailsToShowList = [];
  List<Batches> get batchesDetailsToShowList => _batchesDetailsToShowList;

  List<CameraDescription>? _cameras;
  List<CameraDescription>? get cameras => _cameras;

  DurationModel? _durationModel;
  DurationModel? get durationModel => _durationModel;

// for candidates completion from assessor side
  List<CandidateModel> _completedCandidateDocumentsList = [];
  List<CandidateModel> get completedCandidateDocumentsList =>
      _completedCandidateDocumentsList;

  List<AssessorQuestionAnswersReplyModel> _completedVivaCandidatesList = [];
  List<AssessorQuestionAnswersReplyModel> get completedVivaCandidatesList =>
      _completedVivaCandidatesList;

  List<AssessorQuestionAnswersReplyModel> _completedPracticalCandidatesList =
      [];
  List<AssessorQuestionAnswersReplyModel>
      get completedPracticalCandidatesList => _completedPracticalCandidatesList;

// for candidates completion from assessor side

  final List<GridCardModel> _documentManagement = [
    GridCardModel(
        icon: ImageUrls.documentIcon,
        title: "Documents",
        screeToNavigate: const AssessorDocumentsManagementScreen()),
    // GridCardModel(
    //     icon: ImageUrls.sync,
    //     title: "Sync",
    //     screeToNavigate: const SyncingInProgressScreen(),
    //     apiTocall: ApiEndpoints.syncStudentDocuments),
    GridCardModel(
        icon: ImageUrls.syncAll,
        title: "Sync All",
        screeToNavigate: const SyncingInProgressScreen(
          syncingTitle: "Assessor Documents",
        )),
  ];

  final List<GridCardModel> _vivaManagement = [
    GridCardModel(
        icon: ImageUrls.startViva,
        title: "Start P/V",
        screeToNavigate: const StudentListScreen()),
    GridCardModel(
        icon: ImageUrls.sync,
        title: "Sync",
        screeToNavigate: const SyncingInProgressScreen()),
    GridCardModel(
        icon: ImageUrls.syncAll,
        title: "Sync All",
        screeToNavigate: const SyncingInProgressScreen(
          syncingTitle: "Student Documents and Practicle",
        )),
  ];

  final List<GridCardModel> _studentTheory = [
    GridCardModel(
        icon: ImageUrls.sync,
        title: "Sync",
        screeToNavigate: const AllTheoryCompletedStudentsList()),
    GridCardModel(
        icon: ImageUrls.syncAll,
        title: "Sync All",
        screeToNavigate: const SyncingInProgressScreen(
          syncingTitle: "Student MCQ and Document",
        )),
    // GridCardModel(
    //     icon: ImageUrls.logoutIcon,
    //     title: "Logout",
    //     screeToNavigate:
    //         const LoginScreen(userType: 'assessor', isOnline: false)),
  ];

  // variables for tracking the syncing progress

  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;

  String _syncingTitle = "";
  String get syncingTitle => _syncingTitle;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  // variables for tracking the syncing progress

  Future<bool> importAssesmentQuestions(String id, {String? companyId}) async {
    print("------------------ Importing Started ------------------");
    _pQuestions = [];
    _vQuestions = [];
    _mQuestions = [];
    _durationModel = DurationModel();

    await getCompanyId();
    await getAssessmentInstructions(id);

    if (companyId != null) {
      AppConstants.companyId = companyId;
      AppConstants.assesmentId = id;

      _companyId = AppConstants.companyId;
    }

    _isLoadingResponse = true;
    update();

    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getAssesmentQuestions}assmentId=$id&compId=$_companyId&assessor_id=${AppConstants.assessorId}");

      if (response['result'] == 1) {
        AssesmentQuestionsModel assesmentQuestionsModel =
            AssesmentQuestionsModel.fromJson(response);

        _pQuestions
            .addAll(assesmentQuestionsModel.pQuestions as Iterable<PQuestions>);
        _mQuestions
            .addAll(assesmentQuestionsModel.mQuestions as Iterable<MQuestions>);
        _vQuestions
            .addAll(assesmentQuestionsModel.vQuestions as Iterable<VQuestions>);
        _durationModel = assesmentQuestionsModel.duration;

        await DatabaseHelper().insertDuration(_durationModel!);

        // Insert data into the database
        await DatabaseHelper().insertPQuestions(_pQuestions);
        await DatabaseHelper().insertMQuestions(_mQuestions);
        await DatabaseHelper().insertVQuestions(_vQuestions);

        print("After Importing questions and documents list length");
        print(_pQuestions.length);
        print(_mQuestions.length);
        print(_vQuestions.length);

        // Trendsetters Code
        if (await importAllAvailableLanguages(id) == true) {
          for (int i = 0; i < _mQuestions.length; i++) {
            await importAllAvailableLanguagesMcqQuestionsAndOptions(
                _mQuestions[i].masterId.toString(),
                _mQuestions[i].id.toString());
          }
        }

        // importing viva and practical options
        await importAvailabeVivaPracticalOptions(id);

        // importing viva and practical options
        await importFeedbackQuestion(id);

        // step wise marking code
        for (int i = 0; i < pQuestions.length; i++) {
          await importStepsOfSpecificQuestion(id, pQuestions[i].id.toString());
        }
        for (int i = 0; i < vQuestions.length; i++) {
          await importStepsOfSpecificQuestion(id, vQuestions[i].id.toString());
        }
        // step wise marking code

        List<MCQuestionsLanguageQuestion> tempDataRetrieving = [];
        tempDataRetrieving =
            await DatabaseHelper().getAllMcqLanguageQuestions();
        print(
            "Total Reference Table Data Available ${tempDataRetrieving.length}");

        // Trendsetters Code

        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setBool("isImportCompleted", true);
        _prefs.setString("assesmentId", id);
        AppConstants.assesmentId = _prefs.getString("assesmentId");
        AppConstants.assessorName = _prefs.getString("assessorName");
        AppConstants.assessorId = _prefs.getString("assesorID");

        print("Assesment Id on Dashboard${AppConstants.assesmentId}");
        print("Assessor Name on Dashboard${AppConstants.assessorName}");
        print("Assessor Id on Dashboard${AppConstants.assessorId}");

        _isLoadingResponse = false;
        update();
        // if (AppConstants.isOnlineMode != true) {
        await importBatch(id);
        await importAssessorDocumentsList();
        // }
        return true;
      } else {
        _isLoadingResponse = false;
        update();
        return false;
      }
    } catch (e) {
      _isLoadingResponse = false;
      update();
      return false;
    }
  }

  Future<bool> importBatch(String id, {bool isResetNeeded = false}) async {
    _studentsBatch = [];
    _isLoadingResponse = true;
    update();

    // Delete all records from the Batch table
    if (isResetNeeded == true) {
      _fetchingLatestData = true;
      update();
      try {
        Map<String, dynamic> response = await ApiClient().get(
            "${ApiEndpoints.getAssesmentQuestions}assmentId=${AppConstants.assesmentId}&compId=${AppConstants.companyId}&assessor_id=${AppConstants.assessorId}");
        if (response['result'] == 1) {
          await DatabaseHelper().refreshDatabase();

          AssesmentQuestionsModel assesmentQuestionsModel =
              AssesmentQuestionsModel.fromJson(response);

          _pQuestions = [];
          _vQuestions = [];

          _pQuestions.addAll(
              assesmentQuestionsModel.pQuestions as Iterable<PQuestions>);
          _vQuestions.addAll(
              assesmentQuestionsModel.vQuestions as Iterable<VQuestions>);

          // Insert data into the database
          await DatabaseHelper().insertPQuestions(_pQuestions);
          await DatabaseHelper().insertVQuestions(_vQuestions);

          print("After Importing questions and documents list length");
          print(_pQuestions.length);
          print(_vQuestions.length);

          // importing viva and practical options
          await importAvailabeVivaPracticalOptions(id);
          // step wise marking code
          for (int i = 0; i < pQuestions.length; i++) {
            await importStepsOfSpecificQuestion(
                id, pQuestions[i].id.toString());
          }
          for (int i = 0; i < vQuestions.length; i++) {
            await importStepsOfSpecificQuestion(
                id, vQuestions[i].id.toString());
          }
          _fetchingLatestData = false;
          update();
          print("----------- IMPORTING STOPPED -----------");
          // step wise marking code
        }
      } catch (e) {
        _fetchingLatestData = false;
        update();
        print("Error While Trying to Re-Import the Data");
      }
    }

    try {
      Map<String, dynamic> response =
          await ApiClient().get("${ApiEndpoints.getBatch}assmentId=$id");

      StudentsBatchModel studentsBatchModel =
          StudentsBatchModel.fromJson(response);

      if (response.isNotEmpty) {
        _studentsBatch.addAll(studentsBatchModel.batch as Iterable<Batches>);
        await DatabaseHelper().insertBatchList(_studentsBatch);
        _isLoadingResponse = false;
        update();
        return true;
      } else {
        _isLoadingResponse = false;
        update();
        return false;
      }
    } catch (e) {
      _isLoadingResponse = false;
      update();
      return false;
    }
  }

  Future<void> getOfflineStudentsList() async {
    _studentsBatch = [];
    _studentsBatch.addAll(await DatabaseHelper().getBatchList());
    update();
  }

  Future<void> getOfflineVivaQuestions() async {
    _vQuestions = [];
    _vQuestions.addAll(await DatabaseHelper().getVQuestions());
    update();
  }

  Future<void> getOfflinePracticleQuestions() async {
    _pQuestions = [];
    _pQuestions.addAll(await DatabaseHelper().getPQuestions());
    update();
  }

  getCompanyId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _companyId = _prefs.getString("companyId");
    update();
  }

  void addToShowStudentDetailsList(Batches student) {
    _batchesDetailsToShowList.add(student);
    update();
  }

  void removeFromShowStudentDetailsList(Batches student) {
    _batchesDetailsToShowList.remove(student);
    update();
  }

  addToTemporaryDocumentsList(String id) {
    _temporaryDocumentsList.add(id);
    update();
  }

// Get Assessor Documents list:
  Future<bool> importAssessorDocumentsList({bool isResetNeeded = false}) async {
    _assessorDocumentsList = [];
    _isLoadingResponse = true;
    update();

    try {
      Map<String, dynamic> response =
          await ApiClient().get(ApiEndpoints.getassessorDocumentsList);

      if (response.isNotEmpty && isResetNeeded == true) {
        DatabaseHelper().refreshAssessorDatabase();
      }

      AssessorDocumentsModel assessorDocumentsModel =
          AssessorDocumentsModel.fromJson(response);

      if (response.isNotEmpty) {
        _assessorDocumentsList.addAll(
            assessorDocumentsModel.annexurelist as Iterable<Annexurelist>);
        for (int i = 0; i < _assessorDocumentsList.length; i++) {
          await DatabaseHelper()
              .insertAnnexureDocumentsList(_assessorDocumentsList[i]);
        }
        _isLoadingResponse = false;
        update();
        return true;
      } else {
        _isLoadingResponse = false;
        update();
        return false;
      }
    } catch (e) {
      _isLoadingResponse = false;
      update();
      return false;
    }
  }
// store assessor documents list:

// get instructions

  Future<void> getAssessmentInstructions(String assessmentId) async {
    AppConstants.instructionsList = [];
    try {
      Map<String, dynamic> response =
          await ApiClient().get("${ApiEndpoints.getInstructions}$assessmentId");

      SharedPreferences _prefs = await SharedPreferences.getInstance();

      await _prefs.setString(
          "instruction", response['data']['test_instruction']);

      AppConstants.instructionsList.add(_prefs.getString("instruction") ?? "");
    } catch (e) {
      CustomSnackBar.customSnackBar(false, "Failed to get instructions");
    }
  }

// Sync Data API's Starts here:
  Future<bool> syncStudentDocuments() async {
    print(
        "-------------------------- SYNCING DOCUMENTS --------------------------");
    // loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Student Documents";
    update();
    // loading indicator for documents

    DatabaseHelper dbHelper = DatabaseHelper();
    try {
      List<CandidateModel> temporaryList = await dbHelper.getCandidates();
      if (temporaryList.isEmpty) {
        // CustomSnackBar.customSnackBar(true, "No Data for Students found!");
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return true;
      } else {
        for (var i = 0; i < temporaryList.length; i++) {
          if (_completedPVSyncedCandidatesList
                  .contains(temporaryList[i].candidateId) ==
              false) {
            var candidateJsonData = json.encode({
              "type": temporaryList[i].type,
              "assessorId": int.parse(temporaryList[i].assessorId ?? ""),
              "assmentId": int.parse(AppConstants.assesmentId ?? ""),
              "aadharFront":
                  "${AppConstants.imageUploadUrl}${temporaryList[i].candidateAadharFront!.replaceFirst(AppConstants.replacementPath, "")}",
              "aadharBack": temporaryList[i].candidateAadharBack != "NA" &&
                      temporaryList[i].candidateAadharBack != "" &&
                      temporaryList[i].candidateAadharBack != null
                  ? "${AppConstants.imageUploadUrl}${temporaryList[i].candidateAadharBack!.replaceFirst(AppConstants.replacementPath, "")}"
                  : "NA",
              "profilePhoto":
                  "${AppConstants.imageUploadUrl}${temporaryList[i].candidateProfile!.replaceFirst(AppConstants.replacementPath, "")}",
              "studentId": temporaryList[i].candidateId,
              "latitude": temporaryList[i].latitude,
              "longitude": temporaryList[i].longitude
            });

            // Storing Students Documents to the Server
            await ApiClient()
                .uploadImageToServer(temporaryList[i].candidateAadharFront);
            if (temporaryList[i].candidateAadharBack != "NA" &&
                temporaryList[i].candidateAadharBack != "" &&
                temporaryList[i].candidateAadharBack != null) {
              await ApiClient()
                  .uploadImageToServer(temporaryList[i].candidateAadharBack);
            }

            await ApiClient()
                .uploadImageToServer(temporaryList[i].candidateProfile);

            await ApiClient().post(ApiEndpoints.syncStudentDocuments,
                data: candidateJsonData);
            // loading indicator for documents
          }

          _uploadProgress = (i + 1) / temporaryList.length;
          update();
          // loading indicator for documents
        }
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return true;
      }
    } catch (e) {
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
      return false;
    }
  }

  Future<bool> syncAssessorDataToServer(
      AssessorDocumentsUploadModel? assesorInformation) async {
    // loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Assessor Center Documents";
    update();
    // loading indicator for documents

    try {
      if (assesorInformation != null) {
        // // Storing Assessor Video to the Server:
        await ApiClient().uploadVideoToServer(
            Get.find<QuestionAnswersController>().currentAssessorCenterVideo);

        // Storing Assessor Center Images to the Server
        await ApiClient().uploadImageToServer(
            Get.find<QuestionAnswersController>().currentAssessorCenterPic);
        await ApiClient().uploadImageToServer(
            Get.find<QuestionAnswersController>().currentAssessorAdharPic);
        await ApiClient().uploadImageToServer(
            Get.find<QuestionAnswersController>().currentAssessorProfilePhoto);

        List<String> tempDocumentsList = await getAnnexureDocumentsPathList();

        for (int i = 0; i < tempDocumentsList.length; i++) {
          await ApiClient().uploadImageToServer(tempDocumentsList[i]);
          // loading indicator for documents
          _uploadProgress = (i + 1) / tempDocumentsList.length;
          update();
          // loading indicator for documents
        }

        var assessorEncodedDataWithReplacedUrl = jsonEncode(
            AppConstants.assessorDocumentsUploadModelwithReplacedUrl);
        print(
            "WHILE UPLOADING ---------------- {$assessorEncodedDataWithReplacedUrl");
        await ApiClient().post(ApiEndpoints.syncAssessorDocuments,
            data: assessorEncodedDataWithReplacedUrl);
        await clearAssessorDocumentsListData();
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return true;
      } else {
        _isSyncing = true;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return false;
      }
    } catch (e) {
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
      return false;
    }
  }

  Future<void> syncAssessorAnnexureDocumentsToServer() async {
    print(
        "-------------------------- SYNCING ASSESSOR DOCUMENTS HERE --------------------------");

    // loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Assessor Anexure Documents";
    update();
    // loading indicator for documents

    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      List<AssessorAnnexurelistUploadModel> tempList =
          await dbHelper.getAllAnnexureDocumentsData();

      for (int i = 0; i < tempList.length; i++) {
        // syncing image
        await ApiClient().uploadImageToServer(tempList[i].image);

        await ApiClient().get(
            "${ApiEndpoints.syncAssessorAnnexureDocuments}assmentId=${int.parse(AppConstants.assesmentId.toString())}&title=${tempList[i].name}&titleVal=${tempList[i].image!.replaceFirst("/file_picker", "").replaceFirst(AppConstants.replacementPath, "")}&assessorId=${int.parse(AppConstants.assessorId.toString())}&lat=${tempList[i].lat}&long=${tempList[i].long}&time=${tempList[i].time}");

        // loading indicator for documents
        _uploadProgress = (i + 1) / tempList.length;
        update();
        // loading indicator for documents
      }
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
    } catch (e) {
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
      debugPrint("Exception: $e");
    }
  }

  Future<List<String>> getAnnexureDocumentsPathList() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> tempList = [];
    List<Annexurelist> temporaryAssessorDatabaseLink =
        await DatabaseHelper().getAllAnnexureDocumentsList();
    for (int i = 0; i < temporaryAssessorDatabaseLink.length; i++) {
      if (_prefs.getString(temporaryAssessorDatabaseLink[i].name ?? "") !=
          null) {
        String? newImage =
            _prefs.getString(temporaryAssessorDatabaseLink[i].name ?? "");
        if (newImage != null) {
          tempList.add(newImage);
        }
      }
    }
    return tempList;
  }

  Future<void> clearAssessorDocumentsListData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> tempDocumentsList = await getAnnexureDocumentsPathList();
    for (int i = 0; i < tempDocumentsList.length; i++) {
      _prefs.remove(tempDocumentsList[i]);
    }
  }

// Syncing Candidates Answers
  Future<bool> syncVivaAnswersOfCandidates() async {
    print("-------------------------- SYNCING VIVA --------------------------");

    // loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Student Viva Answers Data";
    update();
    // loading indicator for documents

    // getting list from the database
    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      List<AssessorQuestionAnswersReplyModel>
          databaseCandidatesRecordedInsertedAnswers =
          await dbHelper.getCandidatesVivaAnswers();

      if (databaseCandidatesRecordedInsertedAnswers.isEmpty) {
        print("No Data for Viva Found");
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return true;
      } else {
        for (int i = 0;
            i < databaseCandidatesRecordedInsertedAnswers.length;
            i++) {
          if (_completedPVSyncedCandidatesList.contains(
                  databaseCandidatesRecordedInsertedAnswers[i].studentId) ==
              false) {
            if (databaseCandidatesRecordedInsertedAnswers[i].videoUrl != null) {
              await ApiClient().uploadVideoToServer(
                  databaseCandidatesRecordedInsertedAnswers[i].videoUrl);
              // url changes
              await ApiClient().postFormRequest(
                  ApiEndpoints.syncStudentsVivaAndPracticleAnswers, {
                'assesmentId': databaseCandidatesRecordedInsertedAnswers[i]
                    .assesmentId
                    .toString(),
                'assesorFeedback': databaseCandidatesRecordedInsertedAnswers[i]
                    .marksTitle
                    .toString(),
                'assesorMarks':
                    databaseCandidatesRecordedInsertedAnswers[i].assesorMarks,
                'assessorId':
                    databaseCandidatesRecordedInsertedAnswers[i].assessorId,
                'questionId':
                    databaseCandidatesRecordedInsertedAnswers[i].questionId,
                'studentId':
                    databaseCandidatesRecordedInsertedAnswers[i].studentId,
                'videoUrl':
                    '${AppConstants.videoUploadUrl}${databaseCandidatesRecordedInsertedAnswers[i].videoUrl!.replaceFirst(AppConstants.replacementPath, "")}',
                'p_date': databaseCandidatesRecordedInsertedAnswers[i].pDate,
                'p_start_time':
                    databaseCandidatesRecordedInsertedAnswers[i].pStartTime,
                'p_end_time':
                    databaseCandidatesRecordedInsertedAnswers[i].pEndTime,
                'v_date': databaseCandidatesRecordedInsertedAnswers[i].vDate,
                'v_start_time':
                    databaseCandidatesRecordedInsertedAnswers[i].vStartTime,
                'v_end_time':
                    databaseCandidatesRecordedInsertedAnswers[i].vEndTime,
                // sstpl/iris
                'time': databaseCandidatesRecordedInsertedAnswers[i]
                    .timeTaken
                    .toString(),
                'latlong': databaseCandidatesRecordedInsertedAnswers[i]
                    .long
                    .toString(),
                // sstpl/iris
              });
            } else {
              await ApiClient().postFormRequest(
                  ApiEndpoints.syncStudentsVivaAndPracticleAnswers, {
                'assesmentId': databaseCandidatesRecordedInsertedAnswers[i]
                    .assesmentId
                    .toString(),
                'assesorFeedback': databaseCandidatesRecordedInsertedAnswers[i]
                    .marksTitle
                    .toString(),
                'assesorMarks':
                    databaseCandidatesRecordedInsertedAnswers[i].assesorMarks,
                'assessorId':
                    databaseCandidatesRecordedInsertedAnswers[i].assessorId,
                'questionId':
                    databaseCandidatesRecordedInsertedAnswers[i].questionId,
                'studentId':
                    databaseCandidatesRecordedInsertedAnswers[i].studentId,
                'videoUrl': 'no',
                'p_date': databaseCandidatesRecordedInsertedAnswers[i].pDate,
                'p_start_time':
                    databaseCandidatesRecordedInsertedAnswers[i].pStartTime,
                'p_end_time':
                    databaseCandidatesRecordedInsertedAnswers[i].pEndTime,
                'v_date': databaseCandidatesRecordedInsertedAnswers[i].vDate,
                'v_start_time':
                    databaseCandidatesRecordedInsertedAnswers[i].vStartTime,
                'v_end_time':
                    databaseCandidatesRecordedInsertedAnswers[i].vEndTime,
                // sstpl/iris
                'time': databaseCandidatesRecordedInsertedAnswers[i]
                    .timeTaken
                    .toString(),
                'latlong': databaseCandidatesRecordedInsertedAnswers[i]
                    .long
                    .toString(),
                // sstpl/iris
              });
            }
          }

          // loading indicator for documents
          _uploadProgress =
              (i + 1) / databaseCandidatesRecordedInsertedAnswers.length;
          update();
          // loading indicator for documents
        }
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return true;
      }
    } catch (e) {
      debugPrint("Exception: $e");
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
      return false;
    }
  }

  Future<bool> syncPracticleAndVivaStepAnswersOfCandidates() async {
    print(
        "-------------------------- SYNCING PRACTICLES & VIVA STEP ANSWERS --------------------------");

    // loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Student Practical & Viva Steps Answers Data";
    update();
    // loading indicator for documents

    // getting list from the database
    DatabaseHelper dbHelper = DatabaseHelper();

    // step wise marking code

    try {
      List<QuestionStepMarkingAnswerModel>
          temporaryPracticalAndVivaStepAnswersList =
          await dbHelper.getAllStepAnswers();

      if (temporaryPracticalAndVivaStepAnswersList.isEmpty) {
        print("No Data for Practical & Viva Steps Answers Found");
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return true;
      } else {
        for (var i = 0;
            i < temporaryPracticalAndVivaStepAnswersList.length;
            i++) {
          if (_completedPVSyncedCandidatesList.contains(
                  temporaryPracticalAndVivaStepAnswersList[i].candidateId) ==
              false) {
            await oneCandidatePracticalStepMarksSync(
                temporaryPracticalAndVivaStepAnswersList[i]);
            // loading indicator for documents
            _uploadProgress =
                (i + 1) / temporaryPracticalAndVivaStepAnswersList.length;
            update();
            // loading indicator for documents
          }
        }
      }
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
      return true;
    } catch (e) {
      debugPrint("Exception: $e");
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
      return false;
    }
  }

  // Syncing Candidates Answers
  Future<bool> syncPracticleAnswersOfCandidates() async {
    print(
        "-------------------------- SYNCING PRACTICLES --------------------------");

    // loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Student Practical Answers Data";
    update();
    // loading indicator for documents

    // getting list from the database
    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      List<AssessorQuestionAnswersReplyModel>
          databaseCandidatesRecordedInsertedAnswers =
          await dbHelper.getCandidatesPracticleAnswers();
      if (databaseCandidatesRecordedInsertedAnswers.isEmpty) {
        print("No Data for Practical Found");
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return true;
      } else {
        for (int i = 0;
            i < databaseCandidatesRecordedInsertedAnswers.length;
            i++) {
          if (_completedPVSyncedCandidatesList.contains(
                  databaseCandidatesRecordedInsertedAnswers[i].studentId) ==
              false) {
            if (databaseCandidatesRecordedInsertedAnswers[i].videoUrl != null) {
              await ApiClient().uploadVideoToServer(
                  databaseCandidatesRecordedInsertedAnswers[i].videoUrl);
              // url changes
              await ApiClient().postFormRequest(
                  ApiEndpoints.syncStudentsVivaAndPracticleAnswers, {
                'assesmentId': databaseCandidatesRecordedInsertedAnswers[i]
                    .assesmentId
                    .toString(),
                'assesorFeedback': databaseCandidatesRecordedInsertedAnswers[i]
                    .marksTitle
                    .toString(),
                'assesorMarks':
                    databaseCandidatesRecordedInsertedAnswers[i].assesorMarks,
                'assessorId':
                    databaseCandidatesRecordedInsertedAnswers[i].studentId,
                'questionId':
                    databaseCandidatesRecordedInsertedAnswers[i].questionId,
                'studentId':
                    databaseCandidatesRecordedInsertedAnswers[i].studentId,
                'videoUrl':
                    '${AppConstants.videoUploadUrl}${databaseCandidatesRecordedInsertedAnswers[i].videoUrl!.replaceFirst(AppConstants.replacementPath, "")}',
                'p_date': databaseCandidatesRecordedInsertedAnswers[i].pDate,
                'p_start_time':
                    databaseCandidatesRecordedInsertedAnswers[i].pStartTime,
                'p_end_time':
                    databaseCandidatesRecordedInsertedAnswers[i].pEndTime,
                'v_date': databaseCandidatesRecordedInsertedAnswers[i].vDate,
                'v_start_time':
                    databaseCandidatesRecordedInsertedAnswers[i].vStartTime,
                'v_end_time':
                    databaseCandidatesRecordedInsertedAnswers[i].vEndTime,
                // sstpl/iris
                'time': databaseCandidatesRecordedInsertedAnswers[i]
                    .timeTaken
                    .toString(),
                'latlong': databaseCandidatesRecordedInsertedAnswers[i]
                    .long
                    .toString(),
                // sstpl/iris
              });
            } else {
              await ApiClient().postFormRequest(
                  ApiEndpoints.syncStudentsVivaAndPracticleAnswers, {
                'assesmentId': databaseCandidatesRecordedInsertedAnswers[i]
                    .assesmentId
                    .toString(),
                'assesorFeedback': databaseCandidatesRecordedInsertedAnswers[i]
                    .marksTitle
                    .toString(),
                'assesorMarks':
                    databaseCandidatesRecordedInsertedAnswers[i].assesorMarks,
                'assessorId':
                    databaseCandidatesRecordedInsertedAnswers[i].studentId,
                'questionId':
                    databaseCandidatesRecordedInsertedAnswers[i].questionId,
                'studentId':
                    databaseCandidatesRecordedInsertedAnswers[i].studentId,
                'videoUrl': 'no',
                'p_date': databaseCandidatesRecordedInsertedAnswers[i].pDate,
                'p_start_time':
                    databaseCandidatesRecordedInsertedAnswers[i].pStartTime,
                'p_end_time':
                    databaseCandidatesRecordedInsertedAnswers[i].pEndTime,
                'v_date': databaseCandidatesRecordedInsertedAnswers[i].vDate,
                'v_start_time':
                    databaseCandidatesRecordedInsertedAnswers[i].vStartTime,
                'v_end_time':
                    databaseCandidatesRecordedInsertedAnswers[i].vEndTime,
                // sstpl/iris
                'time': databaseCandidatesRecordedInsertedAnswers[i]
                    .timeTaken
                    .toString(),
                'latlong': databaseCandidatesRecordedInsertedAnswers[i]
                    .long
                    .toString(),
                // sstpl/iris
              });
            }
          }

          // loading indicator for documents
          _uploadProgress =
              (i + 1) / databaseCandidatesRecordedInsertedAnswers.length;
          update();
          // loading indicator for documents
        }
      }
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
      return true;
    } catch (e) {
      debugPrint("Exception: $e");
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
      return false;
    }
  }

  Future<void> getAllCompletedStudentsMcqList() async {
    _completedStudentsMcqList = [];
    _completedStudentsMcqList =
        await DatabaseHelper().getAllCompletedMcqStudents();
    update();
  }

// Your function
  void getAllCompletedDocumentsCandidatesList() async {
    _completedCandidateDocumentsList = [];
    _completedCandidateDocumentsList = await DatabaseHelper().getCandidates();
    update();
  }

// checking is documentation done
  isCandidateDocumentationDone(String candidateId) {
    // Loop through the completed candidates list
    for (int index = 0;
        index < _completedCandidateDocumentsList.length;
        index++) {
      if (_completedCandidateDocumentsList[index].candidateId == candidateId) {
        return true;
      }
    }
    return false;
  }

  getAllCompletedPracticalCandidatesList() async {
    _completedPracticalCandidatesList = [];
    _completedPracticalCandidatesList =
        await DatabaseHelper().getCandidatesPracticleAnswers();
    update();
  }

  isCandidatePracticalDone(String candidateId) {
    // Loop through the completed candidates list
    for (int index = 0;
        index < _completedPracticalCandidatesList.length;
        index++) {
      if (_completedPracticalCandidatesList[index].studentId == candidateId) {
        return true;
      }
    }
    return false;
  }

  getAllCompletedVivaCandidatesList() async {
    _completedVivaCandidatesList = [];
    _completedVivaCandidatesList =
        await DatabaseHelper().getCandidatesVivaAnswers();
    update();
  }

  isCandidateVivaDone(String candidateId) {
    // Loop through the completed candidates list
    for (int index = 0; index < _completedVivaCandidatesList.length; index++) {
      if (_completedVivaCandidatesList[index].studentId == candidateId) {
        return true;
      }
    }
    return false;
  }
  // getting all locally stored data of the candidates from assessor side

  // Syncing One by One for Students MCQs
  bool _isSyncingSingleData = false;
  bool get isSyncingSingleData => _isSyncingSingleData;

  String _singleSyncingTitle = "";
  String get singleSyncingTitle => _singleSyncingTitle;

  int? _currentSyncingCandidate;
  int? get currentSyncingCandidate => _currentSyncingCandidate;

  List<McqSyncingVerificationModel> _verifiedCandidatesMcqList = [];
  List<McqSyncingVerificationModel> get verifiedCandidatesMcqList =>
      _verifiedCandidatesMcqList;

  Future<void> syncMcqOneByOne(Batches candidate, int index,
      {bool isDocumentLinkNeeded = true}) async {
    _isSyncingSingleData = true;
    _singleSyncingTitle = "Syncing Documents";
    _currentSyncingCandidate = index;

    if (AppConstants.isOnlineMode == true) {
      Get.find<CandidateOnboardingController>()
          .changeOneCandidateUploadingStatus();
    }

    print(
        "--------------------->>>>>>>>>><<<<<<<<<<======================= SYNCING DOCUMENTS --------------------->>>>>>>>>><<<<<<<<<<=======================");

    update();
    // One Candidate Documents Syncing Process
    if (isDocumentLinkNeeded == true) {
      List<CandidateSubmitDocumentsModel> candidateDocumentsList = [];
      candidateDocumentsList =
          await DatabaseHelper().getCandidatesSubmittedDocuments();
      update();
      for (int i = 0; i < candidateDocumentsList.length; i++) {
        if (candidateDocumentsList[i].candidateId == candidate.id) {
          await oneCandidateSyncMcqDocuments(
              candidateDocumentsList[i], candidate);
        }
      }
      update();
    }

    print(
        "--------------------->>>>>>>>>><<<<<<<<<<======================= SYNCING MCQ --------------------->>>>>>>>>><<<<<<<<<<=======================");

    // One Candidate MCQ Answers Syncing Process
    _singleSyncingTitle = "Syncing Answers";
    update();
    List<McqAnswers> allStudentsMcqAnswers = [];
    allStudentsMcqAnswers = await DatabaseHelper().getAllCandidatesMcqAnswers();
    for (int i = 0; i < allStudentsMcqAnswers.length; i++) {
      if (allStudentsMcqAnswers[i].candidateId == candidate.id) {
        await oneCandidateMcqAnswersOfCandidates(
            allStudentsMcqAnswers[i], candidate, i);
      }
    }

    update();

    print(
        "--------------------->>>>>>>>>><<<<<<<<<<======================= SYNCING FEEDBACK --------------------->>>>>>>>>><<<<<<<<<<=======================");

    // Candidate List Syncing Process
    // exam date time code
    CandidateExamTimeModel? candidateExamTimeModel =
        await Get.find<CandidateOnboardingController>()
            .getExamDateTimeOfCandidate(candidate.id.toString());
    // exam date time code
    await ApiClient()
        .postFormRequest(ApiEndpoints.syncStudentMcqAnswersCompleteSync, {
      'assmentId': candidate.assmentId,
      'userId': candidate.id,
      'date': candidateExamTimeModel != null ? candidateExamTimeModel.date : "",
      'start_time': candidateExamTimeModel != null
          ? candidateExamTimeModel.startTime
          : "",
      'end_time':
          candidateExamTimeModel != null ? candidateExamTimeModel.endTime : "",
      'tab_switch': candidateExamTimeModel != null
          ? candidateExamTimeModel.switchCount.toString()
          : "0"
    });

    // var response = await ApiClient().post(
    //     "${ApiEndpoints.syncStudentMcqAnswersCompleteSync}assmentId=${candidate.assmentId}&userId=${candidate.id}");
    print(
        "--------------------->>>>>>>>>><<<<<<<<<<======================= SYNCING SCREENSHOTS --------------------->>>>>>>>>><<<<<<<<<<=======================");

    // exam date time code

    // Candidate Screenshots Syncing Process
    _singleSyncingTitle = "Syncing Screenshots";
    update();
    List<CandidateScreenshotUploadModel> allCandidatesScreenshots = [];
    allCandidatesScreenshots = await DatabaseHelper().getCandidateScreenshots();
    for (int i = 0; i < allCandidatesScreenshots.length; i++) {
      if (allCandidatesScreenshots[i].userId == candidate.id) {
        await syncCompletedMcqStudentsScreenshots(allCandidatesScreenshots[i]);
      }
    }

    update();

    await syncOneCandidateFinalTime(candidate.id.toString());

    McqSyncingVerificationModel newVerificationModel =
        McqSyncingVerificationModel(
            candidateIds: candidate.id,
            isAnswersSynced: "1",
            isDocumentsSynced: "1",
            isScreenshotsSynced: "1");

    DatabaseHelper().insertMcqVerification(newVerificationModel);
    List<McqSyncingVerificationModel> tempList =
        await DatabaseHelper().getMcqVerifications();
    print("Total Successfully Synced Candidates: ${tempList.length}");

    if (AppConstants.isOnlineMode == true) {
      Get.find<CandidateOnboardingController>()
          .changeOneCandidateUploadingStatus();
    }
    // feedback code
    if (AppConstants.isOnlineMode == true) {
      Get.find<CandidateOnboardingController>().syncOneCandidateFeedback(
          candidate.assmentId.toString(), candidate.id.toString());
    }
    // feedback code

    _isSyncingSingleData = false;
    _currentSyncingCandidate = null;
    update();
    await getTheMcqVerificationList();
  }

  getTheMcqVerificationList() async {
    _verifiedCandidatesMcqList = [];
    _verifiedCandidatesMcqList = await DatabaseHelper().getMcqVerifications();
    update();
  }

  bool isCandidateMcqSynced(String candidateId) {
    for (int i = 0; i < _verifiedCandidatesMcqList.length; i++) {
      if (_verifiedCandidatesMcqList[i].candidateIds == candidateId) {
        return true;
      }
    }
    return false;
  }

  // One Candidate Document Syncing
  Future<bool> oneCandidateSyncMcqDocuments(
      CandidateSubmitDocumentsModel candidateDocuments,
      Batches candidate) async {
    print(
        "-------------------------- SYNCING ${candidate.name} DOCUMENTS --------------------------");
    print("assessor id :::::::: ${AppConstants.assessorId}");
    try {
      var candidateJsonData = json.encode({
        "type": candidateDocuments.type,
        "assessorId": int.parse(AppConstants.assessorId ?? "0"),
        "assmentId": int.parse(candidate.assmentId ?? ""),
        "aadharFront":
            "${AppConstants.imageUploadUrl}${candidateDocuments.candidateAadharFront!.replaceFirst(AppConstants.replacementPath, "")}",
        "aadharBack": candidateDocuments.candidateAadharBack != "NA" &&
                candidateDocuments.candidateAadharBack != null &&
                candidateDocuments.candidateAadharBack != ""
            ? "${AppConstants.imageUploadUrl}${candidateDocuments.candidateAadharBack!.replaceFirst(AppConstants.replacementPath, "")}"
            : "NA",
        "profilePhoto":
            "${AppConstants.imageUploadUrl}${candidateDocuments.candidateProfile!.replaceFirst(AppConstants.replacementPath, "")}",
        "studentId": int.parse(candidateDocuments.candidateId ?? ""),
        "latitude": candidateDocuments.latitude,
        "longitude": candidateDocuments.longitude
      });

      // Storing Students Documents to the Server
      await ApiClient()
          .uploadImageToServer(candidateDocuments.candidateAadharFront);
      if (candidateDocuments.candidateAadharBack != "NA" &&
          candidateDocuments.candidateAadharBack != null &&
          candidateDocuments.candidateAadharBack != "") {
        await ApiClient()
            .uploadImageToServer(candidateDocuments.candidateAadharBack);
      }

      await ApiClient()
          .uploadImageToServer(candidateDocuments.candidateProfile);

      await ApiClient()
          .post(ApiEndpoints.syncStudentDocuments, data: candidateJsonData);
      update();
      return true;
    } catch (e) {
      debugPrint("Exception while Uploading Single Document: $e");
      CustomSnackBar.customSnackBar(false, "Failed to Sync data");
      return false;
    }
  }

  // One Candidate Mcq Answers Syncing
  Future<bool> oneCandidateMcqAnswersOfCandidates(
      McqAnswers answer, Batches candidate, int index) async {
    print(
        "-------------------------- SYNCING ${candidate.name} QUESTION $index MCQ ANSWERE HERE --------------------------");
    try {
      await ApiClient().post(
          "${ApiEndpoints.syncStudentMcqAnswers}assmentId=${answer.assessmentId}&userId=${answer.candidateId}&questId=${answer.questionId}&userAns=${answer.answerId}&anstime=${answer.answerTime}");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> syncCompletedMcqStudentsScreenshots(
      CandidateScreenshotUploadModel screenshot) async {
    print(
        "-------------------------- SYNCING STUDENTS SCREEENSHOTS HERE --------------------------");

    try {
      var response = await ApiClient().get(
          "${ApiEndpoints.syncStudentsMcqScreenshots}assmentId=${int.parse(screenshot.assmentId ?? "")}&userId=${int.parse(screenshot.userId ?? "")}&userimg=${screenshot.userimg!.replaceFirst(AppConstants.replacementPath, "")}&facecount=${screenshot.faceCount}&imgTime=${screenshot.dateTime}");
      // syncing image
      await ApiClient().uploadScreenshotToServer(screenshot.userimg,
          screenshot.assmentId ?? "", screenshot.userId ?? "");
      print("Total Screenshots Synced Here: $response");
    } catch (e) {
      debugPrint("Exception: $e");
    }
    update();
  }

// Viva & Practical Syncing one by one
  List<VivaSyncingVerificationModel> _verifiedVivaCandidatesList = [];
  List<VivaSyncingVerificationModel> get verifiedVivaCandidatesList =>
      _verifiedVivaCandidatesList;
  Future<void> syncVivaAndPracicalOneByOne(Batches candidate, int index) async {
    print(
        "-------------------------- SYNCING ONE CANDIDATE DOCUMENTS --------------------------");

    // loading indicator for documents
    _isSyncingSingleData = true;
    // _singleSyncingTitle = "Syncing Documents";
    _singleSyncingTitle = "Syncing Data";

    _currentSyncingCandidate = index;

    update();
    // loading indicator for documents
    DatabaseHelper dbHelper = DatabaseHelper();
    List<CandidateModel> temporaryList = await dbHelper.getCandidates();
    for (var i = 0; i < temporaryList.length; i++) {
      if (candidate.id == temporaryList[i].candidateId) {
        await oneCandidateVivaAndPracticalDocuments(temporaryList[i]);
      }
    }

    print(
        "-------------------------- SYNCING ONE CANDIDATE VIVA --------------------------");
    // _singleSyncingTitle = "Syncing Viva";
    _singleSyncingTitle = "Syncing Data";

    update();

    List<AssessorQuestionAnswersReplyModel>
        databaseVivaRecordedInsertedAnswers =
        await dbHelper.getCandidatesVivaAnswers();
    for (var i = 0; i < databaseVivaRecordedInsertedAnswers.length; i++) {
      if (candidate.id == databaseVivaRecordedInsertedAnswers[i].studentId) {
        await oneCandidateViva(databaseVivaRecordedInsertedAnswers[i]);
      }
    }

    print(
        "-------------------------- SYNCING ONE CANDIDATE PRACICALS --------------------------");
    // _singleSyncingTitle = "Syncing Practicals";
    _singleSyncingTitle = "Syncing Data";

    update();

    List<AssessorQuestionAnswersReplyModel>
        databasePracticalsRecordedInsertedAnswers =
        await dbHelper.getCandidatesPracticleAnswers();
    for (var i = 0; i < databasePracticalsRecordedInsertedAnswers.length; i++) {
      if (candidate.id ==
          databasePracticalsRecordedInsertedAnswers[i].studentId) {
        await oneCandidatePacticals(
            databasePracticalsRecordedInsertedAnswers[i]);
      }
    }

    // step wise marking code
    print(
        "-------------------------- SYNCING ONE CANDIDATE PRACICALS AND VIVA STEPS MARKS --------------------------");
    List<QuestionStepMarkingAnswerModel>
        temporaryPracticalAndVivaStepAnswersList =
        await dbHelper.getAllStepAnswers();
    for (var i = 0; i < temporaryPracticalAndVivaStepAnswersList.length; i++) {
      if (candidate.id ==
              temporaryPracticalAndVivaStepAnswersList[i].candidateId &&
          temporaryPracticalAndVivaStepAnswersList[i].answerType == "p") {
        await oneCandidatePracticalStepMarksSync(
            temporaryPracticalAndVivaStepAnswersList[i]);
      }
    }

    for (var i = 0; i < temporaryPracticalAndVivaStepAnswersList.length; i++) {
      if (candidate.id ==
              temporaryPracticalAndVivaStepAnswersList[i].candidateId &&
          temporaryPracticalAndVivaStepAnswersList[i].answerType == "v") {
        await oneCandidateVivaStepMarksSync(
            temporaryPracticalAndVivaStepAnswersList[i]);
      }
    }
    // step wise marking code

    // time api
    await syncOneCandidateFinalTime(candidate.id.toString());
    // time api

    VivaSyncingVerificationModel vivaSyncingVerificationModel =
        VivaSyncingVerificationModel(
            candidateIds: candidate.id,
            isDocumentsSynced: "1",
            isPracticalSynced: "1",
            isVivaSynced: "1");

    await dbHelper.insertVivaSyncingVerification(vivaSyncingVerificationModel);
    _isSyncingSingleData = false;
    _currentSyncingCandidate = null;

    update();
    await getTheCompletedVivaVerificationList();
  }

  // step wise marking code

  Future<void> oneCandidatePracticalStepMarksSync(
      QuestionStepMarkingAnswerModel candidateAnswer) async {
    try {
      await ApiClient()
          .postFormRequest(ApiEndpoints.syncPracticalVivaStepAnswer, {
        'marks': candidateAnswer.marksByAssessor,
        'question_id': candidateAnswer.questionId,
        'user_id': candidateAnswer.candidateId,
        'step_id': candidateAnswer.stepId,
        'remark': candidateAnswer.markingTitle,
        'assessment_id': AppConstants.assesmentId
      });
    } catch (e) {
      CustomToast.showToast("Failed to Sync Candidate Step marks");
    }
  }

  Future<void> oneCandidateVivaStepMarksSync(
      QuestionStepMarkingAnswerModel candidateAnswer) async {
    try {
      await ApiClient()
          .postFormRequest(ApiEndpoints.syncPracticalVivaStepAnswer, {
        'marks': candidateAnswer.marksByAssessor,
        'question_id': candidateAnswer.questionId,
        'user_id': candidateAnswer.candidateId,
        'step_id': candidateAnswer.stepId,
        'remark': candidateAnswer.markingTitle,
        'assessment_id': AppConstants.assesmentId
      });
    } catch (e) {
      CustomToast.showToast("Failed to Sync Candidate Step marks");
    }
  }
  // step wise marking code

  Future<bool> oneCandidateViva(
      AssessorQuestionAnswersReplyModel candidate) async {
    if (candidate.videoUrl != null) {
      await ApiClient().uploadVideoToServer(candidate.videoUrl);
      // url changes
      await ApiClient()
          .postFormRequest(ApiEndpoints.syncStudentsVivaAndPracticleAnswers, {
        'assesmentId': candidate.assesmentId.toString(),
        'assesorFeedback': candidate.marksTitle.toString(),
        'assesorMarks': candidate.assesorMarks,
        'assessorId': candidate.assessorId,
        'questionId': candidate.questionId,
        'studentId': candidate.studentId,
        'videoUrl':
            "${AppConstants.videoUploadUrl}${candidate.videoUrl!.replaceFirst(AppConstants.replacementPath, "")}",
        'p_date': candidate.pDate,
        'p_start_time': candidate.pStartTime,
        'p_end_time': candidate.pEndTime,
        'v_date': candidate.vDate,
        'v_start_time': candidate.vStartTime,
        'v_end_time': candidate.vEndTime,
        // sstpl/iris
        'time': candidate.timeTaken.toString(),
        'latlong': candidate.long.toString(),
        // sstpl/iris
      });
    } else {
      // url changes
      // url changes
      await ApiClient()
          .postFormRequest(ApiEndpoints.syncStudentsVivaAndPracticleAnswers, {
        'assesmentId': candidate.assesmentId.toString(),
        'assesorFeedback': candidate.marksTitle.toString(),
        'assesorMarks': candidate.assesorMarks,
        'assessorId': candidate.assessorId,
        'questionId': candidate.questionId,
        'studentId': candidate.studentId,
        'videoUrl': "NA.mp4",
        'p_date': candidate.pDate,
        'p_start_time': candidate.pStartTime,
        'p_end_time': candidate.pEndTime,
        'v_date': candidate.vDate,
        'v_start_time': candidate.vStartTime,
        'v_end_time': candidate.vEndTime,
        // sstpl/iris
        'time': candidate.timeTaken.toString(),
        'latlong': candidate.long.toString(),
        // sstpl/iris
      });
    }
    return true;
  }

  Future<bool> oneCandidatePacticals(
      AssessorQuestionAnswersReplyModel candidate) async {
    if (candidate.videoUrl != null) {
      await ApiClient().uploadVideoToServer(candidate.videoUrl);
      // url changes
      await ApiClient()
          .postFormRequest(ApiEndpoints.syncStudentsVivaAndPracticleAnswers, {
        'assesmentId': candidate.assesmentId.toString(),
        'assesorFeedback': candidate.marksTitle.toString(),
        'assesorMarks': candidate.assesorMarks,
        'assessorId': candidate.assessorId,
        'questionId': candidate.questionId,
        'studentId': candidate.studentId,
        'videoUrl':
            "${AppConstants.videoUploadUrl}${candidate.videoUrl!.replaceFirst(AppConstants.replacementPath, "")}",
        'p_date': candidate.pDate,
        'p_start_time': candidate.pStartTime,
        'p_end_time': candidate.pEndTime,
        'v_date': candidate.vDate,
        'v_start_time': candidate.vStartTime,
        'v_end_time': candidate.vEndTime,
        // sstpl/iris
        'time': candidate.timeTaken.toString(),
        'latlong': candidate.long.toString(),
        // sstpl/iris
      });
    } else {
      await ApiClient()
          .postFormRequest(ApiEndpoints.syncStudentsVivaAndPracticleAnswers, {
        'assesmentId': candidate.assesmentId.toString(),
        'assesorFeedback': candidate.marksTitle.toString(),
        'assesorMarks': candidate.assesorMarks,
        'assessorId': candidate.assessorId,
        'questionId': candidate.questionId,
        'studentId': candidate.studentId,
        'videoUrl': "NA.mp4",
        'p_date': candidate.pDate,
        'p_start_time': candidate.pStartTime,
        'p_end_time': candidate.pEndTime,
        'v_date': candidate.vDate,
        'v_start_time': candidate.vStartTime,
        'v_end_time': candidate.vEndTime,
        // sstpl/iris
        'time': candidate.timeTaken.toString(),
        'latlong': candidate.long.toString(),
        // sstpl/iris
      });
    }
    return true;
  }

  Future<bool> oneCandidateVivaAndPracticalDocuments(
      CandidateModel candidate) async {
    var candidateJsonData = json.encode({
      "type": candidate.type,
      "assessorId": int.parse(candidate.assessorId ?? ""),
      "assmentId": int.parse(AppConstants.assesmentId ?? ""),
      "aadharFront":
          "${AppConstants.imageUploadUrl}${candidate.candidateAadharFront!.replaceFirst(AppConstants.replacementPath, "")}",
      "aadharBack": candidate.candidateAadharBack != "NA" &&
              candidate.candidateAadharBack != "" &&
              candidate.candidateAadharBack != null
          ? "${AppConstants.imageUploadUrl}${candidate.candidateAadharBack!.replaceFirst(AppConstants.replacementPath, "")}"
          : "NA",
      "profilePhoto":
          "${AppConstants.imageUploadUrl}${candidate.candidateProfile!.replaceFirst(AppConstants.replacementPath, "")}",
      "studentId": candidate.candidateId,
      "latitude": candidate.latitude,
      "longitude": candidate.longitude
    });

    try {
      // Storing Students Documents to the Server
      await ApiClient().uploadImageToServer(candidate.candidateAadharFront);
      if (candidate.candidateAadharBack != "NA" &&
          candidate.candidateAadharBack != "" &&
          candidate.candidateAadharBack != null) {
        await ApiClient().uploadImageToServer(candidate.candidateAadharBack);
      }
      await ApiClient().uploadImageToServer(candidate.candidateProfile);

      await ApiClient()
          .post(ApiEndpoints.syncStudentDocuments, data: candidateJsonData);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isCandidateVivaAndPracticalsSynced(String candidateId) {
    for (int i = 0; i < _verifiedVivaCandidatesList.length; i++) {
      if (_verifiedVivaCandidatesList[i].candidateIds == candidateId) {
        return true;
      }
    }
    return false;
  }

  getTheCompletedVivaVerificationList() async {
    _verifiedVivaCandidatesList = [];
    _verifiedVivaCandidatesList =
        await DatabaseHelper().getVivaSyncingVerifications();
    print(
        "Length of the Completed Viva & Practical ${_verifiedVivaCandidatesList.length}");
    update();
  }

  List<CandidateDetails> _completedMcqListOnline = [];
  List<CandidateDetails> get completedMcqListOnline => _completedMcqListOnline;

  Future<bool> getOnlineAssessmentTakenList(String id) async {
    _completedMcqListOnline = [];
    _isLoadingResponse = true;
    update();

    print("Printing Assessment Id Here: $id");

    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getCompletedCandidateList}${AppConstants.assesmentId}");

      print("Printing Response: $response");

      OnlineSyncedCandidateDataModel onlineSyncedCandidateDataModel =
          OnlineSyncedCandidateDataModel.fromJson(response);
      if (response.isNotEmpty) {
        if (onlineSyncedCandidateDataModel.row == 1) {
          _completedMcqListOnline.addAll(onlineSyncedCandidateDataModel.result
              as Iterable<CandidateDetails>);
          print(
              "Total Data Received Of Candidates: ${_completedMcqListOnline.length}");
          update();
        } else {
          // CustomSnackBar.customSnackBar(false, "No Candidate Data found");
        }
        _isLoadingResponse = false;
        update();
        return true;
      } else {
        _isLoadingResponse = false;
        update();
        CustomSnackBar.customSnackBar(false, "Something went wrong!");

        return false;
      }
    } catch (e) {
      CustomSnackBar.customSnackBar(false, "Something went wrong!");
      _isLoadingResponse = false;
      update();
      return false;
    }
  }

  // Added Line of Code one by one
  Future<void> syncVivaAndPracicalOnlySpecificCandidate(
      String candidateId) async {
    Get.find<CandidateOnboardingController>().changeIsSyncingData(true);

    try {
      print(
          "-------------------------- SYNCING ONE CANDIDATE DOCUMENTS --------------------------");

      // loading indicator for documents
      DatabaseHelper dbHelper = DatabaseHelper();
      List<CandidateModel> temporaryList = await dbHelper.getCandidates();
      for (var i = 0; i < temporaryList.length; i++) {
        if (candidateId == temporaryList[i].candidateId) {
          await oneCandidateVivaAndPracticalDocuments(temporaryList[i]);
        }
      }

      print(
          "-------------------------- SYNCING ONE CANDIDATE VIVA --------------------------");

      List<AssessorQuestionAnswersReplyModel>
          databaseVivaRecordedInsertedAnswers =
          await dbHelper.getCandidatesVivaAnswers();
      for (var i = 0; i < databaseVivaRecordedInsertedAnswers.length; i++) {
        if (candidateId == databaseVivaRecordedInsertedAnswers[i].studentId) {
          await oneCandidateViva(databaseVivaRecordedInsertedAnswers[i]);
        }
      }

      print(
          "-------------------------- SYNCING ONE CANDIDATE PRACICALS --------------------------");

      List<AssessorQuestionAnswersReplyModel>
          databasePracticalsRecordedInsertedAnswers =
          await dbHelper.getCandidatesPracticleAnswers();
      for (var i = 0;
          i < databasePracticalsRecordedInsertedAnswers.length;
          i++) {
        if (candidateId ==
            databasePracticalsRecordedInsertedAnswers[i].studentId) {
          await oneCandidatePacticals(
              databasePracticalsRecordedInsertedAnswers[i]);
        }
      }
      // step wise marking code
      print(
          "-------------------------- SYNCING ONE CANDIDATE PRACICALS VIVA STEPS MARKS --------------------------");

      List<QuestionStepMarkingAnswerModel>
          temporaryPracticalAndVivaStepAnswersList =
          await dbHelper.getAllStepAnswers();
      for (var i = 0;
          i < temporaryPracticalAndVivaStepAnswersList.length;
          i++) {
        if (candidateId ==
                temporaryPracticalAndVivaStepAnswersList[i].candidateId &&
            temporaryPracticalAndVivaStepAnswersList[i].answerType == "p") {
          await oneCandidatePracticalStepMarksSync(
              temporaryPracticalAndVivaStepAnswersList[i]);
        }
      }

      for (var i = 0;
          i < temporaryPracticalAndVivaStepAnswersList.length;
          i++) {
        if (candidateId ==
                temporaryPracticalAndVivaStepAnswersList[i].candidateId &&
            temporaryPracticalAndVivaStepAnswersList[i].answerType == "v") {
          await oneCandidateVivaStepMarksSync(
              temporaryPracticalAndVivaStepAnswersList[i]);
        }
      }
      // step wise marking code

      Get.find<CandidateOnboardingController>().changeIsSyncingData(false);
      Get.find<CandidateOnboardingController>()
          .setCurrentSyncingCandidateIndex(null);
    } catch (e) {
      print(e);
      Get.find<CandidateOnboardingController>().changeIsSyncingData(false);
      Get.find<CandidateOnboardingController>()
          .setCurrentSyncingCandidateIndex(null);
    }

    // await Get.find<CandidateOnboardingController>()
    //     .getAllCandidatesPracticalAndVivaSyncStatus();
  }

// Added Line of Code one by one

  Future<void> syncVivaAndPracticalOnlyOneCanddidateDocumentsOnline(
      String candidateId) async {
    Get.find<CandidateOnboardingController>().changeIsSyncingData(true);

    try {
      print(
          "-------------------------- SYNCING ONE CANDIDATE DOCUMENTS ONLY --------------------------");

      // loading indicator for documents
      DatabaseHelper dbHelper = DatabaseHelper();
      List<CandidateModel> temporaryList = await dbHelper.getCandidates();
      for (var i = 0; i < temporaryList.length; i++) {
        if (candidateId == temporaryList[i].candidateId) {
          await oneCandidateVivaAndPracticalDocuments(temporaryList[i]);
        }
      }
    } catch (e) {
      print(e);
      Get.find<CandidateOnboardingController>().changeIsSyncingData(false);
      Get.find<CandidateOnboardingController>()
          .setCurrentSyncingCandidateIndex(null);
    }
  }

// Trendsetters Code

  Future<void> importFeedbackQuestion(String assessmentId) async {
    try {
      Map<String, dynamic> response = await ApiClient().postFormRequest(
          ApiEndpoints.getFeedbackFormQuestions, {'assmentId': assessmentId});

      FeedbackFormQuestionsListModel feedbackFormQuestionsListModel =
          FeedbackFormQuestionsListModel.fromJson(response);

      List<FeedbackQuestionModel> tempList = [];

      if (feedbackFormQuestionsListModel.questions!.isNotEmpty) {
        tempList.addAll(feedbackFormQuestionsListModel.questions
            as Iterable<FeedbackQuestionModel>);
        update();
        await DatabaseHelper().insertFeedbackQuestions(tempList);

        List<FeedbackQuestionModel> list2 =
            await DatabaseHelper().getFeedbackQuestions();
        print("Feedback Form Question Received From Database: ${list2.length}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to Get the FeedbackQuestions");
      print("Exception Occured while importing Available Options");
    }
  }

  Future<void> importAvailabeVivaPracticalOptions(String assessmentId) async {
    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getAvailableVivaPracticalOptions}?assmentId=$assessmentId");

      VivaPracticalMarkingListModel vivaPracticalMarkingListModel =
          VivaPracticalMarkingListModel.fromJson(response);

      if (vivaPracticalMarkingListModel.scheme!.isNotEmpty) {
        for (var obj in response['scheme']) {
          await DatabaseHelper().insertVivaPracticalMarking(
              VivaPracticalMarkingModel.fromJson(obj));
        }
      }
      print(
          "Total Marking List Imported: ${vivaPracticalMarkingListModel.scheme!.length.toString()}");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to Get the Options");
      print("Exception Occured while importing Available Options");
    }
  }

  Future<bool> importAllAvailableLanguages(String assessmentId) async {
    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getAllLanguagesAvailabeMcq}assmentId=$assessmentId");

      if (response['result'] == 1) {
        AssessmentAllLanguagesListModel assessmentAllLanguagesListModel =
            AssessmentAllLanguagesListModel.fromJson(response);
        List<AssessmentAvailableLanguageModel> tempLanguageList = [];
        tempLanguageList.addAll(assessmentAllLanguagesListModel.languages
            as Iterable<AssessmentAvailableLanguageModel>);
        if (tempLanguageList.isNotEmpty) {
          for (int i = 0; i < tempLanguageList.length; i++) {
            await DatabaseHelper().insertMcqLanguage(tempLanguageList[i]);
          }
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      print("Exception Occured while importing the Available Languages");
      return false;
    }
  }

  Future<void> importAllAvailableLanguagesMcqQuestionsAndOptions(
      String masterQId, String questionId) async {
    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getAllLanguagesAvailabeMcqWithQuestionsAndOptions}masterqid=$masterQId&question_id=$questionId");

      if (response['result'] == 1) {
        ReferenceLanguageTableModel referenceLanguageTableModel =
            ReferenceLanguageTableModel.fromJson(response);
        List<MCQuestionsLanguageQuestion> tempReferenceLanguageList = [];
        tempReferenceLanguageList.addAll(referenceLanguageTableModel.mQuestions
            as Iterable<MCQuestionsLanguageQuestion>);
        if (tempReferenceLanguageList.isNotEmpty) {
          for (int i = 0; i < tempReferenceLanguageList.length; i++) {
            await DatabaseHelper()
                .insertMcqLanguageQuestion(tempReferenceLanguageList[i]);
          }
        }
      }
    } catch (e) {
      print("Exception Occured while importing the Available Languages");
    }
  }

  // code for checking already synced candidates data

  List<String> _completedPVSyncedCandidatesList = [];
  List<String> get completedPVSyncedCandidatesList =>
      _completedPVSyncedCandidatesList;

  Future<void> getOnlyPVSyncedCandidatesList() async {
    List<CandidateTotalAnswerSyncedCountModel> tempCountList = [];
    _completedPVSyncedCandidatesList = [];

    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getTotalAnswerSyncedOfCandidates}assmentId=${AppConstants.assesmentId}&ptype=1");

      for (var i in response['data']) {
        tempCountList.add(CandidateTotalAnswerSyncedCountModel(
            cnt: i['cnt'], userId: i['user_id']));
      }

      if (tempCountList.isNotEmpty) {
        for (int i = 0; i < tempCountList.length; i++) {
          if (await isTotalServerPVSyncedAndLocalDatabaseMatched(
                  tempCountList[i].userId.toString(),
                  int.parse(tempCountList[i].cnt.toString())) ==
              true) {
            _completedPVSyncedCandidatesList
                .add(tempCountList[i].userId.toString());
          }
        }
        update();
        print(
            "Total Successfully Synced Candidatees: ${_completedPVSyncedCandidatesList.length}");
      }
    } catch (e) {
      print("Exception Occured while Getting Synced MCQ Answers");
      Fluttertoast.showToast(msg: "Failed to get already Synced Candidates.");
    }
  }

  Future<bool?> isTotalServerPVSyncedAndLocalDatabaseMatched(
      String userId, int serverCount) async {
    int vivaInserted = 0;
    int practicalInserted = 0;

    List<AssessorQuestionAnswersReplyModel> tempCandidatesVivaInsertedAnswers =
        await DatabaseHelper().getCandidatesVivaAnswers();

    List<AssessorQuestionAnswersReplyModel>
        tempCandidatesPracticalInsertedAnswers =
        await DatabaseHelper().getCandidatesPracticleAnswers();

    for (int i = 0; i < tempCandidatesVivaInsertedAnswers.length; i++) {
      if (tempCandidatesVivaInsertedAnswers[i].studentId == userId) {
        vivaInserted++;
      }
    }

    for (int i = 0; i < tempCandidatesPracticalInsertedAnswers.length; i++) {
      if (tempCandidatesPracticalInsertedAnswers[i].studentId == userId) {
        practicalInserted++;
      }
    }

    if (vivaInserted + practicalInserted == 0) {
      return null;
    }
    if (serverCount == vivaInserted + practicalInserted) {
      return true;
    }
    return false;
  }

  // code for checking already synced candidates data

  List<String> _groupTestType = [];
  List<String> get groupTestType => _groupTestType;

  List<Batches> _selectedCandidatesGroupList = [];
  List<Batches> get selectedCandidatesGroupList => _selectedCandidatesGroupList;

  String? _selectedExamType;
  String? get selectedExamType => _selectedExamType;

  // group pratical viva code
  addToSelectedCandidates(Batches candidate) {
    _selectedCandidatesGroupList.add(candidate);
    update();
    print(_selectedCandidatesGroupList.length);
  }

  removeFromSelectedCandidates(Batches candidate) {
    _selectedCandidatesGroupList.remove(candidate);
    update();
    print(_selectedCandidatesGroupList.length);
  }

  bool isCandidateAlreadyAddedToGroup(String id) {
    for (int i = 0; i < _selectedCandidatesGroupList.length; i++) {
      if (id == _selectedCandidatesGroupList[i].id) {
        return true;
      }
    }
    return false;
  }

  setListType() {
    _groupTestType = [];
    if (pQuestions.isNotEmpty) {
      _groupTestType.add("Practical");
    }
    // if (pQuestions.isNotEmpty && vQuestions.isNotEmpty) {
    //   _groupTestType.add("Practical");
    //   _groupTestType.add("Viva");
    // } else if (vQuestions.isNotEmpty) {
    //   _groupTestType.add("Viva");
    // } else if (pQuestions.isNotEmpty) {
    //   _groupTestType.add("Practical");
    // }
  }

  changeSelectedExamType(String? value) {
    _selectedCandidatesGroupList = [];
    _selectedExamType = value;
    update();
  }

  resetCandidatesGroup({isUpdateNeeded = false}) {
    _selectedCandidatesGroupList = [];
    if (isUpdateNeeded == true) {
      update();
    }
    // _selectedExamType = null;
  }

  // group pratical viva code

  // step wise marking code
  Future<void> importStepsOfSpecificQuestion(
      String assessmentId, String questionId) async {
    try {
      Map<String, dynamic> response = await ApiClient().postFormRequest(
          ApiEndpoints.getQuestionSteps,
          {'assmentId': assessmentId, 'qid': questionId});

      QuestStepsListModel questStepsListModel =
          QuestStepsListModel.fromJson(response);

      List<QuestionStepsModel> tempList = [];
      tempList = questStepsListModel.steps!;

      if (tempList.isNotEmpty) {
        for (int i = 0; i < tempList.length; i++) {
          DatabaseHelper().insertQuestionStep(tempList[i]);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to Get the Steps of the Questions");
      print("Exception Occured while importing Available Options");
    }
  }

  // step wise marking code

  Future<void> syncAllCandidatesFinalTime() async {
    print("================= SYNCING TIME =================");
    List<CandidateModel> temporaryList = [];
    temporaryList = await DatabaseHelper().getCandidates();

    for (int i = 0; i < temporaryList.length; i++) {
      await ApiClient().postFormRequest(ApiEndpoints.syncFinalCandidateTime, {
        'assesmentId': AppConstants.assesmentId,
        'studentId': temporaryList[i].candidateId,
      });
    }
  }

  Future<void> syncOneCandidateFinalTime(String candidateId) async {
    await ApiClient().postFormRequest(ApiEndpoints.syncFinalCandidateTime, {
      'assesmentId': AppConstants.assesmentId,
      'studentId': candidateId,
    });
  }

  List<MQuestions> tempMQuestionsList = [];
  List<VQuestions> tempVQuestionsList = [];
  List<PQuestions> tempPQuestionsList = [];

  getAllTemporaryQuestionsList() async {
    tempMQuestionsList = [];
    tempVQuestionsList = [];
    tempPQuestionsList = [];
    DatabaseHelper dbHelper = DatabaseHelper();
    tempMQuestionsList = await dbHelper.getMQuestions();
    print("MQuestions Length ==> ${tempMQuestionsList.length}");
    tempPQuestionsList = await dbHelper.getPQuestions();
    print("PQuestions Length ==> ${tempPQuestionsList.length}");
    tempVQuestionsList = await dbHelper.getVQuestions();
    print("VQuestions Length ==> ${tempVQuestionsList.length}");

    update();
  }

// Trendsetters Code

// Online Mode New Changes
  Future<void> syncOneCandidateDocumentsOnRunTime(Batches candidate) async {
    // One Candidate Documents Syncing Process
    List<CandidateSubmitDocumentsModel> candidateDocumentsList = [];
    candidateDocumentsList =
        await DatabaseHelper().getCandidatesSubmittedDocuments();
    update();
    for (int i = 0; i < candidateDocumentsList.length; i++) {
      if (candidateDocumentsList[i].candidateId == candidate.id) {
        await oneCandidateSyncMcqDocuments(
            candidateDocumentsList[i], candidate);
      }
    }
  }

  ServerDateTimeModel? _centerVideoDateTime;
  ServerDateTimeModel? get centerVideoDateTime => _centerVideoDateTime;

  getServerDateTimeMode() async {
    try {
      if (AppConstants.isOnlineMode == true) {
        _centerVideoDateTime = await AppConstants.getServerDateAndTime();
      } else {
        _centerVideoDateTime = ServerDateTimeModel(
            date: AppConstants.getCurrentDateFormatted(),
            time: AppConstants.getFormatedCurrentTime(DateTime.now()));
      }
      update();
    } catch (e) {
      print("Exception On Saving Time: $e");
      _centerVideoDateTime = ServerDateTimeModel(
          date: AppConstants.getCurrentDateFormatted(),
          time: AppConstants.getFormatedCurrentTime(DateTime.now()));
    }
  }

  Future<void> syncAssessorOneDocumentOnline(String title, String file) async {
    print(
        "-------------------------- SYNCING ASSESSOR $title ANNEXURE DOCUMENTS HERE --------------------------");

    try {
      // syncing image
      if (title == "Center Video") {
        await ApiClient().uploadVideoToServer(file);
      } else {
        await ApiClient().uploadImageToServer(file);
      }
      print(file.toString());

      // print(file.toString().replaceFirst("/file_picker", ""));

      await ApiClient().get(
          "${ApiEndpoints.syncAssessorAnnexureDocuments}assmentId=${int.parse(AppConstants.assesmentId.toString())}&title=$title&titleVal=${file.replaceFirst("/file_picker", "").replaceFirst(AppConstants.replacementPath, "")}&assessorId=${int.parse(AppConstants.assessorId.toString())}&lat=${AppConstants.locationInformation}&long=${AppConstants.latitude}, ${AppConstants.longitude}&time=${_centerVideoDateTime != null ? "${_centerVideoDateTime!.date},${_centerVideoDateTime!.time}" : "${AppConstants.getFormatedCurrentDate(DateTime.now())}, ${AppConstants.getFormatedCurrentTime(DateTime.now())}"}");

      await Get.find<QuestionAnswersController>()
          .getAssessorOnlineSubmittedDocumentsList();
      update();
    } catch (e) {
      CustomToast.showToast("Exception While Uploading Annexure Online");
      debugPrint("Exception While Uploading Annexure Online: $e");
    }
  }

  Future<void> deleteAssessorOneDocumentOnline(
    String title,
  ) async {
    print(
        "-------------------------- DELETING ASSESSOR $title ANNEXURE DOCUMENTS HERE --------------------------");

    try {
      await ApiClient().get(
          "${ApiEndpoints.deleteAssessorUploadedDocumentOnline}?assmentId=${AppConstants.assesmentId.toString()}&title=$title");
      await Get.find<QuestionAnswersController>()
          .getAssessorOnlineSubmittedDocumentsList();
      update();
    } catch (e) {
      CustomToast.showToast("Exception While Uploading Annexure Online");
      debugPrint("Exception While Uploading Annexure Online: $e");
    }
  }

// Online Mode New Changes

  // sstpl/iris
  ServerDateTimeModel? _currentPracticalVivaTime;
  ServerDateTimeModel? get currentPracticalVivaTime =>
      _currentPracticalVivaTime;
  // sstpl/iris

  getCurrentDateTimeModeSpecific() async {
    try {
      if (AppConstants.isOnlineMode == true) {
        _currentPracticalVivaTime = await AppConstants.getServerDateAndTime();
      } else {
        _currentPracticalVivaTime = ServerDateTimeModel(
            date: AppConstants.getCurrentDateFormatted(),
            time: AppConstants.getFormatedCurrentTime(DateTime.now()));
      }
      update();
    } catch (e) {
      print("Exception On Saving Time: $e");
      _currentPracticalVivaTime = ServerDateTimeModel(
          date: AppConstants.getCurrentDateFormatted(),
          time: AppConstants.getFormatedCurrentTime(DateTime.now()));
    }
  }
}
