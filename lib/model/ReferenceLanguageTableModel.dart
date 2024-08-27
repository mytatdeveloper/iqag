class ReferenceLanguageTableModel {
  int? result;
  List<MCQuestionsLanguageQuestion>? mQuestions;

  ReferenceLanguageTableModel({this.result, this.mQuestions});

  ReferenceLanguageTableModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['mQuestions'] != null) {
      mQuestions = <MCQuestionsLanguageQuestion>[];
      json['mQuestions'].forEach((v) {
        mQuestions!.add(MCQuestionsLanguageQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    if (mQuestions != null) {
      data['mQuestions'] = mQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MCQuestionsLanguageQuestion {
  String? question;
  String? langId;
  String? questionId;
  String? option1;
  String? option1Img;
  String? option2;
  String? option2Img;
  String? option3;
  String? option3Img;
  String? option4;
  String? option4Img;

  MCQuestionsLanguageQuestion(
      {this.question,
      this.langId,
      this.questionId,
      this.option1,
      this.option1Img,
      this.option2,
      this.option2Img,
      this.option3,
      this.option3Img,
      this.option4,
      this.option4Img});

  MCQuestionsLanguageQuestion.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    langId = json['langId'];
    questionId = json['question_id'];
    option1 = json['option1'];
    option1Img = json['option1Img'];
    option2 = json['option2'];
    option2Img = json['option2Img'];
    option3 = json['option3'];
    option3Img = json['option3Img'];
    option4 = json['option4'];
    option4Img = json['option4Img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['langId'] = langId;
    data['question_id'] = questionId;
    data['option1'] = option1;
    data['option1Img'] = option1Img;
    data['option2'] = option2;
    data['option2Img'] = option2Img;
    data['option3'] = option3;
    data['option3Img'] = option3Img;
    data['option4'] = option4;
    data['option4Img'] = option4Img;
    return data;
  }
}
