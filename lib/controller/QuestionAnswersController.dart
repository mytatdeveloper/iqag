import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/common-components/Online-Module/OnlineAssessorSyncedDocumentsListModel.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/AssesmentQuestionsModel.dart';
import 'package:mytat/model/AssessorDocumentsModel.dart';
import 'package:mytat/model/CandidateModel.dart';
import 'package:mytat/model/Online-Models/ServerDateTimeModel.dart';
import 'package:mytat/model/QuestStepsListModel.dart';
import 'package:mytat/model/QuestionStepMarkingAnswerModel.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorAnnexureListUploadModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorDocumentsUploadModels.dart';
import 'package:mytat/model/Syncing-Models/AssessorQuestionAnswerReplyModel.dart';
import 'package:mytat/model/VivaPracticalMarkingModel.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/ApiClient.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

import '../utilities/ApiEndpoints.dart';

class QuestionAnswersController extends GetxController {
  // variables & getters

  int _currentVivaQuestion = 0;
  int get currentVivaQuestion => _currentVivaQuestion;

  int _currentPracticleQuestion = 0;
  int get currentPracticleQuestion => _currentPracticleQuestion;

  // int? _selectedMarks;
  // int? get selectedMarks => _selectedMarks;

  late CameraController _cameraController;
  CameraController get cameraController => _cameraController;

  bool _isCameraOpen = false;
  bool get isCameraOpen => _isCameraOpen;

  bool _isClickingPhoto = false;
  bool get isClickingPhoto => _isClickingPhoto;

  bool _isSavingPhoto = false;
  bool get isSavingPhoto => _isSavingPhoto;

  bool _showSaveButton = false;
  bool get showSaveButton => _showSaveButton;

  bool _isFileClicked = false;
  bool get isFileClicked => _isFileClicked;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  String? _currentClickedFile;
  String? get currentClickedFile => _currentClickedFile;

  String? _currentCandidateProfilePhoto;
  String? get currentCandidateProfilePhoto => _currentCandidateProfilePhoto;

  String? _currentCandidateAdharFrontPic;
  String? get currentCandidateAdharFrontPic => _currentCandidateAdharFrontPic;

  String? _currentCandidateAdharBackPic;
  String? get currentCandidateAdharBackPic => _currentCandidateAdharBackPic;

  String? _currentAssessorProfilePhoto;
  String? get currentAssessorProfilePhoto => _currentAssessorProfilePhoto;

  String? _currentAssessorAdharPic;
  String? get currentAssessorAdharPic => _currentAssessorAdharPic;

  String? _currentAssessorCenterPic;
  String? get currentAssessorCenterPic => _currentAssessorCenterPic;

  String? _currentAssessorCenterVideo;
  String? get currentAssessorCenterVideo => _currentAssessorCenterVideo;

  List<CandidateModel> _completedDocuemntationList = [];
  List<CandidateModel> get completedDocuemntationList =>
      _completedDocuemntationList;

  bool _isLoadingResponse = false;
  bool get isLoadingResponse => _isLoadingResponse;

  changeIsLoadingResponse(bool value) {
    _isLoadingResponse = value;
    update();
  }

  DatabaseHelper dbHelper = DatabaseHelper();

  // List<String> ratingOptionsList = [
  //   "Excellent",
  //   "Very Good",
  //   "Good",
  //   "Average",
  //   "Poor",
  //   "No Answer"
  // ];

  List<VivaPracticalMarkingModel> _customRatingOptionsList = [];
  List<VivaPracticalMarkingModel> get customRatingOptionsList =>
      _customRatingOptionsList;

  VivaPracticalMarkingModel? _selectedMarksByAssessor;
  VivaPracticalMarkingModel? get selectedMarksByAssessor =>
      _selectedMarksByAssessor;

  getMarkingOptionsList() async {
    _customRatingOptionsList = [];
    _customRatingOptionsList =
        await DatabaseHelper().getAllVivaPracticalMarkings();
    update();
  }

  rateStudentMarksByAssessor(VivaPracticalMarkingModel? marks) {
    _selectedMarksByAssessor = marks;
    update();
  }

  List<Annexurelist> _assessorLocalDocumentsList = [];
  List<Annexurelist> get assessorLocalDocumentsList =>
      _assessorLocalDocumentsList;

// questions answers handling method
  // rateStudentMarks(int? index) {
  //   _selectedMarks = index;

  //   print(_selectedMarks);
  //   update();
  // }

  loadNextVivaQuestion() {
    ++_currentVivaQuestion;

    // rateStudentMarks(null);
    rateStudentMarksByAssessor(null);
    // added line of code
    _selectedGroupCandidateMarksByAssessor = null;
    // added line of code
    clearCurrentClickedFile();

    update();
  }

  loadNextPracticleQuestion() {
    ++_currentPracticleQuestion;

    // rateStudentMarks(null);
    rateStudentMarksByAssessor(null);

// added line of code
    _selectedGroupCandidateMarksByAssessor = null;
// added line of code

    clearCurrentClickedFile();
    update();
  }

  resetPracticleQuestion({isCloseCameraNeeded = true}) {
    _currentPracticleQuestion = 0;
    if (isCloseCameraNeeded == true) {
      closeCamera();
    }
    clearCurrentClickedFile();
  }

  resetVivaQuestion({isCloseCameraNeeded = true}) {
    _currentVivaQuestion = 0;
    if (isCloseCameraNeeded == true) {
      closeCamera();
    }
    clearCurrentClickedFile();
  }

  // Camera Code -->
  void openCamera() {
    _isCameraOpen = true;
    update();
  }

  Future<void> initializeCamera(int? cameraToShow,
      {isLowResolutions = true}) async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
        cameras[cameraToShow ?? 0],
        isLowResolutions == true
            ? ResolutionPreset.high
            : ResolutionPreset.high);
    await _cameraController.initialize();
    update();
  }

  Future<String?> takePicture({isWatermarkNeeded = true}) async {
    if (!cameraController.value.isInitialized) {
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
      // final picture = await cameraController.takePicture();
      _currentClickedFile = picture.path;
      _isClickingPhoto = false;

      // adding watermark
      // await Get.find<SplashController>().getLocation();
      if (isWatermarkNeeded == true) {
        await addWatermarkToImage(_currentClickedFile!);
      }
      // adding watermark
      changeShowButtonVisibility();

      update();
      return picture.path;
    } catch (e) {
      debugPrint('Error taking picture: $e');
      update();
      return null;
    }
  }

  changeIsClickingPhoto(bool value) {
    _isClickingPhoto = value;
    update();
  }

