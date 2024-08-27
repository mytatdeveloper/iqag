class QuestionStepMarkingAnswerModel {
  String? stepId;
  String? assessId;
  String? questionId;
  String? sTitle;
  String? marksByAssessor;
  String? markingTitle;
  String? candidateId;
  String? answerType;

  QuestionStepMarkingAnswerModel({
    this.stepId,
    this.assessId,
    this.questionId,
    this.sTitle,
    this.marksByAssessor,
    this.markingTitle,
    this.candidateId,
    this.answerType,
  });

  QuestionStepMarkingAnswerModel.fromJson(Map<String, dynamic> json) {
    stepId = json['step_id'];
    assessId = json['assess_id'];
    questionId = json['question_id'];
    sTitle = json['s_title'];
    marksByAssessor = json['s_mark'];
    markingTitle = json['marking_title'];
    candidateId = json['candidateId'];
    answerType = json['answerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['step_id'] = stepId;
    data['assess_id'] = assessId;
    data['question_id'] = questionId;
    data['s_title'] = sTitle;
    data['s_mark'] = marksByAssessor;
    data['marking_title'] = markingTitle;
    data['candidateId'] = candidateId;
    data['answerType'] = answerType;

    return data;
  }
}
