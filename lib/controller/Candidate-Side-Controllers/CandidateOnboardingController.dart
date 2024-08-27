import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/common-components/tensor-flow-components/camera_view.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/AuthController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/AssesmentQuestionsModel.dart';
import 'package:mytat/model/AssessmentAllLanguagesListModel.dart';
import 'package:mytat/model/CandidateExamTimeModel.dart';
import 'package:mytat/model/CandidateSubmitDocumentsModel.dart';
import 'package:mytat/model/FeedbackAnswersModel.dart';
import 'package:mytat/model/FeedbackFormQuestionsListModel.dart';
import 'package:mytat/model/LanguageModel.dart';
import 'package:mytat/model/Online-Models/OnlineGetCompletedCandidateModel.dart';
import 'package:mytat/model/Online-Models/OnlineLoginCandidateModel.dart';
import 'package:mytat/model/Online-Models/ServerDateTimeModel.dart';
import 'package:mytat/model/ReferenceLanguageTableModel.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorQuestionAnswerReplyModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateMCQAnswersModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateScreenshotUploadModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateTotalAnswerSyncedCountModel.dart';
import 'package:mytat/model/TotalDataSyncedListModel.dart';
import 'package:mytat/utilities/ApiClient.dart';
import 'package:mytat/utilities/ApiEndpoints.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';
import 'package:mytat/view/Authorization/login_type_screen.dart';
import 'package:mytat/view/candidate_feedback_form.dart';
import 'package:mytat/view/user_mode_screen.dart';

import '../../services/db_helper.dart';
import 'package:image/image.dart' as img;

