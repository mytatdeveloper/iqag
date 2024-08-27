class CandidateMCQAnswersModel {
  List<McqAnswers>? mcqAnswers;

  CandidateMCQAnswersModel({this.mcqAnswers});

  CandidateMCQAnswersModel.fromJson(Map<String, dynamic> json) {
    if (json['mcqAnswers'] != null) {
      mcqAnswers = <McqAnswers>[];
      json['mcqAnswers'].forEach((v) {
        mcqAnswers!.add(McqAnswers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mcqAnswers != null) {
      data['mcqAnswers'] = mcqAnswers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class McqAnswers {
  int? id;
  String? questionId;
  String? answerId;
  String? candidateId;
  int? markForReview;
  String? assessmentId;
  String? answerTime;

  McqAnswers(
      {this.questionId,
      this.answerId,
      this.candidateId,
      this.markForReview,
      this.id,
      this.assessmentId,
      this.answerTime});

  McqAnswers.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    answerId = json['answerId'];
    candidateId = json['candidateId'];
    markForReview = json['markForReview'];
    id = json['id'];
    assessmentId = json['assessmentId'];
    answerTime = json['answerTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionId'] = questionId;
    data['answerId'] = answerId;
    data['candidateId'] = candidateId;
    data['markForReview'] = markForReview;
    data['id'] = id;
    data['assessmentId'] = assessmentId;
    data['answerTime'] = answerTime;
    return data;
  }
}
