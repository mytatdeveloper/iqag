class ApiEndpoints {
  static String serverinformation = "https://mytat.co/mapinew/checkDomain";
  static String baseUrl = "https://assessments.iqag.org";
  static String? ip;
  static String assessorLoginUrl = "/mapinew/assessorLogin?";
  static String getAssesmentQuestions = "/mapinew/assessorQ?";
  static String getBatch = "/mapinew/batch?";
  static String getassessorDocumentsList = "/mapinew/annexurelist/";
  static String candidateOnlineLogin = "/mapinew/studentLogin/?";
  static String getInstructions = "/mapinew/basicInfo/?assmentId=";
  static String getCompletedCandidateList = "/mapinew/testTakens/?assmentId=";

  // syncing api links:
  static String syncStudentDocuments = "/mapinew/syncStudentIds/";
  static String syncAssessorDocuments = "/mapinew/syncAssessorData";
  static String syncStudentsVivaAndPracticleAnswers = "/mapinew/synStudent/?";
  static String syncStudentMcqAnswers = "/mapinew/mcqSync/?";
  static String syncStudentMcqAnswersCompleteSync = "/mapinew/complete_sync/?";
  static String syncStudentsMcqScreenshots = "/mapinew/userimgsync/?";
  static String syncAssessorAnnexureDocuments = "/mapinew/annexureSync/?";

  static String getAllLangauages = "/mapinew/vernacularLang";

  static String getSyncedTheoryStatus = "/mapinew/syncStudentIdssuccessfull";
  static String getSyncedVivaPracticalStatus =
      "/mapinew/syncStudentIdsvivasuccessfull";

  static String getAllLanguagesAvailabeMcq = "/mapinew/questionlanguagelist?";
  static String getAllLanguagesAvailabeMcqWithQuestionsAndOptions =
      "/mapinew/assessorQMultilang?";
  static String getTotalAnswerSyncedOfCandidates = "/mapinew/checkpartialsync?";

  static String getAvailableVivaPracticalOptions =
      "/mapinew/dynamicoptionsvalues";
  static String getServerDateAndTime = "/mapinew/getserverdatetime";
  static String getFeedbackFormQuestions = "/mapinew/feedbackquestions";
  static String synCandidateFeedback = "/mapinew/submitfeedbackanswer";

  static String deleteExistingMcqOfCandidates = "/mapinew/mcqSyncdelete";
  static String getQuestionSteps = "/mapinew/stepwisequestions";

  static String syncPracticalVivaStepAnswer = "/mapinew/stepwiseanswers";

  static String syncFinalCandidateTime = "/mapinew/synStudentTimefinal";

// Get Assessor Documents List Online
  static String getAlreadySyncedAssessorDocumentsModel =
      "/mapinew/uploadeddocsbyassessor";

  static String deleteAssessorUploadedDocumentOffline =
      "/mapinew/annexureSyncdelete";

  static String deleteAssessorUploadedDocumentOnline =
      "/mapinew/annexureSyncdeletesingle";
//       assmentId
// title
// Get Assessor Documents List Online

  static var customHeaders = {
    'Cookie':
        'PHPSESSID=4doha82fl6mq0fovnbukmfsa1m; ci_session=a%3A5%3A%7Bs%3A10%3A%22session_id%22%3Bs%3A32%3A%225c5eef4902489ae24ba7d007619c8121%22%3Bs%3A10%3A%22ip_address%22%3Bs%3A12%3A%22117.98.8.194%22%3Bs%3A10%3A%22user_agent%22%3Bs%3A21%3A%22PostmanRuntime%2F7.32.2%22%3Bs%3A13%3A%22last_activity%22%3Bi%3A1690182817%3Bs%3A9%3A%22user_data%22%3Bs%3A0%3A%22%22%3B%7De39332ebadd82b2403946d119a819966'
  };
}
