class FeedbackFormQuestionsListModel {
  List<FeedbackQuestionModel>? questions;

  FeedbackFormQuestionsListModel({this.questions});

  FeedbackFormQuestionsListModel.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = <FeedbackQuestionModel>[];
      json['questions'].forEach((v) {
        questions!.add(FeedbackQuestionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedbackQuestionModel {
  String? bfqId;
  String? title;

  FeedbackQuestionModel({this.bfqId, this.title});

  FeedbackQuestionModel.fromJson(Map<String, dynamic> json) {
    bfqId = json['bfq_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bfq_id'] = bfqId;
    data['title'] = title;
    return data;
  }
}
