class AssesmentQuestionsModel {
  List<MQuestions>? mQuestions;
  List<VQuestions>? vQuestions;
  List<PQuestions>? pQuestions;
  int? result;
  DurationModel? duration;

  AssesmentQuestionsModel({
    this.mQuestions,
    this.vQuestions,
    this.pQuestions,
    this.result,
    this.duration,
  });

  AssesmentQuestionsModel.fromJson(Map<String, dynamic> json) {
    if (json['mQuestions'] != null) {
      mQuestions = <MQuestions>[];
      json['mQuestions'].forEach((v) {
        mQuestions!.add(MQuestions.fromJson(v));
      });
    }
    if (json['vQuestions'] != null) {
      vQuestions = <VQuestions>[];
      json['vQuestions'].forEach((v) {
        vQuestions!.add(VQuestions.fromJson(v));
      });
    }
    if (json['pQuestions'] != null) {
      pQuestions = <PQuestions>[];
      json['pQuestions'].forEach((v) {
        pQuestions!.add(PQuestions.fromJson(v));
      });
    }
    result = json['result'];
    duration = DurationModel.fromJson(json['duration']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mQuestions != null) {
      data['mQuestions'] = mQuestions!.map((v) => v.toJson()).toList();
    }
    if (vQuestions != null) {
      data['vQuestions'] = vQuestions!.map((v) => v.toJson()).toList();
    }
    if (pQuestions != null) {
      data['pQuestions'] = pQuestions!.map((v) => v.toJson()).toList();
    }
    data['result'] = result;
    data['duration'] = duration?.toJson();
    return data;
  }
}

class MQuestions {
  String? id;
  String? questime;
  String? title;
  String? titleImg;
  String? marks;
  String? option1;
  String? option1Img;
  String? option2;
  String? option2Img;
  String? option3;
  String? option3Img;
  String? option4;
  String? option4Img;
  String? option5;
  String? option5Img;
  String? assmentId;
  String? masterId;

  MQuestions(
      {this.id,
      this.questime,
      this.title,
      this.titleImg,
      this.marks,
      this.option1,
      this.option1Img,
      this.option2,
      this.option2Img,
      this.option3,
      this.option3Img,
      this.option4,
      this.option4Img,
      this.option5,
      this.option5Img,
      this.assmentId,
      this.masterId});

  MQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questime = json['questime'];
    title = json['title'];
    titleImg = json['titleImg'];
    marks = json['marks'];
    option1 = json['option1'];
    option1Img = json['option1Img'];
    option2 = json['option2'];
    option2Img = json['option2Img'];
    option3 = json['option3'];
    option3Img = json['option3Img'];
    option4 = json['option4'];
    option4Img = json['option4Img'];
    option5 = json['option5'];
    option5Img = json['option5Img'];
    assmentId = json['assmentId'];
    masterId = json['masterqid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['questime'] = questime;
    data['title'] = title;
    data['titleImg'] = titleImg;
    data['marks'] = marks;
    data['option1'] = option1;
    data['option1Img'] = option1Img;
    data['option2'] = option2;
    data['option2Img'] = option2Img;
    data['option3'] = option3;
    data['option3Img'] = option3Img;
    data['option4'] = option4;
    data['option4Img'] = option4Img;
    data['option5'] = option5;
    data['option5Img'] = option5Img;
    data['assmentId'] = assmentId;
    data['masterqid'] = masterId;

    return data;
  }
}

class VQuestions {
  String? id;
  String? questime;
  String? title;
  String? titleImg;
  String? marks;
  String? option1;
  String? option1Img;
  String? option2;
  String? option2Img;
  String? option3;
  String? option3Img;
  String? option4;
  String? option4Img;
  String? assmentId;
  String? masterId;

  VQuestions(
      {this.id,
      this.questime,
      this.title,
      this.titleImg,
      this.marks,
      this.option1,
      this.option1Img,
      this.option2,
      this.option2Img,
      this.option3,
      this.option3Img,
      this.option4,
      this.option4Img,
      this.assmentId,
      this.masterId});

  VQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questime = json['questime'];
    title = json['title'];
    titleImg = json['titleImg'];
    marks = json['marks'];
    option1 = json['option1'];
    option1Img = json['option1Img'];
    option2 = json['option2'];
    option2Img = json['option2Img'];
    option3 = json['option3'];
    option3Img = json['option3Img'];
    option4 = json['option4'];
    option4Img = json['option4Img'];
    assmentId = json['assmentId'];
    masterId = json['masterqid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['questime'] = questime;
    data['title'] = title;
    data['titleImg'] = titleImg;
    data['marks'] = marks;
    data['option1'] = option1;
    data['option1Img'] = option1Img;
    data['option2'] = option2;
    data['option2Img'] = option2Img;
    data['option3'] = option3;
    data['option3Img'] = option3Img;
    data['option4'] = option4;
    data['option4Img'] = option4Img;
    data['assmentId'] = assmentId;
    data['masterqid'] = masterId;

    return data;
  }
}

