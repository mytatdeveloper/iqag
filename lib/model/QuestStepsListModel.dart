class QuestStepsListModel {
  List<QuestionStepsModel>? steps;

  QuestStepsListModel({this.steps});

  QuestStepsListModel.fromJson(Map<String, dynamic> json) {
    if (json['steps'] != null) {
      steps = <QuestionStepsModel>[];
      json['steps'].forEach((v) {
        steps!.add(QuestionStepsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionStepsModel {
  String? stepId;
  String? assessId;
  String? questionId;
  String? sTitle;
  String? sMark;

  QuestionStepsModel(
      {this.stepId, this.assessId, this.questionId, this.sTitle, this.sMark});

  QuestionStepsModel.fromJson(Map<String, dynamic> json) {
    stepId = json['step_id'];
    assessId = json['assess_id'];
    questionId = json['question_id'];
    sTitle = json['s_title'];
    sMark = json['s_mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['step_id'] = stepId;
    data['assess_id'] = assessId;
    data['question_id'] = questionId;
    data['s_title'] = sTitle;
    data['s_mark'] = sMark;
    return data;
  }
}
