class AssessorQuestionAnswersReplyModel {
  String? assessorId;
  int? assesmentId;
  String? questionId;
  String? studentId;
  String? lat;
  String? long;
  String? videoUrl;
  String? assesorMarks;
  String? timeTaken;
  String? marksTitle;
  // exam date time code
  String? pStartTime;
  String? pEndTime;
  String? vStartTime;
  String? vEndTime;
  String? pDate;
  String? vDate;
  // exam date time code

  AssessorQuestionAnswersReplyModel(
      {this.assessorId,
      this.assesmentId,
      this.questionId,
      this.studentId,
      this.lat,
      this.long,
      this.videoUrl,
      this.assesorMarks,
      this.timeTaken,
      this.marksTitle,
      // exam date time code
      this.pDate,
      this.pEndTime,
      this.pStartTime,
      this.vDate,
      this.vEndTime,
      this.vStartTime
      // exam date time code
      });

  AssessorQuestionAnswersReplyModel.fromJson(Map<String, dynamic> json) {
    assessorId = json['assessorId'];
    assesmentId = json['assesmentId'];
    questionId = json['questionId'];
    studentId = json['studentId'];
    lat = json['lat'];
    long = json['long'];
    videoUrl = json['videoUrl'];
    assesorMarks = json['assesorMarks'];
    timeTaken = json['timeTaken'];
    marksTitle = json['marksTitle'];
    // exam date time code
    pDate = json['pDate'];
    pEndTime = json['pEndTime'];
    pStartTime = json['pStartTime'];
    vDate = json['vDate'];
    vEndTime = json['vEndTime'];
    vStartTime = json['vStartTime'];
    // exam date time code
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assessorId'] = assessorId;
    data['assesmentId'] = assesmentId;
    data['questionId'] = questionId;
    data['studentId'] = studentId;
    data['lat'] = lat;
    data['long'] = long;
    data['videoUrl'] = videoUrl;
    data['assesorMarks'] = assesorMarks;
    data['timeTaken'] = timeTaken;
    data['marksTitle'] = marksTitle;
    // exam date time code
    data['pDate'] = pDate;
    data['pEndTime'] = pEndTime;
    data['pStartTime'] = pStartTime;
    data['vDate'] = vDate;
    data['vEndTime'] = vEndTime;
    data['vStartTime'] = vStartTime;
    // exam date time code

    return data;
  }
}