class PQuestions {
  String? id;
  String? questime;
  String? title;
  String? titleImg;
  String? marks;
  String? option1;
  String? option1Img;
  String? option2;
  String? option2Img;
  String? option3;
  String? option3Img;
  String? option4;
  String? option4Img;
  String? assmentId;
  String? masterId;

  PQuestions(
      {this.id,
      this.questime,
      this.title,
      this.titleImg,
      this.marks,
      this.option1,
      this.option1Img,
      this.option2,
      this.option2Img,
      this.option3,
      this.option3Img,
      this.option4,
      this.option4Img,
      this.assmentId,
      this.masterId});

  PQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questime = json['questime'];
    title = json['title'];
    titleImg = json['titleImg'];
    marks = json['marks'];
    option1 = json['option1'];
    option1Img = json['option1Img'];
    option2 = json['option2'];
    option2Img = json['option2Img'];
    option3 = json['option3'];
    option3Img = json['option3Img'];
    option4 = json['option4'];
    option4Img = json['option4Img'];
    assmentId = json['assmentId'];
    masterId = json['masterqid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['questime'] = questime;
    data['title'] = title;
    data['titleImg'] = titleImg;
    data['marks'] = marks;
    data['option1'] = option1;
    data['option1Img'] = option1Img;
    data['option2'] = option2;
    data['option2Img'] = option2Img;
    data['option3'] = option3;
    data['option3Img'] = option3Img;
    data['option4'] = option4;
    data['option4Img'] = option4Img;
    data['assmentId'] = assmentId;
    data['masterqid'] = assmentId;
    return data;
  }
}

class DurationModel {
  String? assmentId;
  String? testDuration;
  String? imgInterval;
  String? assmentName;
  String? webProctoring;
  String? mandatoryQuestion;
  String? randomQuestions;
  String? tabSwitchesAllowed;
  String? numberTabSwitchesAllowed;
  String? vernacularLanguage;
  String? moveForward;
  String? appointedTime;
  String? appointedTimeDuration;
  String? tensorflow;
  String? accessLocation;
  String? screenshare;

  DurationModel(
      {this.assmentId,
      this.testDuration,
      this.imgInterval,
      this.assmentName,
      this.webProctoring,
      this.mandatoryQuestion,
      this.randomQuestions,
      this.tabSwitchesAllowed,
      this.numberTabSwitchesAllowed,
      this.vernacularLanguage,
      this.moveForward,
      this.appointedTime,
      this.appointedTimeDuration,
      this.tensorflow,
      this.accessLocation,
      this.screenshare});

  DurationModel.fromJson(Map<String, dynamic> json) {
    assmentId = json['assmentId'];
    testDuration = json['testDuration'];
    imgInterval = json['imgInterval'];
    assmentName = json['assmentName'];
    webProctoring = json['webProctoring'];
    mandatoryQuestion = json['mandatoryQuestion'];
    randomQuestions = json['randomQuestions'];
    tabSwitchesAllowed = json['tabSwitchesAllowed'];
    numberTabSwitchesAllowed = json['numberTabSwitchesAllowed'];
    vernacularLanguage = json['vernacularLanguage'];
    moveForward = json['moveForward'];
    appointedTime = json['appoint_time'];
    appointedTimeDuration = json['appointed_time_duration'];
    tensorflow = json['tensorflow'];
    accessLocation = json['access_location'];
    screenshare = json['screenshare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assmentId'] = assmentId;
    data['testDuration'] = testDuration;
    data['imgInterval'] = imgInterval;
    data['assmentName'] = assmentName;
    data['webProctoring'] = webProctoring;
    data['mandatoryQuestion'] = mandatoryQuestion;
    data['randomQuestions'] = randomQuestions;
    data['tabSwitchesAllowed'] = tabSwitchesAllowed;
    data['numberTabSwitchesAllowed'] = numberTabSwitchesAllowed;
    data['vernacularLanguage'] = vernacularLanguage;
    data['moveForward'] = moveForward;
    data['appoint_time'] = appointedTime;
    data['appointed_time_duration'] = appointedTimeDuration;
    data['tensorflow'] = tensorflow;
    data['access_location'] = accessLocation;
    data['screenshare'] = screenshare;

    return data;
  }
}