// Video Recoding Function here
  Future<void> startRecording({bool isCandidateQuestions = false}) async {
    Get.dialog(
        barrierDismissible: false,
        const CustomSuccessDialog(
            title: "Starting Recording.....", logo: CustomLoadingIndicator()));

    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
    if (!_cameraController.value.isRecordingVideo) {
      try {
        await _cameraController.startVideoRecording();

        // timer code
        print("----------------- STARTING TIMER -----------------");
        // timer code
        _isRecording = true;
        if (isCandidateQuestions) {
          _currentClickedFile = null;
          _isCameraOpen = true;

          update();
        }
        update();
      } catch (e) {
        print("Error starting video recording: $e");
      }
    }
  }

  Future<void> stopRecording({bool isCandidateQuestions = false}) async {
    Get.dialog(
        barrierDismissible: false,
        const CustomSuccessDialog(
            title: "Stopping Recording.....", logo: CustomLoadingIndicator()));
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
    if (_cameraController.value.isRecordingVideo) {
      try {
        XFile? filePath = await _cameraController.stopVideoRecording();
        _isRecording = false;
        _currentClickedFile = filePath.path;
        update();

        // closing the camera here
        // closeCamera();

        if (isCandidateQuestions) {
          print("Current Clicked Video here: $_currentClickedFile");
          _isCameraOpen = false;
          update();
        } else {
          changeShowButtonVisibility();
        }
        update();
      } catch (e) {
        _isRecording = false;
        _currentClickedFile = null;
        _isCameraOpen = true;
        update();
        print("Error stopping video recording: $e");
      }
    }
  }

  void closeCamera() async {
    _isCameraOpen = false;
    Future.delayed(const Duration(seconds: 2), () {
      _cameraController.dispose();
    });
    update();
  }

  // void saveFileUrlToList(
  //     List<dynamic> list, int index, Future<String?> file) async {
  //   list[index].fileUrl = await file;
  //   debugPrint("After Updating to the List ==> ${list[index].fileUrl}");
  //   update();
  // }

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
        // Assessor Center Documents
        case "Profile Pic":
          await setAssessorProfilePhoto();
          break;
        case "Aadhar Pic":
          await setAssessorAdharPhoto();
          break;
        case "Center Pic":
          await setAssessorCenterPhoto();
          break;
        case "Center Video":
          await setAssessorCenterVideo();
          break;
        default:
      }
    }

    _currentClickedFile = null;
    changeShowButtonVisibility();
    closeCamera();
    update();
  }

  // Saving AnexureList Documents to Local
  void saveAssessorAnexureListToLocal(Annexurelist? annexureDocument) async {
    if (_currentClickedFile != null) {}
    _currentClickedFile = null;
    changeShowButtonVisibility();
    closeCamera();
    update();
  }

  void changeShowButtonVisibility() {
    _showSaveButton = !_showSaveButton;
    _isFileClicked = !_isFileClicked;

    print("_showSaveButton value found is: $_showSaveButton");
    print("_isFileClicked value found is: $_isFileClicked");

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
    print("_currentCandidateAdharBackPic: $_currentCandidateAdharBackPic");
    update();
  }

  submitStudentDocuments() {
    _currentCandidateAdharBackPic = null;
    _currentCandidateAdharFrontPic = null;
    _currentCandidateProfilePhoto = null;
    update();
  }

// setters for center documents assessor
  setAssessorProfilePhoto() {
    _currentAssessorProfilePhoto = _currentClickedFile;
    print("_currentAssessorProfilePhoto: $_currentAssessorProfilePhoto");
    update();
  }

  setAssessorAdharPhoto() {
    _currentAssessorAdharPic = _currentClickedFile;
    print("_currentAssessorAdharPic: $_currentAssessorAdharPic");
    update();
  }

  setAssessorCenterPhoto() {
    _currentAssessorCenterPic = _currentClickedFile;
    print("_currentAssessorCenterPic: $_currentAssessorCenterPic");
    update();
  }

  setAssessorCenterVideo() {
    _currentAssessorCenterVideo = _currentClickedFile;
    update();
  }
// setters for center documents assessor

  void assessorProfilePic() {
    if (AppConstants.isOnlineMode == true &&
        _currentAssessorProfilePhoto == null) {
      removeFromAlreadySyncedList("Assessor Profile");
    } else {
      _currentAssessorProfilePhoto = null;
    }
    update();
  }

  void assessorCenterPic() {
    if (AppConstants.isOnlineMode == true &&
        _currentAssessorCenterPic == null) {
      removeFromAlreadySyncedList("Center Pic");
    } else {
      _currentAssessorCenterPic = null;
    }
    update();
  }

  void assesorCenterVideo() {
    if (AppConstants.isOnlineMode == true &&
        _currentAssessorCenterVideo == null) {
      removeFromAlreadySyncedList("Center Video");
    } else {
      _currentAssessorCenterVideo = null;
    }
    update();
  }

  void assessorAadharPhoto() {
    if (AppConstants.isOnlineMode == true && _currentAssessorAdharPic == null) {
      removeFromAlreadySyncedList("Assessor Aadhar");
    } else {
      _currentAssessorAdharPic = null;
    }
    update();
  }

  // saveToAnexureList(Annexurelist annexureDocument) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   Annexurelist newAnnexureObject = Annexurelist(
  //       id: annexureDocument.id,
  //       image: _currentClickedFile,
  //       name: annexureDocument.name);
  //   annexureDocument.image = _currentClickedFile;
  //   anexureUploadedList.add(newAnnexureObject);

  //   if (annexureDocument.name != null && currentClickedFile != null) {
  //     prefs.setString(annexureDocument.name ?? "", _currentClickedFile ?? "");
  //     print(
  //         "Saved ${annexureDocument.name}: ${prefs.getString(annexureDocument.name ?? "")}");
  //   }

  //   closeCamera();
  //   _currentClickedFile = null;
  //   changeShowButtonVisibility();
  //   update();
  // }

  clearCurrentClickedFile() {
    _currentClickedFile = null;
    _isCameraOpen = true;
    update();
  }

  clearFile() {
    _currentClickedFile = null;
    _isFileClicked = false;
    _isCameraOpen = true;
    _showSaveButton = false;

    update();
  }

  String getAssessorRatings(String marksId) {
    switch (marksId) {
      case "1":
        return "Excellent";
      case "2":
        return "Very Good";
      case "3":
        return "Good";
      case "4":
        return "Average";
      case "5":
        return "Poor";
      case "6":
        return "No Answer";
      default:
        return "";
    }
  }

