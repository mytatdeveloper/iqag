class FeedbackAnswersModel {
  String? questionId;
  String? answer;
  String? candidateId;

  FeedbackAnswersModel({this.questionId, this.answer, this.candidateId});

  FeedbackAnswersModel.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    answer = json['answer'];
    candidateId = json['candidateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionId'] = questionId;
    data['answer'] = answer;
    data['candidateId'] = candidateId;
    return data;
  }
}