class CandidateOnboardingController extends GetxController
    with WidgetsBindingObserver {
  String? _currentCandidateAdharFrontPic;
  String? get currentCandidateAdharFrontPic => _currentCandidateAdharFrontPic;

  String? _currentCandidateAdharBackPic;
  String? get currentCandidateAdharBackPic => _currentCandidateAdharBackPic;

  String? _currentCandidateProfilePhoto;
  String? get currentCandidateProfilePhoto => _currentCandidateProfilePhoto;

  String? _currentSelectedAnswer;
  String? get currentSelectedAnswer => _currentSelectedAnswer;

  DurationModel? _assessmentDurationInformation;
  DurationModel? get assessmentDurationInformation =>
      _assessmentDurationInformation;

  List<MQuestions> _mcqQuestions = [];
  List<MQuestions> get mcqQuestions => _mcqQuestions;

  MQuestions? _currentMcqQuestion;
  MQuestions? get currentMcqQuestion => _currentMcqQuestion;

  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;

  int? _attemptedQuestions;
  int? get attemptedQuestions => _attemptedQuestions;

  String? _currentSelectedOption;
  String? get currentSelectedOption => _currentSelectedOption;

  Batches? _presentCandidate;
  Batches? get presentCandidate => _presentCandidate;

  List<McqAnswers> _candidateAnswersList = [];
  List<McqAnswers> get candidateAnswersList => _candidateAnswersList;

  late CameraController _cameraController;
  CameraController get cameraController => _cameraController;

  List<CandidateScreenshotUploadModel> _clickedPhotosList = [];
  List<CandidateScreenshotUploadModel> get clickedPhotosList =>
      _clickedPhotosList;

  // document variables
  bool _isFileClicked = false;
  bool get isFileClicked => _isFileClicked;

  String? _currentClickedFile;
  String? get currentClickedFile => _currentClickedFile;

  bool _showSaveButton = false;
  bool get showSaveButton => _showSaveButton;

  bool _isClickingPhoto = false;
  bool get isClickingPhoto => _isClickingPhoto;

  bool _isSyncingStudentRecord = false;
  bool get isSyncingStudentRecord => _isSyncingStudentRecord;

  // variables for tracking the syncing progress

  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;

  String _syncingTitle = "";
  String get syncingTitle => _syncingTitle;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  bool _isAnswerChanged = false;
  bool get isAnswerChanged => _isAnswerChanged;

  bool _isSummaryAnswerChanged = false;
  bool get isSummaryAnswerChanged => _isSummaryAnswerChanged;

  bool _isAnswerChangedUsingPrevious = false;
  bool get isAnswerChangedUsingPrevious => _isAnswerChangedUsingPrevious;

  bool _isLoadingNextQuestion = false;
  bool get isLoadingNextQuestion => _isLoadingNextQuestion;

  // variables for tracking the syncing progress

  Timer? _timer;

  String webProctoring = "";
  String assessmentId = "";
  String assessmentName = "";
  String imageInterval = "";
  String mandatodyQuestions = "";
  String moveForward = "";
  String numberTabsSwitchAllowed = "";
  String tabSwitchAllowed = "";
  String randomQuestions = "";
  String vernacularLanguage = "";
  String testDuration = "";
  String tensorFlow = "";
  String accessLocation = "";
  String screenshare = "";

  String candidateEnrollment = "";

  int _markForReview = 0;
  int get markForReview => _markForReview;

  // bool _disableTensorFlowTemporary = false;
  // bool get disableTensorFlowTemporary => _disableTensorFlowTemporary;

  setAccessLocation() async {
    DurationModel? tempassessmentDurationInformation =
        await DatabaseHelper().getDuration(AppConstants.assesmentId.toString());
    accessLocation = tempassessmentDurationInformation!.accessLocation ?? "Y";
    update();
  }

  Future<bool?> loginCandidateoffline(
      institutionId, enrollmentnumber, password) async {
    print("Institution id ==> $institutionId");
    print("Enrollment Number ==> $enrollmentnumber");
    print("Password ==> $password");

    candidateEnrollment = enrollmentnumber;

    setAccessLocation();

    await Get.find<AssessorDashboardController>()
        .getAllCompletedStudentsMcqList();
    List<Batches> _tempList =
        Get.find<AssessorDashboardController>().completedStudentsMcqList;
    _presentCandidate = await DatabaseHelper()
        .getCandidateDetailsFromDb(institutionId, enrollmentnumber, password);
    update();
    if (_presentCandidate != null) {
      for (int i = 0; i < _tempList.length; i++) {
        if (_tempList[i].id == presentCandidate!.id) {
          return null;
        }
      }
      print("Returning True!");

      return getIsCandidateAlreadyGivenViva(_presentCandidate!.id!);
      // return true;
    }
    return false;
  }

  Future<bool> loadMcqQuestionsFromDB() async {
    _mcqQuestions = [];
    _mcqQuestions = await DatabaseHelper().getMQuestions();
    if (_mcqQuestions.isNotEmpty) {
      _currentMcqQuestion = _mcqQuestions[_currentQuestionIndex];
      _attemptedQuestions = 0;
      update();
      _assessmentDurationInformation = await DatabaseHelper()
          .getDuration(AppConstants.assesmentId.toString());

      return true;
    }
    update();
    return false;
  }

  nextQuestion() {
    ++_currentQuestionIndex;
    _currentMcqQuestion = _mcqQuestions[_currentQuestionIndex];
    loadCandidateAnswer();
    // set the answer value
    update();
  }

  setIsLoadingNextQuestion(bool value) {
    _isLoadingNextQuestion = value;
    update();
  }

  setCurrentMcqQuestion(int index) {
    _currentQuestionIndex = index;
    _currentMcqQuestion = _mcqQuestions[_currentQuestionIndex];
    loadCandidateAnswer();
    update();
  }

  changeAnswer() async {
    print("Change Answer Triggerred Here");
    _isAnswerChanged = true;
    await removeFromCandidateAnswerList(_currentMcqQuestion!);
    update();
  }

  previousQuestion() {
    --_currentQuestionIndex;
    _currentMcqQuestion = _mcqQuestions[_currentQuestionIndex];
    loadCandidateAnswer();
    update();
  }

  void loadCandidateAnswer() {
    _currentSelectedAnswer = getSelectedOption(
        getAnswer(_currentMcqQuestion!), _currentMcqQuestion!,
        isPrevious: true);
    print("Previous Loaded Answer is: $_currentSelectedAnswer");
    if (isMarkForReview(currentMcqQuestion ?? MQuestions()) == true) {
      _markForReview = 1;
    } else {
      _markForReview = 0;
    }
    update();
  }

  bool isAlreadyAnswered(MQuestions? question) {
    for (int i = 0; i < _candidateAnswersList.length; i++) {
      if (_candidateAnswersList[i].questionId == question!.id) {
        return true;
      }
    }
    return false;
  }

  // loadCandidateMarkForReviewStatus(McqAnswers? mcqAnswer) {
  //   for (int i = 0; i < mcqQuestions.length; i++) {
  //     if (mcqQuestions[i].id == mcqAnswer!.questionId) {
  //       _markForReviewSummary = mcqAnswer.markForReview;
  //       getSelectedOption(mcqAnswer.answerId, _currentChangeQuestion!);
  //       update();
  //     }
  //   }
  //   update();
  // }

// method to decode the image
  Future<Uint8List?> decodeImage(String base64String) async {
    try {
      List<int> bytes = base64.decode(base64String);
      final imageCodec = await instantiateImageCodec(Uint8List.fromList(
          bytes)); // Use instantiateImageCodec to decode the image
      final frameInfo = await imageCodec.getNextFrame();
      ByteData? byteData =
          await frameInfo.image.toByteData(format: ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      print("Error decoding image: $e");
      return null;
    }
  }

  setSelectedOption(String selectedOption, int index) {
    _currentSelectedAnswer = selectedOption;

    switch (index) {
      case 0:
        _currentSelectedOption = "A";
        break;
      case 1:
        _currentSelectedOption = "B";
        break;
      case 2:
        _currentSelectedOption = "C";
        break;
      case 3:
        _currentSelectedOption = "D";
        break;
      case 4:
        _currentSelectedOption = "E";
        break;
    }

    print("Current Selected Option Selected: $_currentSelectedOption");

    update();
  }

  clearAnswer() {
    _currentSelectedAnswer = null;
    _isAnswerChanged = false;

    update();
  }

  addToCandidateAnswersList(McqAnswers answer) {
    print("Adding to the list......");
    _candidateAnswersList.add(answer);

    print(_candidateAnswersList.length);
    print("Successfully added to the list......");
    update();
  }

  removeFromCandidateAnswerList(MQuestions question) {
    for (int i = 0; i < candidateAnswersList.length; i++) {
      if (candidateAnswersList[i].questionId == question.id) {
        _candidateAnswersList.remove(candidateAnswersList[i]);
      }
    }
    update();
  }

  setMarkForReview(int value) {
    _markForReview = value;
    update();
  }

  resetQuestionPaper() {
    _currentQuestionIndex = 0;
    update();
  }

  Future<bool> syncAnswerToLocalDB() async {
    int saveDataCount = 0;
    for (int i = 0; i < _candidateAnswersList.length; i++) {
      // timer value code
      // _candidateAnswersList[i].answerTime = formatTime(currentTime);
      // timer value code

      await DatabaseHelper().insertMcqAnswers(_candidateAnswersList[i]);

      saveDataCount = saveDataCount + 1;
    }

    print("Total New Answers Submitted: $saveDataCount");

    if (saveDataCount == _candidateAnswersList.length) {
      update();
      _candidateAnswersList = [];
      return true;
    } else {
      update();
      return false;
    }
  }

  String formatTime(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  saveStudentDB(Batches candidate) async {
    Batches tempCandidate = Batches(
        assmentId: candidate.assmentId,
        enrollmentNo: candidate.enrollmentNo,
        id: candidate.id,
        institutionID: candidate.institutionID,
        isPracticalDone: candidate.isPracticalDone,
        isTheoryDone: "Y",
        isVivaDone: candidate.isVivaDone,
        name: candidate.name,
        pImg: candidate.pImg,
        password: candidate.password,
        userEmail: candidate.userEmail,
        vImg: candidate.vImg);
    await DatabaseHelper().insertCompletedMcqStudent(tempCandidate);
  }

  syncCandidatesScreenshotsToDB() async {
    for (int i = 0; i < _clickedPhotosList.length; i++) {
      DatabaseHelper().insertCandidateScreenshot(_clickedPhotosList[i]);
    }
    List<CandidateScreenshotUploadModel> tempList =
        await DatabaseHelper().getCandidateScreenshots();

    print("Total Screenshot Save to The Database: ${tempList.length}");
  }

  // method for syncing the data
  Future<bool> syncMcqAnswersOfCandidates() async {
    print(
        "-------------------------- SYNCING MCQ ANSWERE HERE --------------------------");

    // loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Student MCQ's";
    update();
    // loading indicator for documents

    // getting list from the database
    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      List<McqAnswers> allStudentsMcqAnswers =
          await dbHelper.getAllCandidatesMcqAnswers();

      if (allStudentsMcqAnswers.isEmpty) {
        CustomSnackBar.customSnackBar(true, "No Data for Students found!");
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return true;
      } else {
        for (int i = 0; i < allStudentsMcqAnswers.length; i++) {
          if (completedSyncedCandidatesList
                  .contains(allStudentsMcqAnswers[i].candidateId) ==
              false) {
            var response = await ApiClient().post(
                "${ApiEndpoints.syncStudentMcqAnswers}assmentId=${allStudentsMcqAnswers[i].assessmentId}&userId=${allStudentsMcqAnswers[i].candidateId}&questId=${allStudentsMcqAnswers[i].questionId}&userAns=${allStudentsMcqAnswers[i].answerId}&anstime=${allStudentsMcqAnswers[i].answerTime}");
            print("Total Answer Synced Here: $i $response");
          }

          // loading indicator for documents
          _uploadProgress = (i + 1) / allStudentsMcqAnswers.length;
          update();
          // loading indicator for documents
        }
        // await syncCompletedMcqStudents();
        // await syncCompletedMcqStudentsScreenshots();

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

  Future<void> syncCompletedMcqStudents() async {
    print(
        "-------------------------- SYNCING STUDENTS --------------------------");

    // loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Student MCQ's";
    update();
    // loading indicator for documents
    // getting list from the database
    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      List<Batches> allCompletedMcqBatch =
          await dbHelper.getAllCompletedMcqStudents();

      if (allCompletedMcqBatch.isEmpty) {
        CustomSnackBar.customSnackBar(true, "No Data for Students found!");
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
      } else {
        for (int i = 0; i < allCompletedMcqBatch.length; i++) {
          if (completedSyncedCandidatesList
                  .contains(allCompletedMcqBatch[i].id) ==
              false) {
            print(
                "Deleting the Record for the ${allCompletedMcqBatch[i].id} for assessment ${allCompletedMcqBatch[i].assmentId}");
            // exam date time code
            CandidateExamTimeModel? candidateExamTimeModel =
                await getExamDateTimeOfCandidate(
                    allCompletedMcqBatch[i].id.toString());
            // exam date time code

            var response = await ApiClient().postFormRequest(
                ApiEndpoints.syncStudentMcqAnswersCompleteSync, {
              'assmentId': allCompletedMcqBatch[i].assmentId,
              'userId': allCompletedMcqBatch[i].id,
              'date': candidateExamTimeModel != null
                  ? candidateExamTimeModel.date
                  : "",
              'start_time': candidateExamTimeModel != null
                  ? candidateExamTimeModel.startTime
                  : "",
              'end_time': candidateExamTimeModel != null
                  ? candidateExamTimeModel.endTime
                  : "",
              'tab_switch': candidateExamTimeModel != null
                  ? candidateExamTimeModel.switchCount.toString()
                  : "0"
            });

            // exam time code added
            await Get.find<AssessorDashboardController>()
                .syncOneCandidateFinalTime(
                    allCompletedMcqBatch[i].id.toString());
            // exam time code added

            print("Total Answer Synced Here: $i $response");
          }
          // loading indicator for documents
          _uploadProgress = (i + 1) / allCompletedMcqBatch.length;
          update();
          // loading indicator for documents
        }
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
      }
    } catch (e) {
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      debugPrint("Exception: $e");
    }
    update();
  }

  // exam date time code
  List<CandidateExamTimeModel> _candidateExamDateTimeList = [];
  List<CandidateExamTimeModel> get candidateExamDateTimeList =>
      _candidateExamDateTimeList;

  Future<CandidateExamTimeModel?> getExamDateTimeOfCandidate(
      String userId) async {
    _candidateExamDateTimeList = [];
    _candidateExamDateTimeList = await DatabaseHelper().getAllExamTimes();
    for (int i = 0; i < _candidateExamDateTimeList.length; i++) {
      if (_candidateExamDateTimeList[i].userId == userId) {
        return _candidateExamDateTimeList[i];
      }
    }
    return null;
  }
  // exam date time code

  Future<void> syncCompletedMcqStudentsScreenshots() async {
    print(
        "-------------------------- SYNCING STUDENTS SCREEENSHOTS HERE --------------------------");

// loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Student MCQ's Screenshots";
    update();
    // loading indicator for documents
    // getting list from the database
    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      List<CandidateScreenshotUploadModel> allCandidatesScreenshots =
          await dbHelper.getCandidateScreenshots();

      if (allCandidatesScreenshots.isEmpty) {
        CustomSnackBar.customSnackBar(true, "No Screenshots found!");
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
      } else {
        for (int i = 0; i < allCandidatesScreenshots.length; i++) {
          if (completedSyncedCandidatesList
                  .contains(allCandidatesScreenshots[i].userId) ==
              false) {
            if (allCandidatesScreenshots[i].assmentId != "") {
              var response = await ApiClient().get(
                  "${ApiEndpoints.syncStudentsMcqScreenshots}assmentId=${int.parse(allCandidatesScreenshots[i].assmentId ?? "")}&userId=${int.parse(allCandidatesScreenshots[i].userId ?? "")}&userimg=${allCandidatesScreenshots[i].userimg!.replaceFirst(AppConstants.replacementPath, "")}&facecount=${allCandidatesScreenshots[i].faceCount}&imgTime=${allCandidatesScreenshots[i].dateTime}");
              // syncing image
              await ApiClient().uploadScreenshotToServer(
                  allCandidatesScreenshots[i].userimg,
                  allCandidatesScreenshots[i].assmentId ?? "",
                  allCandidatesScreenshots[i].userId ?? "");
              print("Total Screenshots Synced Here: $i $response");
            }
          }

          // loading indicator for documents
          _uploadProgress = (i + 1) / allCandidatesScreenshots.length;
          update();
          // loading indicator for documents
        }
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
      }
    } catch (e) {
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      debugPrint("Exception: $e");
    }
    update();
  }

  setBaseDurationVariables(Batches candidate) {
    webProctoring = assessmentDurationInformation!.webProctoring ?? "";
    assessmentId = assessmentDurationInformation!.assmentId ?? "";
    assessmentName = assessmentDurationInformation!.assmentName ?? "";
    imageInterval = assessmentDurationInformation!.imgInterval ?? "";
    mandatodyQuestions = assessmentDurationInformation!.mandatoryQuestion ?? "";
    moveForward = assessmentDurationInformation!.moveForward ?? "";
    numberTabsSwitchAllowed =
        assessmentDurationInformation!.numberTabSwitchesAllowed ?? "";
    tabSwitchAllowed = assessmentDurationInformation!.tabSwitchesAllowed ?? "";
    randomQuestions = assessmentDurationInformation!.randomQuestions ?? "";
    vernacularLanguage =
        assessmentDurationInformation!.vernacularLanguage ?? "";
    testDuration = assessmentDurationInformation!.testDuration ?? "";
    tensorFlow = assessmentDurationInformation!.tensorflow ?? "";
    accessLocation = assessmentDurationInformation!.accessLocation ?? "";
    screenshare = assessmentDurationInformation!.screenshare ?? "";
    _isSummaryAnswerChanged = false;
    _isAnswerChangedUsingPrevious = false;
    // _disableTensorFlowTemporary = false;

    // new points
    switchCount = 0;
    currentOngoingCandidate = candidate;
    // new points

    print(assessmentDurationInformation!.webProctoring);
    print(assessmentDurationInformation!.assmentId);
    print(assessmentDurationInformation!.assmentName);
    print(assessmentDurationInformation!.imgInterval);
    print(assessmentDurationInformation!.mandatoryQuestion);
    print(assessmentDurationInformation!.moveForward);
    print(assessmentDurationInformation!.numberTabSwitchesAllowed);
    print(assessmentDurationInformation!.tabSwitchesAllowed);
    print(assessmentDurationInformation!.randomQuestions);
    print(assessmentDurationInformation!.testDuration);
    print(assessmentDurationInformation!.vernacularLanguage);
    print(assessmentDurationInformation!.tensorflow);
    print(assessmentDurationInformation!.screenshare);

    print(switchCount);

    update();
  }

  clearBaseDurationVariables() {
    webProctoring = "";
    assessmentId = "";
    assessmentName = "";
    imageInterval = "";
    mandatodyQuestions = "";
    moveForward = "";
    numberTabsSwitchAllowed = "";
    tabSwitchAllowed = "";
    randomQuestions = "";
    vernacularLanguage = "";
    testDuration = "";
    tensorFlow = "";
    accessLocation = "";
    screenshare = "";
    _clickedPhotosList = [];

    // exam date time code
    _candidateStartDate = "";
    _candidateEndTime = "";
    _candidateStartTime = "";
    switchCount = 0;
    _isSummaryAnswerChanged = false;
    _isAnswerChangedUsingPrevious = false;

    currentOngoingCandidate = null;
    // exam date time code

    candidateEnrollment = "";
    _fontSize = 16.0;

    // _disableTensorFlowTemporary = false;

    update();
  }

// camera functionalities
  void closeCamera() async {
    Future.delayed(const Duration(seconds: 2), () {
      _cameraController.dispose();
    });
    update();
  }

  Future<void> initializeCamera(int? cameraToshow) async {
    final cameras = await availableCameras();
    _cameraController =
        CameraController(cameras[cameraToshow ?? 0], ResolutionPreset.high);
    await _cameraController.initialize();
    update();
  }

  Future<String?> takePicture(
      {bool isAutomatic = false, bool isWatermarkNeeded = true}) async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    try {
      _isClickingPhoto = true;
      update();
      await _cameraController.setFocusMode(FocusMode.locked);
      await _cameraController.setExposureMode(ExposureMode.locked);

      final picture = await _cameraController.takePicture();

      await _cameraController.setFocusMode(FocusMode.auto);
      await _cameraController.setExposureMode(ExposureMode.auto);
      // final picture = await _cameraController.takePicture();
      _currentClickedFile = picture.path;

      // adding watermark
      // await Get.find<SplashController>().getLocation();
      // if (isWatermarkNeeded == true) {
      await addWatermarkToImage(_currentClickedFile!,
          isAllWatermarkNeeded: isWatermarkNeeded);
      // }
      // adding watermark

      if (isAutomatic == true) {
        CandidateScreenshotUploadModel newImage =
            CandidateScreenshotUploadModel(
                assmentId: assessmentId,
                userId: _presentCandidate!.id,
                userimg: picture.path,
                // date time of server
                dateTime: AppConstants.photoWatermarkText3);
        _clickedPhotosList.add(newImage);
      }
      _isClickingPhoto = false;
      changeShowButtonVisibility();
      update();
      return picture.path;
    } catch (e) {
      _isClickingPhoto = false;

      debugPrint('Error taking picture: $e');
      update();
      return null;
    }
  }

  // add to the image list
  addToScreenShotImageList(
      CandidateScreenshotUploadModel candidateScreenshotUploadModel) {
    _clickedPhotosList.add(candidateScreenshotUploadModel);

    print("Length of Clicked Photo List: ${_clickedPhotosList.length}");
    update();
  }
  // add to the image list

  void startClickingPictures() {
    _timer = Timer.periodic(Duration(minutes: int.parse(imageInterval)),
        (Timer timer) {
      print(
          "------------------------- CLICKING PHOTO -------------------------");
      takePicture(isAutomatic: true);
      print("Overall Clicked Pictures Length: ${_clickedPhotosList.length}");
    });
  }

  void stopClickingPictures() {
    _timer?.cancel();
    update();
    print("Timer Cancelled...............");
  }

  // saving documents to the local
  void saveDocumentsToLocal(String fileName) async {
    if (_currentClickedFile != null) {
      switch (fileName) {
        case "Profile Photo":
          await setCurrentProfilePhoto();
          break;
        case "Aadhar Front":
          await setCurrentAdharFrontPhoto();
          break;
        case "Aadhar Back":
          await setCurrentAdharBackPhoto();
          break;
        default:
      }
    }

    _currentClickedFile = null;
    changeShowButtonVisibility();
    closeCamera();
    update();
  }

// setters methods
  setCurrentProfilePhoto() {
    _currentCandidateProfilePhoto = _currentClickedFile;
    update();
  }

  setCurrentAdharFrontPhoto() {
    _currentCandidateAdharFrontPic = _currentClickedFile;
    update();
  }

  setCurrentAdharBackPhoto() {
    _currentCandidateAdharBackPic = _currentClickedFile;
    update();
  }

  void changeShowButtonVisibility() {
    _showSaveButton = !_showSaveButton;
    _isFileClicked = !_isFileClicked;
    update();
  }

  void clearCandidateDocuments() {
    _currentCandidateProfilePhoto = null;
    _currentCandidateAdharBackPic = null;
    _currentCandidateAdharFrontPic = null;
    _currentClickedFile = null;
    update();
  }

  // Sync Data API's Starts here:
  Future<bool> syncStudentSubmittedDocuments() async {
    print("");
    DatabaseHelper dbHelper = DatabaseHelper();
    // loading indicator for documents
    _isSyncing = true;
    _syncingTitle = "Student Documents";
    update();
    // loading indicator for documents

    try {
      List<CandidateSubmitDocumentsModel> temporaryList =
          await dbHelper.getCandidatesSubmittedDocuments();
      if (temporaryList.isEmpty) {
        // CustomSnackBar.customSnackBar(true, "No Data for Students found!");
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        return true;
      } else {
        for (var i = 0; i < temporaryList.length; i++) {
          if (completedSyncedCandidatesList
                  .contains(temporaryList[i].candidateId) ==
              false) {
            var candidateJsonData = json.encode({
              "type": temporaryList[i].type,
              "assessorId": 0,
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
              "studentId": int.parse(temporaryList[i].candidateId ?? ""),
              "latitude": temporaryList[i].latitude,
              "longitude": temporaryList[i].longitude
            });

            // Storing Students Documents to the Server
            await ApiClient()
                .uploadImageToServer(temporaryList[i].candidateAadharFront);
            if (temporaryList[i].candidateAadharBack != "NA" &&
                temporaryList[i].candidateAadharBack != "" &&
                temporaryList[i].candidateAadharBack != null)
              await ApiClient()
                  .uploadImageToServer(temporaryList[i].candidateAadharBack);
            await ApiClient()
                .uploadImageToServer(temporaryList[i].candidateProfile);

            await ApiClient().post(ApiEndpoints.syncStudentDocuments,
                data: candidateJsonData);
          }

          // loading indicator for documents
          _uploadProgress = (i + 1) / temporaryList.length;
          update();
          // loading indicator for documents
        }
        // loading indicator for documents
        _isSyncing = false;
        _syncingTitle = "";
        _uploadProgress = 0.0;
        update();
        // loading indicator for documents
        return true;
      }
    } catch (e) {
      // loading indicator for documents
      _isSyncing = false;
      _syncingTitle = "";
      _uploadProgress = 0.0;
      update();
      // loading indicator for documents
      return false;
    }
  }

  // Answer Summary Handling Methods -->
  MQuestions? _currentChangeQuestion;
  MQuestions? get currentChangeQuestion => _currentChangeQuestion;

  McqAnswers? _lastAnswer;
  McqAnswers? get lastAnswer => _lastAnswer;

  String? _changedAnswserSelectedQuestion;
  String? get changedAnswserSelectedQuestion => _changedAnswserSelectedQuestion;

  int? _markForReviewSummary;
  int? get markForReviewSummary => _markForReviewSummary;

  setQuestionToChange(McqAnswers? mcqAnswer) {
    _lastAnswer = mcqAnswer;
    for (int i = 0; i < mcqQuestions.length; i++) {
      if (mcqQuestions[i].id == mcqAnswer!.questionId) {
        _currentChangeQuestion = mcqQuestions[i];
        _lastAnswer = mcqAnswer;
        _markForReviewSummary = mcqAnswer.markForReview;
        getSelectedOption(mcqAnswer.answerId, _currentChangeQuestion!);
        update();
      }
    }
    update();
  }

  String? getSelectedOption(String? optionSelected, MQuestions question,
      {bool isPrevious = false}) {
    switch (optionSelected) {
      case "A":
        {
          if (isPrevious) {
            return question.option1 != "" && question.option1 != "null"
                ? question.option1
                : "A${question.option1Img}";
          } else {
            _changedAnswserSelectedQuestion =
                question.option1 != "" && question.option1 != "null"
                    ? question.option1
                    : "A${question.option1Img}";
            update();
            break;
          }
        }

      case "B":
        if (isPrevious) {
          return question.option2 != "" && question.option2 != "null"
              ? question.option2
              : "B${question.option2Img}";
        } else {
          _changedAnswserSelectedQuestion =
              question.option2 != "" && question.option2 != "null"
                  ? question.option2
                  : "B${question.option2Img}";
          update();
          break;
        }
      case "C":
        if (isPrevious) {
          return question.option3 != "" && question.option3 != "null"
              ? question.option3
              : "C${question.option3Img}";
        } else {
          _changedAnswserSelectedQuestion =
              question.option3 != "" && question.option3 != "null"
                  ? question.option3
                  : "C${question.option3Img}";
          update();
          break;
        }
      case "D":
        if (isPrevious) {
          return question.option4 != "" && question.option4 != "null"
              ? question.option4
              : "D${question.option4Img}";
        } else {
          _changedAnswserSelectedQuestion =
              question.option4 != "" && question.option4 != "null"
                  ? question.option4
                  : "D${question.option4Img}";
          update();
          break;
        }

      case "E":
        if (isPrevious) {
          return question.option5 != "" && question.option5 != "null"
              ? question.option5
              : "E${question.option5Img}";
        } else {
          _changedAnswserSelectedQuestion =
              question.option5 != "" && question.option5 != "null"
                  ? question.option5
                  : "E${question.option5Img}";
          update();
          break;
        }
    }
    return null;
  }

  resetCurrentChangeQuestion() {
    _currentChangeQuestion = null;
    _lastAnswer = null;
    _changedAnswserSelectedQuestion = null;
    _markForReviewSummary = null;
    update();
  }

  changeAnswerMarkforReviewStatus(int value) {
    _markForReviewSummary = value;
    update();
  }

  changeSelectedOption(String selectedOption) {
    _changedAnswserSelectedQuestion = selectedOption;
    update();
  }

  saveAndChnageAnswer() {
    for (int i = 0; i < candidateAnswersList.length; i++) {
      if (candidateAnswersList[i].questionId == lastAnswer!.questionId) {
        candidateAnswersList[i].answerId = getCurrentOptionValue();
        candidateAnswersList[i].markForReview = _markForReviewSummary;
      }
      update();
    }
  }

  getCurrentOptionValue() {
    if (_changedAnswserSelectedQuestion == _currentChangeQuestion!.option1) {
      return "A";
    }
    if (_changedAnswserSelectedQuestion == _currentChangeQuestion!.option2) {
      return "B";
    }
    if (_changedAnswserSelectedQuestion == _currentChangeQuestion!.option3) {
      return "C";
    }
    if (_changedAnswserSelectedQuestion == _currentChangeQuestion!.option4) {
      return "D";
    }
    if (_changedAnswserSelectedQuestion == _currentChangeQuestion!.option5) {
      return "E";
    }
  }

  int getSummaryQuestionNumber(String questionId) {
    for (int i = 0; i < mcqQuestions.length; i++) {
      if (mcqQuestions[i].id == questionId) {
        return i + 1;
      }
    }
    return 0;
  }

  bool isAnswered(MQuestions question) {
    for (int i = 0; i < candidateAnswersList.length; i++) {
      if (candidateAnswersList[i].questionId == question.id) {
        return true;
      }
    }
    return false;
  }

  bool isMarkForReview(MQuestions question) {
    for (int i = 0; i < candidateAnswersList.length; i++) {
      if (candidateAnswersList[i].questionId == question.id &&
          candidateAnswersList[i].markForReview == 1) {
        return true;
      }
    }
    return false;
  }

  int getTotalMarkForReview() {
    int markForReviewListLength = 0;
    for (int i = 0; i < candidateAnswersList.length; i++) {
      if (candidateAnswersList[i].markForReview == 1) {
        markForReviewListLength++;
      }
    }
    return markForReviewListLength;
  }

  String? getAnswer(MQuestions question) {
    for (int i = 0; i < candidateAnswersList.length; i++) {
      if (candidateAnswersList[i].questionId == question.id) {
        return candidateAnswersList[i].answerId;
      }
    }
    return null;
  }

  McqAnswers? getQuestionToChange(MQuestions question) {
    for (int i = 0; i < candidateAnswersList.length; i++) {
      if (candidateAnswersList[i].questionId == question.id) {
        return candidateAnswersList[i];
      }
    }
    return null;
  }

  setNotAnsweredQuestionToChange(MQuestions? question) {
    _currentChangeQuestion = question;
    update();
  }

  Future<void> addWatermarkToImage(String imagePath,
      {bool isAllWatermarkNeeded = true}) async {
    if (AppConstants.isOnlineMode != true) {
      AppConstants.photoWatermarkText3 =
          Get.find<SplashController>().getCurrentDateTime();
    } else {
      ServerDateTimeModel? serverDateTimeModel =
          await AppConstants.getServerDateAndTime();
      if (serverDateTimeModel != null) {
        AppConstants.photoWatermarkText3 =
            "${serverDateTimeModel.date}, ${serverDateTimeModel.time}";
      }
    }

    final image = img.decodeImage(File(imagePath).readAsBytesSync());

    // Create a copy of the image to draw on
    final imageCopy =
        img.copyResize(image!, width: image.width, height: image.height);

    // Add text as watermark
    final font = img.arial_24; // Choose a font and size
    final color =
        img.getColor(255, 255, 255); // Choose text color (white in this case)
    final shadowColor =
        img.getColor(0, 0, 0, 100); // Choose shadow color (black with opacity)
    final text =
        AppConstants.photoWatermarkText; // Text to be added as watermark
    final text2 =
        AppConstants.photoWatermarkText2; // Text to be added as watermark
    final text3 =
        AppConstants.photoWatermarkText3; // Text to be added as watermark

    // Calculate watermark text position (you can adjust this based on your needs)
    const textX = 20; // Adjust the X position of the text
    final textY = imageCopy.height - 60; // Adjust the Y position of the text
    const textX2 = 20; // Adjust the X position of the text
    final textY2 = imageCopy.height - 30; // Adjust the Y position of the text
    const textX3 = 20; // Adjust the X position of the text
    final textY3 = isAllWatermarkNeeded == true
        ? imageCopy.height - 90
        : imageCopy.height - 30; // Adjust the Y position of the text

    // Draw the shadow text multiple times to create a bolder effect
    for (int i = 1; i <= 3; i++) {
      if (isAllWatermarkNeeded == true) {
        img.drawString(imageCopy, font, textX + i, textY + i, text,
            color: shadowColor);
        img.drawString(imageCopy, font, textX2 + i, textY2 + i, text2,
            color: shadowColor);
      }
      img.drawString(imageCopy, font, textX3 + i, textY3 + i, text3,
          color: shadowColor);
    }

    // Draw the actual text
    if (isAllWatermarkNeeded == true) {
      img.drawString(imageCopy, font, textX, textY, text, color: color);

      img.drawString(imageCopy, font, textX2, textY2, text2, color: color);
    }
    img.drawString(imageCopy, font, textX3, textY3, text3, color: color);

    // Save the new image with text watermark
    _currentClickedFile = imagePath;

    File(_currentClickedFile!).writeAsBytesSync(img.encodePng(imageCopy));
    update();
  }

  // getting the candidate languages options
  Languages? _selectedLanguage;
  Languages? get selectedLanguage => _selectedLanguage;

  final List<Languages> _languagesList = [];
  List<Languages> get languagesList => _languagesList;

  selectLanguage(value) {
    _selectedLanguage = value;
    AppConstants.countryCode = _selectedLanguage!.langcode ?? "en";
    update();
  }

  Future<void> getAllLanguages() async {
    try {
      Map<String, dynamic> response =
          await ApiClient().get(ApiEndpoints.getAllLangauages);

      LanguageModel languageModel = LanguageModel.fromJson(response);

      _languagesList.addAll(languageModel.languages as Iterable<Languages>);
      if (_languagesList.isNotEmpty) {
        _selectedLanguage = _languagesList[0];
        AppConstants.countryCode = 'en';
      }
      update();
    } catch (e) {
      debugPrint("Exception: $e");
    }
    update();
  }

  // Online Mode Mcq Uploading Methods and lists
  bool _isUploading = false;
  bool get isUploading => _isUploading;

  bool _isLoadingOnline = false;
  bool get isLoadingOnline => _isLoadingOnline;

  OnlineLoginCandidateModel? _onlineLoginCandidateModel;
  OnlineLoginCandidateModel? get onlineLoginCandidateModel =>
      _onlineLoginCandidateModel;

  changeOneCandidateUploadingStatus() {
    _isUploading = !_isUploading;
    update();
  }

  Future<bool?> loginCandidateOnline(
      String assessmentId, String enrollmentNumber, String password,
      {bool isClearDatabaseNeeded = true}) async {
    _isLoadingOnline = true;
    Get.find<AuthController>().changeIsLoadingResponse();
    candidateEnrollment = enrollmentNumber;
    update();

    // added line of code
    if (isClearDatabaseNeeded == true) {
      DatabaseHelper().clearDatabase();
    }
    // added line of code

    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.candidateOnlineLogin}assmentId=${int.parse(assessmentId)}&enrollmentNo=$enrollmentNumber&password=$password");

      print("All Response: $response");

      if (response['row'] == 1) {
        _onlineLoginCandidateModel =
            OnlineLoginCandidateModel.fromJson(response);

        AppConstants.companyId =
            _onlineLoginCandidateModel!.result!.institutionID;
        AppConstants.assesmentId =
            _onlineLoginCandidateModel!.result!.assmentId;
        AppConstants.assessorId = "0";

        if (await isAssessmentAlreadyTaken(
              AppConstants.assesmentId ?? "",
              _onlineLoginCandidateModel!.result!.id ?? "",
            ) ==
            false) {
          await Get.find<AssessorDashboardController>()
              .importAssesmentQuestions(AppConstants.assesmentId ?? "",
                  companyId: AppConstants.companyId);
          await setAccessLocation();
          _isLoadingOnline = false;
          Get.find<AuthController>().changeIsLoadingResponse();
          return true;
        }

        _isLoadingOnline = false;
        Get.find<AuthController>().changeIsLoadingResponse();
        update();
        return false;
      } else {
        _isLoadingOnline = false;
        Get.find<AuthController>().changeIsLoadingResponse();

        CustomSnackBar.customSnackBar(false, "Please Enter Valid Credentials");
        update();
        return null;
      }
    } catch (e) {
      CustomSnackBar.customSnackBar(false, "Something went wrong");
      debugPrint("Exception: $e");
      _isLoadingOnline = false;
      update();
      return false;
    }
  }

  List<CandidateDetails> _completedMcqListOnline = [];
  List<CandidateDetails> get completedMcqListOnline => _completedMcqListOnline;

  // bool _isAlreadyGiven = false;
  // bool get isAlreadyGiven => _isAlreadyGiven;

  Future<bool> isAssessmentAlreadyTaken(String id, String candidateId) async {
    _completedMcqListOnline = [];
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
          update();
          for (int i = 0; i < _completedMcqListOnline.length; i++) {
            if (_completedMcqListOnline[i].id == candidateId &&
                _completedMcqListOnline[i].isMCQ == "Yes") {
              return true;
            }
          }
        } else {
          // CustomSnackBar.customSnackBar(false, "No Candidate Data found");
          return false;
        }
        return false;
      } else {
        update();
        CustomSnackBar.customSnackBar(false, "Something went wrong!");
        return false;
      }
    } catch (e) {
      CustomSnackBar.customSnackBar(false, "Something went wrong!");
      update();
      return false;
    }
  }

  changeIsLoadingOnline(bool value) {
    _isLoadingOnline = value;
    update();
  }

  // Added Line of Code one by one
  // List<CandidateDetailsWithStatus> _syncStatusCandidateListTheory = [];
  // List<CandidateDetailsWithStatus> get syncStatusCandidateListTheory =>
  //     _syncStatusCandidateListTheory;
  // Future<void> getAllCandidatesSyncStatus() async {
  //   try {
  //     _syncStatusCandidateListTheory = [];
  //     var formBody = json.encode({
  //       'assmentId': int.parse(AppConstants.assesmentId ?? ""),
  //     });
  //     Map<String, dynamic> response = await ApiClient()
  //         .post(ApiEndpoints.getSyncedTheoryStatus, body: formBody);

  //     print(response);

  //     AllCandidateDataSyncListModel allCandidateDataSyncListModel =
  //         AllCandidateDataSyncListModel.fromJson(response);

  //     _syncStatusCandidateListTheory.addAll(allCandidateDataSyncListModel
  //         .data!.users as Iterable<CandidateDetailsWithStatus>);

  //     print(
  //         "Total List Length Received::::: ${_syncStatusCandidateListTheory.length}");

  //     update();
  //   } catch (e) {
  //     debugPrint("Exception: $e");
  //   }
  //   update();
  // }

  // Added Line of Code one by one
  // List<CandidateModel> _temporaryList = [];
  // List<CandidateModel> get temporaryList => _temporaryList;

  // getAllCompletedDocumentationCandidateList() async {
  //   _temporaryList = [];
  //   DatabaseHelper dbHelper = DatabaseHelper();
  //   _temporaryList = await dbHelper.getCandidates();
  //   update();
  // }

  // bool isDataExistForTheCandidate(String candidateId) {
  //   for (var i = 0; i < _temporaryList.length; i++) {
  //     if (candidateId == _temporaryList[i].candidateId) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  // Syncing Data
  List<CandidateSubmitDocumentsModel> _temporaryCandidateDocumentsList = [];
  List<CandidateSubmitDocumentsModel> get temporaryCandidateDocumentsList =>
      _temporaryCandidateDocumentsList;

  Future<void> getAllSubmittedDocumentationOfCandidates() async {
    _temporaryCandidateDocumentsList = [];
    DatabaseHelper dbHelper = DatabaseHelper();
    _temporaryCandidateDocumentsList =
        await dbHelper.getCandidatesSubmittedDocuments();
    update();
  }

  bool isCandidateDocumentsSubmittedForTheory(String candidateId) {
    for (var i = 0; i < _temporaryCandidateDocumentsList.length; i++) {
      if (candidateId == _temporaryCandidateDocumentsList[i].candidateId) {
        return true;
      }
    }
    return false;
  }

  Future<void> syncOneCandidateTheoryDocuments(String candidateId) async {
    print(
        "-------------------------- SYNCING DOCUMENTS --------------------------");
    DatabaseHelper dbHelper = DatabaseHelper();
    // loading indicator for documents

    try {
      List<CandidateSubmitDocumentsModel> temporaryList =
          await dbHelper.getCandidatesSubmittedDocuments();
      if (temporaryList.isNotEmpty) {
        for (var i = 0; i < temporaryList.length; i++) {
          if (candidateId == temporaryList[i].candidateId) {
            var candidateJsonData = json.encode({
              "type": temporaryList[i].type,
              "assessorId": 0,
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
              "studentId": int.parse(temporaryList[i].candidateId ?? ""),
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
          }
        }
      }
    } catch (e) {
      print("Exception Occured while syncing one candidate Documents");
    }
  }

  Future<void> syncOneCandidateMcqAnswersOfCandidates(
      String candidateId) async {
    print(
        "-------------------------- SYNCING MCQ ANSWERE HERE --------------------------");
    // getting list from the database
    DatabaseHelper dbHelper = DatabaseHelper();
    try {
      List<McqAnswers> allStudentsMcqAnswers =
          await dbHelper.getAllCandidatesMcqAnswers();

      if (allStudentsMcqAnswers.isNotEmpty) {
        for (int i = 0; i < allStudentsMcqAnswers.length; i++) {
          if (candidateId == allStudentsMcqAnswers[i].candidateId) {
            var response = await ApiClient().post(
                "${ApiEndpoints.syncStudentMcqAnswers}assmentId=${allStudentsMcqAnswers[i].assessmentId}&userId=${allStudentsMcqAnswers[i].candidateId}&questId=${allStudentsMcqAnswers[i].questionId}&userAns=${allStudentsMcqAnswers[i].answerId}&anstime=${allStudentsMcqAnswers[i].answerTime}");
            print("Total Answer Synced Here: $i $response");
          }
        }
      }
    } catch (e) {
      print("Exception Occured while syncing one candidate Mcq Answers");
    }
  }

  Future<void> syncOneMcqStudentForTheory(String candidateId) async {
    print(
        "-------------------------- SYNCING STUDENTS --------------------------");
    DatabaseHelper dbHelper = DatabaseHelper();
    try {
      List<Batches> allCompletedMcqBatch =
          await dbHelper.getAllCompletedMcqStudents();

      if (allCompletedMcqBatch.isNotEmpty) {
        for (int i = 0; i < allCompletedMcqBatch.length; i++) {
          if (candidateId == allCompletedMcqBatch[i].id) {
            // exam date time code
            CandidateExamTimeModel? candidateExamTimeModel =
                await getExamDateTimeOfCandidate(
                    allCompletedMcqBatch[i].id.toString());
            // exam date time code
            var response = await ApiClient().postFormRequest(
                ApiEndpoints.syncStudentMcqAnswersCompleteSync, {
              'assmentId': allCompletedMcqBatch[i].assmentId,
              'userId': allCompletedMcqBatch[i].id,
              'date': candidateExamTimeModel != null
                  ? candidateExamTimeModel.date
                  : "",
              'start_time': candidateExamTimeModel != null
                  ? candidateExamTimeModel.startTime
                  : "",
              'end_time': candidateExamTimeModel != null
                  ? candidateExamTimeModel.endTime
                  : "",
              'tab_switch': candidateExamTimeModel != null
                  ? candidateExamTimeModel.switchCount.toString()
                  : "0"
            });
            print("Total Answer Synced Here: $i $response");
          }
        }
      }
    } catch (e) {
      print("Exception found when syncing the candidate");
    }
    update();
  }

  Future<void> syncOneCandidateMcqScreenshots(String candidateId) async {
    print(
        "-------------------------- SYNCING STUDENTS SCREEENSHOTS HERE --------------------------");

    DatabaseHelper dbHelper = DatabaseHelper();

    try {
      List<CandidateScreenshotUploadModel> allCandidatesScreenshots =
          await dbHelper.getCandidateScreenshots();

      if (allCandidatesScreenshots.isNotEmpty) {
        for (int i = 0; i < allCandidatesScreenshots.length; i++) {
          if (candidateId == allCandidatesScreenshots[i].userId) {
            var response = await ApiClient().get(
                "${ApiEndpoints.syncStudentsMcqScreenshots}assmentId=${int.parse(allCandidatesScreenshots[i].assmentId ?? "")}&userId=${int.parse(allCandidatesScreenshots[i].userId ?? "")}&userimg=${allCandidatesScreenshots[i].userimg!.replaceFirst(AppConstants.replacementPath, "")}&facecount=${allCandidatesScreenshots[i].faceCount}&imgTime=${allCandidatesScreenshots[i].dateTime}");

            // syncing image
            await ApiClient().uploadScreenshotToServer(
                allCandidatesScreenshots[i].userimg,
                allCandidatesScreenshots[i].assmentId ?? "",
                allCandidatesScreenshots[i].userId ?? "");
            print("Total Screenshots Synced Here: $i $response");
          }
        }
      }
    } catch (e) {
      debugPrint("Exceptionn occured while syncing candidate Screenshots: $e");
    }
    update();
  }

  // Future<void> getAllCandidatesPracticalAndVivaSyncStatus() async {
  //   try {
  //     _syncStatusCandidatePracticalAndVivaListTheory = [];
  //     var formBody = json.encode({
  //       'assmentId': int.parse(AppConstants.assesmentId ?? ""),
  //     });
  //     Map<String, dynamic> response = await ApiClient()
  //         .post(ApiEndpoints.getSyncedVivaPracticalStatus, body: formBody);

  //     print(response);

  //     AllCandidateDataSyncListModel allCandidateDataSyncListModel =
  //         AllCandidateDataSyncListModel.fromJson(response);

  //     _syncStatusCandidatePracticalAndVivaListTheory.addAll(
  //         allCandidateDataSyncListModel.data!.users
  //             as Iterable<CandidateDetailsWithStatus>);

  //     print(
  //         "_syncStatusCandidatePracticalAndVivaListTheory Total List Length Received::::: ${_syncStatusCandidatePracticalAndVivaListTheory.length}");

  //     update();
  //   } catch (e) {
  //     debugPrint("Exception: $e");
  //   }
  //   update();
  // }

  // List<CandidateDetailsWithStatus>
  //     _syncStatusCandidatePracticalAndVivaListTheory = [];
  // List<CandidateDetailsWithStatus>
  //     get syncStatusCandidatePracticalAndVivaListTheory =>
  //         _syncStatusCandidatePracticalAndVivaListTheory;
  // Added Line of Code one by one

  // Trendsetters App
  // getting the candidate languages options
  AssessmentAvailableLanguageModel? _selectedVernacularLanguage;
  AssessmentAvailableLanguageModel? get selectedVernacularLanguage =>
      _selectedVernacularLanguage;

  List<AssessmentAvailableLanguageModel> _availableTheoryPaperLanguageList = [];
  List<AssessmentAvailableLanguageModel> get availableTheoryPaperLanguageList =>
      _availableTheoryPaperLanguageList;

  getAllAvailableLanguagesForMcq() async {
    _availableTheoryPaperLanguageList = [
      AssessmentAvailableLanguageModel(id: "-1", name: "English")
    ];
    _selectedVernacularLanguage = _availableTheoryPaperLanguageList[0];

    _availableTheoryPaperLanguageList
        .addAll(await DatabaseHelper().getAllMcqLanguages());
    update();
  }

  changeQuestionVernacularLanguage(AssessmentAvailableLanguageModel value) {
    _selectedVernacularLanguage = value;
    AppConstants.vernacularLanguage = value;
    update();
  }

  List<MCQuestionsLanguageQuestion> _allDatabaseLanguageQuestions = [];
  List<MCQuestionsLanguageQuestion> get allDatabaseLanguageQuestions =>
      _allDatabaseLanguageQuestions;

  getAllLanguageQuestions() async {
    _allDatabaseLanguageQuestions = [];
    _allDatabaseLanguageQuestions =
        await DatabaseHelper().getAllMcqLanguageQuestions();
    print(
        "All Languages Database Questions: ${_allDatabaseLanguageQuestions.length}");
    update();
  }

  String? getSelectedVernacularLanguageQuestion(
      String langCode, String questionId) {
    print(
        "------------Get Selected Vernacular Langage Questions Run--------- $langCode $questionId");
    if (langCode == "-1") {
      return null;
    } else {
      for (int i = 0; i < _allDatabaseLanguageQuestions.length; i++) {
        if (_allDatabaseLanguageQuestions[i].langId == langCode &&
            _allDatabaseLanguageQuestions[i].questionId == questionId) {
          return _allDatabaseLanguageQuestions[i].question;
        }
      }
      return null;
    }
  }

  String? getSelectedVernacularLanguageOption(
      String langCode, String questionId, int optionNumber) {
    if (langCode == "-1") {
      return null;
    } else {
      for (int i = 0; i < _allDatabaseLanguageQuestions.length; i++) {
        if (_allDatabaseLanguageQuestions[i].langId == langCode &&
            _allDatabaseLanguageQuestions[i].questionId == questionId) {
          switch (optionNumber) {
            case 0:
              return _allDatabaseLanguageQuestions[i].option1;
            case 1:
              return _allDatabaseLanguageQuestions[i].option2;
            case 2:
              return _allDatabaseLanguageQuestions[i].option3;
            case 3:
              return _allDatabaseLanguageQuestions[i].option4;
          }
        }
      }
      return null;
    }
  }

  String? getSelectedVernacularLanguageOption1(
      String langCode, String questionId) {
    if (langCode == "-1") {
      return null;
    } else {
      for (int i = 0; i < _allDatabaseLanguageQuestions.length; i++) {
        if (_allDatabaseLanguageQuestions[i].langId == langCode &&
            _allDatabaseLanguageQuestions[i].questionId == questionId) {
          return _allDatabaseLanguageQuestions[i].option1;
        }
      }
      return null;
    }
  }

  String? getSelectedVernacularLanguageOption2(
      String langCode, String questionId) {
    if (langCode == "-1") {
      return null;
    } else {
      for (int i = 0; i < _allDatabaseLanguageQuestions.length; i++) {
        if (_allDatabaseLanguageQuestions[i].langId == langCode &&
            _allDatabaseLanguageQuestions[i].questionId == questionId) {
          return _allDatabaseLanguageQuestions[i].option2;
        }
      }
      return null;
    }
  }

  String? getSelectedVernacularLanguageOption3(
      String langCode, String questionId) {
    if (langCode == "-1") {
      return null;
    } else {
      for (int i = 0; i < _allDatabaseLanguageQuestions.length; i++) {
        if (_allDatabaseLanguageQuestions[i].langId == langCode &&
            _allDatabaseLanguageQuestions[i].questionId == questionId) {
          return _allDatabaseLanguageQuestions[i].option3;
        }
      }
      return null;
    }
  }

  String? getSelectedVernacularLanguageOption4(
      String langCode, String questionId) {
    if (langCode == "-1") {
      return null;
    } else {
      for (int i = 0; i < _allDatabaseLanguageQuestions.length; i++) {
        if (_allDatabaseLanguageQuestions[i].langId == langCode &&
            _allDatabaseLanguageQuestions[i].questionId == questionId) {
          return _allDatabaseLanguageQuestions[i].option4;
        }
      }
      return null;
    }
  }

  // Candidate NOt Synced Code

  List<UserSyncedDataModel> _userSyncedDataList = [];
  List<UserSyncedDataModel> get userSyncedDataList => _userSyncedDataList;

  // Future<void> getTotalPracticalAndVivaSyncedByAssessmentId() async {
  //   try {
  //     _syncStatusCandidatePracticalAndVivaListTheory = [];
  //     var formBody = json.encode({
  //       'assmentId': int.parse(AppConstants.assesmentId ?? ""),
  //     });
  //     Map<String, dynamic> response = await ApiClient()
  //         .post(ApiEndpoints.getSyncedVivaPracticalStatus, body: formBody);

  //     print(response);

  //     AllCandidateDataSyncListModel allCandidateDataSyncListModel =
  //         AllCandidateDataSyncListModel.fromJson(response);

  //     _syncStatusCandidatePracticalAndVivaListTheory.addAll(
  //         allCandidateDataSyncListModel.data!.users
  //             as Iterable<CandidateDetailsWithStatus>);

  //     print(
  //         "_syncStatusCandidatePracticalAndVivaListTheory Total List Length Received::::: ${_syncStatusCandidatePracticalAndVivaListTheory.length}");

  //     update();
  //   } catch (e) {
  //     debugPrint("Exception: $e");
  //   }
  //   update();
  // }

  // Future<void> getTotalTheorySyncedByByAssessmentId() async {
  //   try {
  //     _syncStatusCandidatePracticalAndVivaListTheory = [];
  //     var formBody = json.encode({
  //       'assmentId': int.parse(AppConstants.assesmentId ?? ""),
  //     });
  //     Map<String, dynamic> response = await ApiClient()
  //         .post(ApiEndpoints.getSyncedVivaPracticalStatus, body: formBody);

  //     print(response);

  //     AllCandidateDataSyncListModel allCandidateDataSyncListModel =
  //         AllCandidateDataSyncListModel.fromJson(response);

  //     _syncStatusCandidatePracticalAndVivaListTheory.addAll(
  //         allCandidateDataSyncListModel.data!.users
  //             as Iterable<CandidateDetailsWithStatus>);

  //     print(
  //         "_syncStatusCandidatePracticalAndVivaListTheory Total List Length Received::::: ${_syncStatusCandidatePracticalAndVivaListTheory.length}");

  //     update();
  //   } catch (e) {
  //     debugPrint("Exception: $e");
  //   }
  //   update();
  // }

  // Candidate Not Synced Code

  // Partial Sync Code

  // Viva And Practical Code
  List<CandidateTotalAnswerSyncedCountModel> _totalPracticalVivaAnswersSynced =
      [];
  List<CandidateTotalAnswerSyncedCountModel>
      get totalPracticalVivaAnswersSynced => _totalPracticalVivaAnswersSynced;

  List<AssessorQuestionAnswersReplyModel>
      _tempInsertedPracticalsAndVivaAnswersList = [];
  List<AssessorQuestionAnswersReplyModel>
      get tempInsertedPracticalsAndVivaAnswersList =>
          _tempInsertedPracticalsAndVivaAnswersList;

  List<Batches> _candidatesList = [];
  List<Batches> get candidatesList => _candidatesList;

  Future<void> getTotalPracticalAndVivaAnswersSynced() async {
    try {
      _totalPracticalVivaAnswersSynced = [];

      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getTotalAnswerSyncedOfCandidates}assmentId=${AppConstants.assesmentId}&ptype=1");

      for (var i in response['data']) {
        _totalPracticalVivaAnswersSynced.add(
            CandidateTotalAnswerSyncedCountModel(
                cnt: i['cnt'], userId: i['user_id']));
      }
      update();
    } catch (e) {
      print("Exception Occured!");
    }
  }

  getAllInsertedPracticalAndVivaAnswers() async {
    _tempInsertedPracticalsAndVivaAnswersList = [];
    _tempInsertedPracticalsAndVivaAnswersList
        .addAll(await DatabaseHelper().getCandidatesPracticleAnswers());
    _tempInsertedPracticalsAndVivaAnswersList
        .addAll(await DatabaseHelper().getCandidatesVivaAnswers());
    print(
        "Total Practicals and viva Inserted Answers is: ${_tempInsertedPracticalsAndVivaAnswersList.length}");
    update();
  }

  int getLocalStoredVivaAnswersCount(String userId) {
    int count = 0;
    for (int i = 0; i < _tempInsertedPracticalsAndVivaAnswersList.length; i++) {
      if (_tempInsertedPracticalsAndVivaAnswersList[i].studentId == userId) {
        count++;
      }
    }
    if (count == 0) {
      return -1;
    }
    return count;
  }

  getAllCandidatesList() async {
    _candidatesList = [];
    _candidatesList.addAll(await DatabaseHelper().getBatchList());
    print("Total Candidates Answers is: ${_candidatesList.length}");
    update();
  }

  // MCQ Theory Count Code
  List<CandidateTotalAnswerSyncedCountModel> _totalMcqAnswersSynced = [];
  List<CandidateTotalAnswerSyncedCountModel> get totalMcqAnswersSynced =>
      _totalMcqAnswersSynced;

  List<McqAnswers> _allMcqAnswersList = [];
  List<McqAnswers> get allMcqAnswersList => _allMcqAnswersList;

  getAllInsertedMcqAnswers() async {
    _allMcqAnswersList = [];
    _allMcqAnswersList
        .addAll(await DatabaseHelper().getAllCandidatesMcqAnswers());
    print(
        "Total Mcq Answers Inserted Answers is: ${_allMcqAnswersList.length}");
    update();
  }

  Future<void> getTotalMcqAnswersSynced() async {
    try {
      _totalMcqAnswersSynced = [];

      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getTotalAnswerSyncedOfCandidates}assmentId=${AppConstants.assesmentId}&ptype=0");

      for (var i in response['data']) {
        _totalMcqAnswersSynced.add(CandidateTotalAnswerSyncedCountModel(
            cnt: i['cnt'], userId: i['user_id']));
      }

      update();

      print(
          "Total MCQ Synced Yet Synced::::::::: ${_totalMcqAnswersSynced.length}");
    } catch (e) {
      print("Exception Occured while Getting Synced MCQ Answers");
    }
  }

  int getLocalStoredTheoryAnswersCount(String userId) {
    int count = 0;
    for (int i = 0; i < _allMcqAnswersList.length; i++) {
      if (_allMcqAnswersList[i].candidateId == userId) {
        count++;
      }
    }
    if (count == 0) {
      return -1;
    }
    return count;
  }

  bool _isSyncingGoingOn = false;
  bool get isSyncingGoingOn => _isSyncingGoingOn;

  int? _currentSyncingIndex = null;
  int? get currentSyncingIndex => _currentSyncingIndex;

  changeIsSyncingData(bool value) {
    _isSyncingGoingOn = value;
    update();
  }

  setCurrentSyncingCandidateIndex(int? index) {
    _currentSyncingIndex = index;
    update();
  }

  // Partial Sync Code
  List<FeedbackQuestionModel> _feedbackQuestionsList = [];
  List<FeedbackQuestionModel> get feedbackQuestionsList =>
      _feedbackQuestionsList;

  List<FeedbackAnswersModel> _feedbackAnswersList = [];
  List<FeedbackAnswersModel> get feedbackAnswersList => _feedbackAnswersList;

  bool _isLoadingFeedbackQuestions = false;
  bool get isLoadingFeedbackQuestions => _isLoadingFeedbackQuestions;

  getAllFeedbackQuestions() async {
    _isLoadingFeedbackQuestions = true;
    update();
    _feedbackQuestionsList = [];
    _feedbackAnswersList = [];
    _feedbackQuestionsList = await DatabaseHelper().getFeedbackQuestions();
    _isLoadingFeedbackQuestions = false;
    update();
  }

  Future<void> insertOrUpdateFeedbackAnswerList(
      FeedbackAnswersModel answersModel) async {
    final String questionId =
        answersModel.questionId.toString(); // Adjust if null is not expected
    int existingAnswerIndex = _feedbackAnswersList.indexWhere(
      (answer) => answer.questionId == questionId,
    );
    if (existingAnswerIndex != -1) {
      _feedbackAnswersList[existingAnswerIndex].answer = answersModel.answer;
    } else {
      _feedbackAnswersList.add(
        FeedbackAnswersModel(
            questionId: questionId,
            answer: answersModel.answer,
            candidateId: answersModel.candidateId),
      );
    }
    // for (int i = 0; i < _feedbackAnswersList.length; i++) {
    //   print("Candidate Id: ${_feedbackAnswersList[i].candidateId}");
    //   print("Question Id: ${_feedbackAnswersList[i].questionId}");
    //   print("Answer: ${_feedbackAnswersList[i].answer}");
    // }
  }

  storeCandidateAnswersToLocalDatabase() async {
    for (int i = 0; i < _feedbackAnswersList.length; i++) {
      await DatabaseHelper().insertFeedbackAnswer(_feedbackAnswersList[i]);
    }
  }

  Future<void> syncOneCandidateFeedback(
      String assessmentId, String candidateId) async {
    try {
      List<FeedbackAnswersModel> tempList = [];
      tempList = await DatabaseHelper().getAllFeedbackAnswers();

      for (int i = 0; i < tempList.length; i++) {
        if (tempList[i].candidateId == candidateId) {
          await ApiClient().postFormRequest(ApiEndpoints.synCandidateFeedback, {
            'assmentId': assessmentId,
            'userId': tempList[i].candidateId,
            'bfq_id': tempList[i].questionId,
            'answer': tempList[i].answer
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to Sync the Feedback");
      print("Exception Occured while importing Available Options");
    }
  }

  Future<void> syncAllCandidateFeedback(String assessmentId) async {
    try {
      List<FeedbackAnswersModel> tempList = [];
      tempList = await DatabaseHelper().getAllFeedbackAnswers();

      for (int i = 0; i < tempList.length; i++) {
        if (completedSyncedCandidatesList.contains(tempList[i].candidateId) ==
            false) {
          await ApiClient().postFormRequest(ApiEndpoints.synCandidateFeedback, {
            'assmentId': assessmentId,
            'userId': tempList[i].candidateId,
            'bfq_id': tempList[i].questionId,
            'answer': tempList[i].answer
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to Sync the Feedback");
      print("Exception Occured while importing Available Options");
    }
  }

// exam date time code
  String? _candidateStartTime;
  String? get candidateStartTime => _candidateStartTime;

  String? _candidateEndTime;
  String? get candidateEndTime => _candidateEndTime;

  String? _candidateStartDate;
  String? get candidateStartDate => _candidateStartDate;

  setCandidateStartTime(String time) {
    _candidateStartTime = time;
    print(_candidateStartTime);
    update();
  }

  setCandidateEndTime(String time) {
    _candidateEndTime = time;
    print(_candidateEndTime);

    update();
  }

  setCandidateStartDate(String date) {
    _candidateStartDate = date;
    print(_candidateStartDate);

    update();
  }

  // exam date time code
  saveCandidateDateTimeToLocalDB(Batches candidate) async {
    await DatabaseHelper().insertExamDateTime(CandidateExamTimeModel(
        date: _candidateStartDate,
        endTime: _candidateEndTime,
        startTime: _candidateStartTime,
        userId: candidate.id,
        switchCount: switchCount.toString()));
  }
  // exam date time code

  // delete existing data code
  Future<void> deleteAllExistingRecordOfCandidates() async {
    print(
        "-------------------------- SYNCING STUDENTS --------------------------");
    DatabaseHelper dbHelper = DatabaseHelper();
    try {
      List<Batches> allCompletedMcqBatch =
          await dbHelper.getAllCompletedMcqStudents();

      if (allCompletedMcqBatch.isNotEmpty) {
        for (int i = 0; i < allCompletedMcqBatch.length; i++) {
          if (Get.find<CandidateOnboardingController>()
                  .completedSyncedCandidatesList
                  .contains(allCompletedMcqBatch[i].id) ==
              false) {
            var response = await ApiClient()
                .postFormRequest(ApiEndpoints.deleteExistingMcqOfCandidates, {
              'assmentId': allCompletedMcqBatch[i].assmentId,
              'userId': allCompletedMcqBatch[i].id
            });
            print("Total Answer Synced Here: $i $response");
          }
        }
      }
    } catch (e) {
      print("Exception found when syncing the candidate");
    }
    update();
  }
  // delete existing data code

  // code for checking already synced candidates data
  List<String> _completedSyncedCandidatesList = [];
  List<String> get completedSyncedCandidatesList =>
      _completedSyncedCandidatesList;

  Future<void> getOnlySyncedCandidatesList() async {
    List<CandidateTotalAnswerSyncedCountModel> tempCountList = [];
    _completedSyncedCandidatesList = [];

    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getTotalAnswerSyncedOfCandidates}assmentId=${AppConstants.assesmentId}&ptype=0");

      for (var i in response['data']) {
        tempCountList.add(CandidateTotalAnswerSyncedCountModel(
            cnt: i['cnt'], userId: i['user_id']));
      }

      if (tempCountList.isNotEmpty) {
        for (int i = 0; i < tempCountList.length; i++) {
          if (await isTotalServerSyncedAndLocalDatabaseMatched(
                  tempCountList[i].userId.toString(),
                  int.parse(tempCountList[i].cnt.toString())) ==
              true) {
            _completedSyncedCandidatesList
                .add(tempCountList[i].userId.toString());
          }
        }
        update();
        print(
            "Total Successfully Synced Candidatees: ${_completedSyncedCandidatesList.length}");
      }
    } catch (e) {
      print("Exception Occured while Getting Synced MCQ Answers");
      Fluttertoast.showToast(msg: "Failed to get already Synced Candidates.");
    }
  }

  Future<bool?> isTotalServerSyncedAndLocalDatabaseMatched(
      String userId, int serverCount) async {
    int count = 0;
    List<McqAnswers> tempMcqAnswersList =
        await DatabaseHelper().getAllCandidatesMcqAnswers();
    for (int i = 0; i < tempMcqAnswersList.length; i++) {
      if (tempMcqAnswersList[i].candidateId == userId) {
        count++;
      }
    }
    if (count == 0) {
      return null;
    }
    if (serverCount == count) {
      return true;
    }
    return false;
  }

  // code for checking already synced candidates data

// Tab Switch Code Here

  int switchCount = 0;

  Batches? currentOngoingCandidate;

  void addObservor() {
    WidgetsBinding.instance.addObserver(this);
  }

  void removeObservor() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      switchCount++;
      if (Get.find<CandidateOnboardingController>()
              .assessmentDurationInformation!
              .tabSwitchesAllowed ==
          "Y") {
        showPopup();
        showAppUnpinPopup();
      } else {
        showAppUnpinPopup();
      }
    }
  }

  void showPopup() {
    Get.dialog(
        barrierDismissible: false,
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: CustomWarningDialog(
            showCancel: false,
            title:
                "You switched the tab $switchCount/${assessmentDurationInformation!.numberTabSwitchesAllowed} Times.",
            onPress: () async {
              if (switchCount <=
                  int.parse(
                      "${assessmentDurationInformation!.numberTabSwitchesAllowed}")) {
                Get.back();
              } else {
                if (currentOngoingCandidate != null) {
                  if (await syncAnswerToLocalDB()) {
                    // camera closing
                    if (webProctoring == "Y") {
                      print(
                          "INSIDE WEB PROCTORING CONDITION: ===============>");
                      stopCaptureTimer();
                      await stopLiveFeed();
                    }
                    resetQuestionPaper();
                    // exam date time code
                    setCandidateEndTime(
                        AppConstants.getFormatedCurrentTime(DateTime.now()));
                    await saveCandidateDateTimeToLocalDB(
                        currentOngoingCandidate!);
                    // exam date time code
                    // saving student to the database
                    await saveStudentDB(currentOngoingCandidate!);
                    // syncing the screenshots captured
                    await syncCandidatesScreenshotsToDB();
                    print(
                        "TOTAL CLICKED PHOTOS: ===============> ${clickedPhotosList.length}");

                    // clear the answers of the variables
                    clearAnswer();

                    CustomSnackBar.customSnackBar(true,
                        "${currentOngoingCandidate!.name} record submitted successfully!");

                    // Getting completed MCQ Candidates List
                    Get.find<AssessorDashboardController>()
                        .getAllCompletedStudentsMcqList();

                    // Feedback Code
                    await getAllFeedbackQuestions();

                    // observor code
                    // if (assessmentDurationInformation!.tabSwitchesAllowed ==
                    //     "Y") {
                    stopKioskMode();
                    removeObservor();
                    // }

                    // observor code

                    if (feedbackQuestionsList.isNotEmpty) {
                      Get.offAll(CandidateFeedbackForm(
                        candidateId: currentOngoingCandidate!.id.toString(),
                        assessmentId:
                            currentOngoingCandidate!.assmentId.toString(),
                        candidate: currentOngoingCandidate!,
                        isObservorNeeded:
                            assessmentDurationInformation!.tabSwitchesAllowed ??
                                "N",
                      ));
                    } else {
                      if (AppConstants.isOnlineMode == true) {
                        await Get.find<AssessorDashboardController>()
                            .syncMcqOneByOne(currentOngoingCandidate!, 0,
                                isDocumentLinkNeeded: false);
                        await DatabaseHelper().clearDatabase();
                        // Get.find<AuthController>().logOutUser();
                      }
                      Get.offAll(AppConstants.isOnlineMode == true
                          ? const UserModeScreen()
                          : const LoginTypeScreen(
                              isOnline: false,
                              isFromStudentLogout: true,
                            ));
                      clearBaseDurationVariables();
                      clearCandidateDocuments();
                    }
                    // Feedback Code
                  } else {
                    CustomSnackBar.customSnackBar(
                        false, "Failed to Submit the record");
                  }
                } else {
                  CustomToast.showToast("Candidate Details not Found!");
                }
              }
            },
          ),
        ));
  }

  void showAppUnpinPopup() {
    Get.dialog(
        barrierDismissible: false,
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: CustomWarningDialog(
            showCancel: false,
            title:
                "You Can not unpin the ongoing assessment it will be considerd as Cheating!",
            onPress: () async {
              final mode = await getKioskMode();
              if (mode == KioskMode.disabled) {
                startKioskMode();
              } else {
                Get.back();
              }
            },
          ),
        ));
  }
// Trendsetters App

  double _fontSize = 16.0;
  double get fontSize => _fontSize;

  increaseFontSize() {
    if (_fontSize < 40.0) {
      _fontSize = _fontSize + 2.0;
      update();
    }
  }

  decreaseFontSize() {
    if (_fontSize > 16.0) {
      _fontSize = _fontSize - 2.0;
      update();
    }
  }

  changeFontSize(double value) {
    _fontSize = value;
    update();
  }

  showDefaultDialogUsingData(Uint8List data) {
    Get.dialog(
      Stack(
        children: [
          Positioned(
              top: 0,
              left: AppConstants.paddingDefault,
              right: AppConstants.paddingDefault,
              child: Image.memory(
                // fit: BoxFit.fitHeight,
                data,
                height: Get.height,
                width: Get.width,
              )),
          Positioned(
            top: Get.height * 0.23,
            right: AppConstants.paddingSmall - 5,
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  ImageUrls.cancelIcon,
                  height: 40,
                  width: 40,
                )),
          )
        ],
      ),
    );
  }

  Future<bool?> getIsCandidateAlreadyGivenViva(String? candidateId) async {
    print("PRINTING CANDIDATE ID HERE: $candidateId");
    if (candidateId != null) {
      List<Batches> tempCandidateList = [];
      tempCandidateList.addAll(await DatabaseHelper().getBatchList());
      for (int i = 0; i < tempCandidateList.length; i++) {
        if (candidateId == tempCandidateList[i].id) {
          if (tempCandidateList[i].isTheoryDone == "Y") {
            return null;
          }
        }
      }
      return true;
    }
    return null;
  }

  changeIfSummaryAnswerChanged(bool value) {
    _isSummaryAnswerChanged = value;
    update();
  }

  changeIfAnswerChanged(bool value) {
    _isAnswerChangedUsingPrevious = value;
    update();
  }

  // disableTemporaryRealTime(bool value) {
  //   _disableTensorFlowTemporary = value;
  //   update();
  //   print("Updated Disable value is: $_disableTensorFlowTemporary");
  // }

  // bool getDiableTensorFlowStatus() {
  //   return _disableTensorFlowTemporary;
  // }

  int convertMinutesToSeconds(String minutes) {
    return int.parse(minutes) * 60;
  }

  bool doesOnlineListContainsId(String userId) {
    for (int i = 0; i < _totalPracticalVivaAnswersSynced.length; i++) {
      if (_totalPracticalVivaAnswersSynced[i].userId == userId) {
        return true;
      }
    }
    return false;
  }
}