// database Entries methods here:

  Future<int?> insertCandidateDocuments(String? id) async {
    await Get.find<SplashController>().getLocation();
    if (id != null &&
        // _currentCandidateAdharBackPic != null &&
        _currentCandidateAdharFrontPic != null &&
        _currentCandidateProfilePhoto != null) {
      update();
      CandidateModel newCandidate = CandidateModel(
          type: "P",
          candidateId: id,
          assessorId: AppConstants.assessorId,
          latitude: AppConstants.locationInformation,
          longitude: "${AppConstants.latitude}, ${AppConstants.longitude}",
          candidateProfile: _currentCandidateProfilePhoto,
          candidateAadharBack: _currentCandidateAdharBackPic ?? "NA",
          candidateAadharFront: _currentCandidateAdharFrontPic);

      try {
        int insertedId = await dbHelper.insertCandidate(newCandidate);
        debugPrint('New candidate inserted with ID: $insertedId');
        await getCompletedDocumentsCandidatesList();
        update();
        return insertedId;
      } catch (e) {
        update();
        debugPrint('Error inserting candidate: $e');
      }
    }
    return null;
  }

  Future<void> getCompletedDocumentsCandidatesList() async {
    _completedDocuemntationList = await dbHelper.getCandidates();
  }

// inserting candidate viva question on entry
  Future<void> insertCandidatesVivaAnswersToDb(
      AssessorQuestionAnswersReplyModel candidateAnswer) async {
    String ratings = getAssessorRatings(candidateAnswer.assesorMarks ?? "");
    print("Ratings: ${candidateAnswer.assesorMarks}");
    await dbHelper.insertCandidatesVivaAnswersReply(candidateAnswer);

    List<AssessorQuestionAnswersReplyModel> insertedAnswers =
        await dbHelper.getCandidatesVivaAnswers();

    print("Inserted Answers Length Printed Here: ${insertedAnswers.length}");
  }

// inserting candidate practicle question on entry
  Future<void> insertCandidatesPracticleAnswersToDb(
      AssessorQuestionAnswersReplyModel candidateAnswer) async {
    String ratings = getAssessorRatings(candidateAnswer.assesorMarks ?? "");
    await dbHelper.insertCandidatesPracticleAnswersReply(candidateAnswer);

    List<AssessorQuestionAnswersReplyModel> insertedAnswers =
        await dbHelper.getCandidatesPracticleAnswers();

    print("Inserted Answers Length Printed Here: ${insertedAnswers.length}");
  }

  showLoaderForSavingPhoto(bool value) {
    _isSavingPhoto = value;
    update();
  }

// getting annexure documents list from the database
  Future<void> getAssessorDocumentsListFromDb() async {
    _assessorLocalDocumentsList = [];

    _assessorLocalDocumentsList
        .addAll(await DatabaseHelper().getAllAnnexureDocumentsList());

    print(
        "After Importing the List Length: ${_assessorLocalDocumentsList.length}");
    update();
  }

  // timer code

  // int? _questionTime;
  // int? get questionTime => _questionTime;

  late Timer _timer;

  Duration _currentTime = const Duration();
  Duration get currentTime => _currentTime;

  bool _isTimerStart = false;
  bool get isTimerStart => _isTimerStart;

  void startTimer(int questionTime) {
    _isTimerStart = true;
    _currentTime = Duration(seconds: questionTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime.inSeconds > 0) {
        _currentTime = _currentTime - const Duration(seconds: 1);
        update();
      } else {
        _timer.cancel();
        timerOver();
        _isTimerStart = false;
        update();
      }
    });
  }

  void timerOver() {
    stopRecording(isCandidateQuestions: true);
    update();
  }

  void cancelTimer() {
    _timer.cancel();
    resetTimer();
    _isTimerStart = false;
    update();
  }

  void resetTimer() {
    _currentTime = const Duration();
    update();
  }

// Annexure List Data Code

  // assessor center documents variables
  List<AssessorAnnexurelistUploadModel> _anexureUploadedList = [];
  List<AssessorAnnexurelistUploadModel> get anexureUploadedList =>
      _anexureUploadedList;

  Annexurelist? _currentSelectedAnnexure;
  Annexurelist? get currentSelectedAnnexure => _currentSelectedAnnexure;

  clearAnnexureList() {
    _anexureUploadedList.clear();
    update();
  }

  addToAnnexureList(AssessorAnnexurelistUploadModel annexure) {
    closeCamera();
    _anexureUploadedList.add(annexure);
    update();
    resetAnnexureDropdown();
  }

  changeVisibilityIfFilePickedUp() {
    _showSaveButton = false;
    _isFileClicked = false;
  }

  setAnnexureDropdownValue(Annexurelist currentValue) {
    _currentSelectedAnnexure = currentValue;
    update();
  }

  makeCurentSelectedDopdownNull() {
    _currentSelectedAnnexure = null;
    _currentClickedFile = null;
    update();
  }

  resetAnnexureDropdown() {
    if (currentClickedFile!.contains("file_picker")) {
      changeVisibilityIfFilePickedUp();
    } else {
      changeShowButtonVisibility();
    }
    _currentSelectedAnnexure = null;
    _currentClickedFile = null;

    print("_currentSelectedAnnexure value found is: $_currentSelectedAnnexure");
    print("_currentClickedFile value found is: $_currentClickedFile");

    update();
  }

  saveAnnexureListToLocalDatabase() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    for (int i = 0; i < _anexureUploadedList.length; i++) {
      dbHelper.insertAnnexureDocumentDatas(_anexureUploadedList[i]);
    }
    List<AssessorAnnexurelistUploadModel> _tempList =
        await dbHelper.getAllAnnexureDocumentsData();
    print(
        "After Inserting Annexure Documents list length is: ${_tempList.length}");
  }

  saveCenterDocumentsToSharedPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("profilePic", _currentAssessorProfilePhoto ?? "");
    _prefs.setString("aadharPic", _currentAssessorAdharPic ?? "");
    _prefs.setString("centerPic", _currentAssessorCenterPic ?? "");
    _prefs.setString("centerVideo", _currentAssessorCenterVideo ?? "");
    _prefs.setString("centerLocation", AppConstants.locationInformation);
    _prefs.setString("assessorDocsLatitude", AppConstants.latitude);
    _prefs.setString("assessorDocsLongitude", AppConstants.longitude);
  }

  getCenterDocumentsFromSharedPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _currentAssessorProfilePhoto = _prefs.getString("profilePic");
    _currentAssessorAdharPic = _prefs.getString("aadharPic");
    _currentAssessorCenterPic = _prefs.getString("centerPic");
    _currentAssessorCenterVideo = _prefs.getString("centerVideo");
    AppConstants.locationInformation = _prefs.getString("centerLocation") ?? "";
    AppConstants.latitude = _prefs.getString("assessorDocsLatitude") ?? "";
    AppConstants.longitude = _prefs.getString("assessorDocsLongitude") ?? "";

    AppConstants.lastCenterVideoTimeStamp = _prefs.getString(
          "assessorCenterVideo",
        ) ??
        "";

    print(
        "=========== Center Video Last Time Stamp Is ===========: ${AppConstants.lastCenterVideoTimeStamp}");

    if (_currentAssessorProfilePhoto != null &&
        _currentAssessorProfilePhoto != null &&
        _currentAssessorProfilePhoto != null &&
        _currentAssessorProfilePhoto != null) {
      final assessorDocumentsUploadModelTemp = AssessorDocumentsUploadModel(
        assessorInfo: AssessorInfo(
          // Server Time Sending Data
          time: AppConstants.lastCenterVideoTimeStamp,
          // Server Time Sending Data
          assessorId: int.parse(AppConstants.assessorId ?? ""),
          lat: AppConstants.locationInformation,
          long: "${AppConstants.latitude}, ${AppConstants.longitude}",
          assmentId: int.parse(AppConstants.assesmentId ?? ""),
        ),
        assessorCenterDocuments: AssessorCenterDocuments(
          assessorProfile: currentAssessorProfilePhoto,
          assessorAadhar: currentAssessorAdharPic,
          assessorCenterVideo: currentAssessorCenterVideo,
          assessorCenterPic: currentAssessorCenterPic,
          name: AppConstants.assessorName,
        ),
        assessorAnexureDocuments: AssessorAnexureDocuments(
          annexure: null,
          attendanceSheet: null,
          tPFeedbackForm: null,
          annexureM: null,
          assesmentCheckList: null,
          assessorFeedbackForm: null,
          assessorUndertaking: null,
          mannualOrBiometric: null,
        ),
        assessorOtherDocuments: AssessorOtherDocuments(
          otherDocumentsKey: [],
          otherDocumentsValue: [],
        ),
      );
      // replacing URL's
      final assessorDocumentsUploadModelTempWithReplacedUrl =
          AssessorDocumentsUploadModel(
        assessorInfo: AssessorInfo(
          // Server Time Sending Data
          time: AppConstants.lastCenterVideoTimeStamp,
          // Server Time Sending Data
          assessorId: int.parse(AppConstants.assessorId ?? ""),
          lat: AppConstants.locationInformation,
          long: "${AppConstants.latitude}, ${AppConstants.longitude}",
          assmentId: int.parse(AppConstants.assesmentId ?? ""),
        ),
        assessorCenterDocuments: AssessorCenterDocuments(
          assessorProfile: currentAssessorProfilePhoto!
              .replaceFirst(AppConstants.replacementPath, ""),
          assessorAadhar: currentAssessorAdharPic!
              .replaceFirst(AppConstants.replacementPath, ""),
          assessorCenterVideo: currentAssessorCenterVideo!
              .replaceFirst(AppConstants.replacementPath, ""),
          assessorCenterPic: currentAssessorCenterPic!
              .replaceFirst(AppConstants.replacementPath, ""),
          name: AppConstants.assessorName,
        ),
        assessorAnexureDocuments: AssessorAnexureDocuments(
          annexure: null,
          attendanceSheet: null,
          tPFeedbackForm: null,
          annexureM: null,
          assesmentCheckList: null,
          assessorFeedbackForm: null,
          assessorUndertaking: null,
          mannualOrBiometric: null,
        ),
        assessorOtherDocuments: AssessorOtherDocuments(
          otherDocumentsKey: [],
          otherDocumentsValue: [],
        ),
      );
      AppConstants.assessorDocumentsUploadModel =
          assessorDocumentsUploadModelTemp;
      AppConstants.assessorDocumentsUploadModelwithReplacedUrl =
          assessorDocumentsUploadModelTempWithReplacedUrl;
    }

    update();
  }

  loadLastSubmittedCenterDocuments() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _currentAssessorProfilePhoto = _prefs.getString("profilePic");
    _currentAssessorAdharPic = _prefs.getString("aadharPic");
    _currentAssessorCenterPic = _prefs.getString("centerPic");
    _currentAssessorCenterVideo = _prefs.getString("centerVideo");

    List<AssessorAnnexurelistUploadModel> assessorAnnexureDocumentsList =
        await dbHelper.getAllAnnexureDocumentsData();
    if (assessorAnnexureDocumentsList.isNotEmpty) {
      _anexureUploadedList = [];
      _anexureUploadedList.addAll(assessorAnnexureDocumentsList);
    }
    update();
  }

  // Code for the Video Timer
  bool isRecordingRunning = false;
  int totalSeconds = 0;
  late Timer timer;

  void startRecordingTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      totalSeconds++;
      update();
    });
  }

  void stopRecordingTimer() {
    timer.cancel();
    update();
  }

  void resetRecordingTimer() {
    timer.cancel();
    totalSeconds = 0;
    isRecordingRunning = false;
    update();
  }

  String getFormattedTime() {
    int minutes = (totalSeconds ~/ 60);
    int seconds = totalSeconds % 60;
    String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  Future<void> addWatermarkToImage(String imagePath) async {
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
    final textY3 = imageCopy.height - 90; // Adjust the Y position of the text

    // Draw the shadow text multiple times to create a bolder effect
    for (int i = 1; i <= 3; i++) {
      img.drawString(imageCopy, font, textX + i, textY + i, text,
          color: shadowColor);
      img.drawString(imageCopy, font, textX2 + i, textY2 + i, text2,
          color: shadowColor);
      img.drawString(imageCopy, font, textX3 + i, textY3 + i, text3,
          color: shadowColor);
    }

    // Draw the actual text
    img.drawString(imageCopy, font, textX, textY, text, color: color);
    img.drawString(imageCopy, font, textX2, textY2, text2, color: color);
    img.drawString(imageCopy, font, textX3, textY3, text3, color: color);

    // Save the new image with text watermark
    _currentClickedFile = imagePath;

    File(_currentClickedFile!).writeAsBytesSync(img.encodePng(imageCopy));
    update();
  }

// File Picker Code
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'bmp',
          'tiff',
          'webp',
          'svg'
        ]);

    if (result != null) {
      _currentClickedFile = result.files.single.path!;
      print("Picked file: $_currentClickedFile");
      update();
      // Handle the picked file as needed
    } else {
      // User canceled the picker
      print("File picking canceled");
    }
  }

  // exam date time code
  String? _candidateVivaStartTime;
  String? get candidateVivaStartTime => _candidateVivaStartTime;

  String? _candidateVivaEndTime;
  String? get candidateVivaEndTime => _candidateVivaEndTime;

  String? _candidateVivaStartDate;
  String? get candidateVivaStartDate => _candidateVivaStartDate;

  setCandidateVivaStartTime(String time) {
    _candidateVivaStartTime = time;
    print(_candidateVivaStartTime);
    update();
  }

  setCandidateVivaEndTime(String time) {
    _candidateVivaEndTime = time;
    print(_candidateVivaEndTime);

    update();
  }

  setCandidateVivaStartDate(String date) {
    _candidateVivaStartDate = date;
    print(_candidateVivaStartDate);

    update();
  }

  String? _candidatePracticalStartTime;
  String? get candidatePracticalStartTime => _candidatePracticalStartTime;

  String? _candidatePracticalEndTime;
  String? get candidatePracticalEndTime => _candidatePracticalEndTime;

  String? _candidatePracticalStartDate;
  String? get candidatePracticalStartDate => _candidatePracticalStartDate;

  setCandidatePracticalStartTime(String time) {
    _candidatePracticalStartTime = time;
    print(_candidatePracticalStartTime);
    update();
  }

  setCandidatePracticalEndTime(String time) {
    _candidatePracticalEndTime = time;
    print(_candidatePracticalEndTime);

    update();
  }

  setCandidatePracticalStartDate(String date) {
    _candidatePracticalStartDate = date;
    print(_candidatePracticalStartDate);

    update();
  }

  // exam date time code

  // group pratical viva code
  Batches? _selectedGroupOngoingCandidate;
  Batches? get selectedGroupOngoingCandidate => _selectedGroupOngoingCandidate;

  VivaPracticalMarkingModel? _selectedGroupCandidateMarksByAssessor;
  VivaPracticalMarkingModel? get selectedGroupCandidateMarksByAssessor =>
      _selectedGroupCandidateMarksByAssessor;

  List<AssessorQuestionAnswersReplyModel> _groupCandidateAnswersList = [];
  List<AssessorQuestionAnswersReplyModel> get groupCandidateAnswersList =>
      _groupCandidateAnswersList;

  setSelectedCandidateFromGroup(Batches? candidate) {
    _selectedGroupCandidateMarksByAssessor = null;
    _selectedGroupOngoingCandidate = candidate;
    update();
  }

  rateGroupStudentMarksByAssessor(
      VivaPracticalMarkingModel? marks, Batches candidate, String questionId,
      {isViva = true}) {
    _selectedGroupCandidateMarksByAssessor = marks;
    if (isViva == true) {
      addToGroupCandidatesAnswerList(
          AssessorQuestionAnswersReplyModel(
            // lat: AppConstants.latitude,
            // long: AppConstants.longitude,
            // timeTaken: "2:30",
            lat: "${AppConstants.latitude}, ${AppConstants.longitude}",
            long: AppConstants.longitude,
            timeTaken:
                "${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.date}, ${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.time}",
            marksTitle: selectedGroupCandidateMarksByAssessor!.title.toString(),
            assesmentId: int.parse(AppConstants.assesmentId.toString()),
            assesorMarks:
                selectedGroupCandidateMarksByAssessor!.marks.toString(),
            assessorId: AppConstants.assessorId,
            questionId: questionId,
            videoUrl: _currentClickedFile,
            studentId: selectedGroupOngoingCandidate!.id,
            // exam date time code
            vDate: candidateVivaStartDate,
            vEndTime: AppConstants.getFormatedCurrentTime(DateTime.now()),
            vStartTime: candidateVivaStartTime,
            pDate: 'null',
            pEndTime: 'null',
            pStartTime: 'null',
            // exam date time code
          ),
          candidate);
    } else {
      addToGroupCandidatesAnswerList(
          AssessorQuestionAnswersReplyModel(
            // lat: AppConstants.latitude,
            // long: AppConstants.longitude,
            // timeTaken: "2:30",
            lat: "${AppConstants.latitude}, ${AppConstants.longitude}",
            long: AppConstants.longitude,
            timeTaken:
                "${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.date}, ${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.time}",
            marksTitle: selectedGroupCandidateMarksByAssessor!.title.toString(),
            assesmentId: int.parse(AppConstants.assesmentId.toString()),
            assesorMarks:
                selectedGroupCandidateMarksByAssessor!.marks.toString(),
            assessorId: AppConstants.assessorId,
            questionId: questionId,
            videoUrl: _currentClickedFile,
            studentId: selectedGroupOngoingCandidate!.id,
            // exam date time code
            vDate: 'null',
            vEndTime: 'null',
            vStartTime: 'null',
            pDate: candidatePracticalStartDate,
            pEndTime: AppConstants.getFormatedCurrentTime(DateTime.now()),
            pStartTime: candidatePracticalStartTime,
            // exam date time code
          ),
          candidate);
    }
    update();
  }

  addToGroupCandidatesAnswerList(
      AssessorQuestionAnswersReplyModel answer, Batches candidate) {
    if (ifRatingAlreadyGivenForCandidateUpdate(candidate) == true) {
      for (int i = 0; i < _groupCandidateAnswersList.length; i++) {}
    } else {
      _groupCandidateAnswersList.add(answer);
    }

    print(
        "Total Answers Submited for the Group: ${_groupCandidateAnswersList.length}");
    update();
  }

  bool ifRatingAlreadyGivenForCandidateUpdate(Batches candidate) {
    for (int i = 0; i < _groupCandidateAnswersList.length; i++) {
      if (_groupCandidateAnswersList[i].studentId == candidate.id) {
        _groupCandidateAnswersList[i].marksTitle =
            _selectedGroupCandidateMarksByAssessor!.title;
        _groupCandidateAnswersList[i].assesorMarks =
            _selectedGroupCandidateMarksByAssessor!.marks;

        _groupCandidateAnswersList[i].videoUrl = _currentClickedFile;
        return true;
      }
    }
    return false;
  }

  void setGroupCandidateLastMarking(Batches candidate) {
    VivaPracticalMarkingModel? tempModel;
    for (int i = 0; i < _groupCandidateAnswersList.length; i++) {
      if (candidate.id == _groupCandidateAnswersList[i].studentId) {
        tempModel = VivaPracticalMarkingModel(
            marks: _groupCandidateAnswersList[i].assesorMarks,
            title: _groupCandidateAnswersList[i].marksTitle);
      }
    }
    _selectedGroupCandidateMarksByAssessor = tempModel;
    update();
  }

  // getOptionIndex(
  //     VivaPracticalMarkingModel selectedGroupCandidateMarksByAssessor) {
  //   for (int i = 0; i < _customRatingOptionsList.length; i++) {
  //     if (selectedGroupCandidateMarksByAssessor.title ==
  //         _customRatingOptionsList[i].title) {
  //       return i;
  //     }
  //   }
  // }

  resetGroupCandidateMarks() {
    _selectedGroupCandidateMarksByAssessor = null;
    _groupCandidateAnswersList = [];
    update();
  }

  // setEndDateAndTimeOfGroup() {}

  insertAllGroupCandidateDataToLocalDatabase({isViva = true}) async {
    if (isViva == true) {
      for (int i = 0; i < _groupCandidateAnswersList.length; i++) {
        // Inserting to the local database to the list of answers
        _groupCandidateAnswersList[i].vEndTime =
            AppConstants.getFormatedCurrentTime(DateTime.now());
        print(_groupCandidateAnswersList[i].videoUrl);
        await insertCandidatesVivaAnswersToDb(_groupCandidateAnswersList[i]);
      }
    } else {
      for (int i = 0; i < _groupCandidateAnswersList.length; i++) {
        // Inserting to the local database to the list of answers
        print(_groupCandidateAnswersList[i].videoUrl);
        _groupCandidateAnswersList[i].pEndTime =
            AppConstants.getFormatedCurrentTime(DateTime.now());
        print(_groupCandidateAnswersList[i].pEndTime);
        await insertCandidatesPracticleAnswersToDb(
            _groupCandidateAnswersList[i]);
      }
    }
  }

  insertOnlyTotalMarkingOfGroupCandidates(
      List<Batches> candidates, List<PQuestions> pQuestions) async {
    print("Current Practical Question Is: $_currentPracticleQuestion");
    for (int i = 0; i < candidates.length; i++) {
      await insertCandidatesPracticleAnswersToDb(
          AssessorQuestionAnswersReplyModel(
        // lat: AppConstants.latitude,
        // long: AppConstants.longitude,
        // timeTaken: "2:30",
        // marksTitle: "",
        lat: "${AppConstants.latitude}, ${AppConstants.longitude}",
        long: AppConstants.longitude,
        timeTaken:
            "${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.date}, ${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.time}",
        assesmentId: int.parse(AppConstants.assesmentId.toString()),
        assesorMarks:
            getOnlySpecificTotalStepRating(candidates[i].id.toString())
                .toString(),
        assessorId: AppConstants.assessorId,
        questionId: pQuestions[_currentPracticleQuestion].id,
        videoUrl: currentClickedFile,
        studentId: candidates[i].id,
        // exam date time code
        vDate: 'null',
        vEndTime: 'null',
        vStartTime: 'null',
        pDate: candidatePracticalStartDate,
        pEndTime: AppConstants.getFormatedCurrentTime(DateTime.now()),
        pStartTime: candidatePracticalStartTime,
        // exam date time code
      ));

      // Inserting to the local database to the list of answers
      // print(_groupCandidateAnswersList[i].videoUrl);
      // _groupCandidateAnswersList[i].pEndTime =
      //     AppConstants.getFormatedCurrentTime(DateTime.now());
      // print(_groupCandidateAnswersList[i].pEndTime);
      // await insertCandidatesPracticleAnswersToDb(_groupCandidateAnswersList[i]);
    }
  }

  // step wise marking code
  List<QuestionStepsModel> _currentQuestionStepsList = [];
  List<QuestionStepsModel> get currentQuestionStepsList =>
      _currentQuestionStepsList;

  getSpecificQuestionSteps(String questionId) async {
    _currentQuestionStepsList = [];
    List<QuestionStepsModel> tempQuestionStepsList = [];
    tempQuestionStepsList = await DatabaseHelper().getAllQuestionSteps();

    for (int i = 0; i < tempQuestionStepsList.length; i++) {
      if (questionId == tempQuestionStepsList[i].questionId) {
        _currentQuestionStepsList.add(tempQuestionStepsList[i]);
      }
    }
    update();
  }

  int _currentStepToShow = 0;
  int get currentStepToShow => _currentStepToShow;

  List<QuestionStepMarkingAnswerModel> _currentQuestionStepAnswersList = [];
  List<QuestionStepMarkingAnswerModel> get currentQuestionStepAnswersList =>
      _currentQuestionStepAnswersList;

  VivaPracticalMarkingModel? _selectedStepMarksByAssessor;
  VivaPracticalMarkingModel? get selectedStepMarksByAssessor =>
      _selectedStepMarksByAssessor;

  loadQuestionNextStep(Batches? candidate, {bool isGroup = false}) {
    ++_currentStepToShow;
    // _selectedStepMarksByAssessor = null;

    _selectedStepMarksByAssessor = getLastStepRating(
        _currentQuestionStepsList[_currentStepToShow].stepId.toString(),
        isGroup: isGroup,
        candidate);

    update();
  }

  loadQuestionPreviousStep(Batches? candidate, {bool isGroup = false}) {
    --_currentStepToShow;
    // _selectedStepMarksByAssessor = null;

    _selectedStepMarksByAssessor = getLastStepRating(
        _currentQuestionStepsList[_currentStepToShow].stepId.toString(),
        isGroup: isGroup,
        candidate);

    update();
  }

  updateLastAnswer(Batches? candidate) {
    if (_currentQuestionStepsList.isNotEmpty) {
      _selectedStepMarksByAssessor = getLastStepRating(
          _currentQuestionStepsList[_currentStepToShow].stepId.toString(),
          isGroup: true,
          candidate);
    }

    update();
  }

  addToStepMarkingList(Batches candidate, String type, {bool isGroup = false}) {
    if (ifStepsMarkAlreadyGiven(
            _currentQuestionStepsList[_currentStepToShow].stepId.toString(),
            isGroup: isGroup) ==
        false) {
      QuestionStepMarkingAnswerModel questionStepMarkingAnswerModel =
          QuestionStepMarkingAnswerModel(
              assessId: _currentQuestionStepsList[_currentStepToShow].assessId,
              questionId:
                  _currentQuestionStepsList[_currentStepToShow].questionId,
              candidateId: candidate.id,
              answerType: type,
              marksByAssessor: calculateCandidateMarksOfSteps(
                  _selectedStepMarksByAssessor!.marks,
                  _currentQuestionStepsList[_currentStepToShow].sMark),
              sTitle: _currentQuestionStepsList[_currentStepToShow].sTitle,
              stepId: _currentQuestionStepsList[_currentStepToShow].stepId,
              markingTitle: _selectedStepMarksByAssessor!.title);
      _currentQuestionStepAnswersList.add(questionStepMarkingAnswerModel);
    }
    print(
        "Length of the Step Answers List: ${_currentQuestionStepAnswersList.length}");
    update();
  }

  String calculateCandidateMarksOfSteps(
      String? assessorMarks, String? stepMarks) {
    if (assessorMarks != null && stepMarks != null) {
      double tempAssessorMarks = double.parse(assessorMarks);
      double tempStepMarks = double.parse(stepMarks);

      double finalMarks = tempAssessorMarks * tempStepMarks / 100;
      return finalMarks.toString();
    }
    return "0.0";
  }

  VivaPracticalMarkingModel? getLastStepRating(stepId, Batches? candidate,
      {bool isGroup = false}) {
    if (isGroup == true) {
      for (int i = 0; i < _currentQuestionStepAnswersList.length; i++) {
        if (_currentQuestionStepAnswersList[i].stepId == stepId &&
            candidate!.id == _currentQuestionStepAnswersList[i].candidateId) {
          VivaPracticalMarkingModel? tempAnswer = VivaPracticalMarkingModel(
              marks: _currentQuestionStepAnswersList[i].marksByAssessor,
              title: _currentQuestionStepAnswersList[i].markingTitle);

          print("Returning");
          print(currentQuestionStepAnswersList[i].marksByAssessor);
          print(currentQuestionStepAnswersList[i].markingTitle);

          return tempAnswer;
        }
      }

      print("Returning null");
      return null;
    } else {
      for (int i = 0; i < _currentQuestionStepAnswersList.length; i++) {
        if (_currentQuestionStepAnswersList[i].stepId == stepId) {
          VivaPracticalMarkingModel? tempAnswer = VivaPracticalMarkingModel(
              marks: _currentQuestionStepAnswersList[i].marksByAssessor,
              title: _currentQuestionStepAnswersList[i].markingTitle);

          print("Returning");
          print(currentQuestionStepAnswersList[i].marksByAssessor);
          print(currentQuestionStepAnswersList[i].markingTitle);

          return tempAnswer;
        }
      }

      print("Returning null");
      return null;
    }
  }

  bool ifStepsMarkAlreadyGiven(String stepId, {bool isGroup = false}) {
    if (isGroup == true && _selectedGroupOngoingCandidate != null) {
      for (int i = 0; i < _currentQuestionStepAnswersList.length; i++) {
        if (_currentQuestionStepAnswersList[i].stepId == stepId &&
            _selectedGroupOngoingCandidate!.id ==
                _currentQuestionStepAnswersList[i].candidateId) {
          _currentQuestionStepAnswersList[i].marksByAssessor =
              calculateCandidateMarksOfSteps(
                  _selectedStepMarksByAssessor!.marks,
                  _currentQuestionStepsList[_currentStepToShow].sMark);
          _currentQuestionStepAnswersList[i].markingTitle =
              _selectedStepMarksByAssessor!.title;
          return true;
        }
      }
      return false;
    } else {
      for (int i = 0; i < _currentQuestionStepAnswersList.length; i++) {
        if (_currentQuestionStepAnswersList[i].stepId == stepId) {
          _currentQuestionStepAnswersList[i].marksByAssessor =
              calculateCandidateMarksOfSteps(
                  _selectedStepMarksByAssessor!.marks,
                  _currentQuestionStepsList[_currentStepToShow].sMark);
          _currentQuestionStepAnswersList[i].markingTitle =
              _selectedStepMarksByAssessor!.title;
          return true;
        }
      }
      return false;
    }
  }

  rateStudentStepWiseMarkingByAssessor(VivaPracticalMarkingModel? marks) {
    _selectedStepMarksByAssessor = marks;
    update();
  }

  resetStepsAndMarkings() {
    _selectedStepMarksByAssessor = null;
    _currentQuestionStepAnswersList = [];
    _currentStepToShow = 0;
  }

  resetStepsAndMarkingsForGroupCandidate() {
    _selectedStepMarksByAssessor = null;
    _currentStepToShow = 0;
    update();
  }

  insertStepAnswersToDatabase() async {
    for (int i = 0; i < _currentQuestionStepAnswersList.length; i++) {
      print(
          "Insering Step Id is: ${_currentQuestionStepAnswersList[i].stepId}");
      await DatabaseHelper()
          .insertStepAnswer(_currentQuestionStepAnswersList[i]);
    }
  }

  bool isCandidateStepMarkingDone(String candidateId) {
    int count = 0;
    for (int i = 0; i < _currentQuestionStepAnswersList.length; i++) {
      if (_currentQuestionStepAnswersList[i].candidateId == candidateId) {
        count++;
      }
    }
    if (count == _currentQuestionStepsList.length) {
      return true;
    } else {
      return false;
    }
  }

  bool isCandidateOverAllMarkingDone(String candidateId) {
    for (int i = 0; i < _groupCandidateAnswersList.length; i++) {
      if (_groupCandidateAnswersList[i].studentId == candidateId) {
        return true;
      }
    }
    return false;
  }

  double getTotalStepRating() {
    double totalMarks = 0;
    for (int i = 0; i < _currentQuestionStepAnswersList.length; i++) {
      print(_currentQuestionStepAnswersList[i].marksByAssessor);
      if (_currentQuestionStepAnswersList[i].marksByAssessor != null) {
        totalMarks = totalMarks +
            double.parse(
                _currentQuestionStepAnswersList[i].marksByAssessor.toString());
      }
    }
    return totalMarks;
  }

  double getOnlySpecificTotalStepRating(String candidateId) {
    double totalMarks = 0;
    for (int i = 0; i < _currentQuestionStepAnswersList.length; i++) {
      if (candidateId == _currentQuestionStepAnswersList[i].candidateId) {
        if (_currentQuestionStepAnswersList[i].marksByAssessor != null) {
          totalMarks = totalMarks +
              double.parse(_currentQuestionStepAnswersList[i]
                  .marksByAssessor
                  .toString());
        }
      }
    }
    return totalMarks;
  }
  // step wise marking code

  updateCandidatePracticalOrVivaFlag(String type, Batches batch) {
    print("UPDATING THE FLAG FOR THE CANDIDATE");

    Batches temp = Batches(
        assmentId: batch.assmentId,
        enrollmentNo: batch.enrollmentNo,
        id: batch.id,
        institutionID: batch.institutionID,
        isPracticalDone: type == "P" ? "Y" : batch.isPracticalDone,
        isTheoryDone: batch.isTheoryDone,
        isVivaDone: type == "V" ? "Y" : batch.isVivaDone,
        name: batch.name,
        password: batch.password,
        userEmail: batch.userEmail,
        pImg: batch.pImg,
        vImg: batch.vImg);
    dbHelper.updateBatch(temp);
  }

  updateCandidatePracticalOrVivaDocumentsFlag(String type, Batches batch) {
    Batches temp = Batches(
        assmentId: batch.assmentId,
        enrollmentNo: batch.enrollmentNo,
        id: batch.id,
        institutionID: batch.institutionID,
        isPracticalDone: batch.isPracticalDone,
        isTheoryDone: batch.isTheoryDone,
        isVivaDone: batch.isVivaDone,
        name: batch.name,
        password: batch.password,
        userEmail: batch.userEmail,
        pImg: type == "P" ? "1" : batch.pImg,
        vImg: type == "V" ? "1" : batch.vImg);
    dbHelper.updateBatch(temp);
  }

// Get Assessor Documents List Online
  List<OnlineAnnexureDetailsModel> _alreadySynedAssessorDocumentsList = [];
  List<OnlineAnnexureDetailsModel> get alreadySynedAssessorDocumentsList =>
      _alreadySynedAssessorDocumentsList;

  Future<bool> getAssessorOnlineSubmittedDocumentsList() async {
    _alreadySynedAssessorDocumentsList = [];
    _isLoadingResponse = true;
    update();

    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.getAlreadySyncedAssessorDocumentsModel}?assmentId=${AppConstants.assesmentId}");

      AlreadySyncedAnnexure alreadySyncedAnnexure =
          AlreadySyncedAnnexure.fromJson(response);

      if (response['row'] == 1) {
        _alreadySynedAssessorDocumentsList.addAll(alreadySyncedAnnexure.result
            as Iterable<OnlineAnnexureDetailsModel>);
        print(
            "Synced Candidates List Length is: ${_alreadySynedAssessorDocumentsList.length}");

        _isLoadingResponse = false;
        update();
        return true;
      } else {
        _isLoadingResponse = false;
        update();
        return false;
      }
    } catch (e) {
      print("Exception Occured: $e");
      CustomToast.showToast("Failed to Get the Submitted Documents");
      _isLoadingResponse = false;
      update();
      return false;
    }
  }

  deleteAssessorUploadedDocumentsOffline() async {
    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.deleteAssessorUploadedDocumentOffline}?assmentId=${AppConstants.assesmentId}");

      print("Deleting Assrssor Documnets Here: $response");
    } catch (e) {
      print("Exception Occured: $e");
      CustomToast.showToast("Failed to Delete Assessor Documents");
      _isLoadingResponse = false;
      update();
      return false;
    }
  }

  getSpecificUploadedAssessorDocuments(String title) {
    switch (title) {
      case "Profile Pic":
        return getSpecificUrlFromUploadedDocs("Assessor Profile");
      case "Aadhar Pic":
        return getSpecificUrlFromUploadedDocs("Assessor Aadhar");
      case "Center Pic":
        return getSpecificUrlFromUploadedDocs("Center Pic");
      case "Center Video":
        return getSpecificUrlFromUploadedDocs("Center Video");
    }
  }

  String? getSpecificUrlFromUploadedDocs(String title) {
    for (int i = 0; i < _alreadySynedAssessorDocumentsList.length; i++) {
      if (title == _alreadySynedAssessorDocumentsList[i].caption) {
        return _alreadySynedAssessorDocumentsList[i].captionVal.toString();
      }
    }
    return null;
  }

  removeFromAlreadySyncedList(String title) {
    for (int i = 0; i < _alreadySynedAssessorDocumentsList.length; i++) {
      print(_alreadySynedAssessorDocumentsList[i].caption);
      if (title == _alreadySynedAssessorDocumentsList[i].caption) {
        _alreadySynedAssessorDocumentsList
            .remove(_alreadySynedAssessorDocumentsList[i]);
      }
    }
  }

  removeFromAnexureLocalUploadedList(
      AssessorAnnexurelistUploadModel document) async {
    await DatabaseHelper().deleteAnnexureDocumentData(document.image!);
    _anexureUploadedList.remove(document);
    update();
  }

  dynamic canStopTheVideo(
      {List<PQuestions>? pQuestions, List<VQuestions>? vQuestions}) {
    if (pQuestions != null) {
      int pTime = pQuestions[_currentPracticleQuestion].questime != "" &&
              pQuestions[_currentPracticleQuestion].questime != null
          ? int.parse(pQuestions[_currentPracticleQuestion].questime.toString())
          : 60;
      print("Practical Question Time Is: ---------------- : $pTime");

      if (pTime > 60) {
        print("Practical Question Time Is: ${_currentTime.inSeconds}");

        if (pTime - _currentTime.inSeconds >= 60) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else if (vQuestions != null) {
      int vTime = vQuestions[_currentVivaQuestion].questime != "" &&
              vQuestions[_currentVivaQuestion].questime != null
          ? int.parse(vQuestions[_currentVivaQuestion].questime.toString())
          : 60;
      if (vTime > 60) {
        if (vTime - _currentTime.inSeconds >= 60) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
// Get Assessor Documents List Online
}
