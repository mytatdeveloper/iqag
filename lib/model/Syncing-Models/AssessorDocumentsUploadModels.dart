class AssessorDocumentsUploadModel {
  AssessorInfo? assessorInfo;
  AssessorCenterDocuments? assessorCenterDocuments;
  AssessorAnexureDocuments? assessorAnexureDocuments;
  AssessorOtherDocuments? assessorOtherDocuments;
  // Server Time Sending Data
  AssessorDocumentsUploadModel(
      {this.assessorInfo,
      this.assessorCenterDocuments,
      this.assessorAnexureDocuments,
      this.assessorOtherDocuments});

  AssessorDocumentsUploadModel.fromJson(Map<String, dynamic> json) {
    assessorInfo = json['assessorInfo'] != null
        ? AssessorInfo.fromJson(json['assessorInfo'])
        : null;
    assessorCenterDocuments = json['assessorCenterDocuments'] != null
        ? AssessorCenterDocuments.fromJson(json['assessorCenterDocuments'])
        : null;
    assessorAnexureDocuments = json['assessorAnexureDocuments'] != null
        ? AssessorAnexureDocuments.fromJson(json['assessorAnexureDocuments'])
        : null;
    assessorOtherDocuments = json['assessorOtherDocuments'] != null
        ? AssessorOtherDocuments.fromJson(json['assessorOtherDocuments'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assessorInfo != null) {
      data['assessorInfo'] = assessorInfo!.toJson();
    }
    if (assessorCenterDocuments != null) {
      data['assessorCenterDocuments'] = assessorCenterDocuments!.toJson();
    }
    if (assessorAnexureDocuments != null) {
      data['assessorAnexureDocuments'] = assessorAnexureDocuments!.toJson();
    }
    if (assessorOtherDocuments != null) {
      data['assessorOtherDocuments'] = assessorOtherDocuments!.toJson();
    }
    return data;
  }
}

class AssessorInfo {
  int? assessorId;
  String? lat;
  String? long;
  int? assmentId;
  String? time;

  AssessorInfo(
      {this.assessorId, this.lat, this.long, this.assmentId, this.time});

  AssessorInfo.fromJson(Map<String, dynamic> json) {
    assessorId = json['assessorId'];
    lat = json['lat'];
    long = json['long'];
    assmentId = json['assmentId'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assessorId'] = assessorId;
    data['lat'] = lat;
    data['long'] = long;
    data['assmentId'] = assmentId;
    data['time'] = time;

    return data;
  }
}

class AssessorCenterDocuments {
  String? assessorProfile;
  String? assessorAadhar;
  String? assessorCenterVideo;
  String? assessorCenterPic;
  String? name;

  AssessorCenterDocuments(
      {this.assessorProfile,
      this.assessorAadhar,
      this.assessorCenterVideo,
      this.assessorCenterPic,
      this.name});

  AssessorCenterDocuments.fromJson(Map<String, dynamic> json) {
    assessorProfile = json['assessorProfile'];
    assessorAadhar = json['assessorAadhar'];
    assessorCenterVideo = json['assessorCenterVideo'];
    assessorCenterPic = json['assessorCenterPic'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assessorProfile'] = assessorProfile;
    data['assessorAadhar'] = assessorAadhar;
    data['assessorCenterVideo'] = assessorCenterVideo;
    data['assessorCenterPic'] = assessorCenterPic;
    data['name'] = name;
    return data;
  }
}

class AssessorAnexureDocuments {
  String? annexure;
  String? attendanceSheet;
  String? tPFeedbackForm;
  String? annexureM;
  String? assesmentCheckList;
  String? assessorFeedbackForm;
  String? assessorUndertaking;
  String? mannualOrBiometric;

  AssessorAnexureDocuments(
      {this.annexure,
      this.attendanceSheet,
      this.tPFeedbackForm,
      this.annexureM,
      this.assesmentCheckList,
      this.assessorFeedbackForm,
      this.assessorUndertaking,
      this.mannualOrBiometric});

  AssessorAnexureDocuments.fromJson(Map<String, dynamic> json) {
    annexure = json['annexure'];
    attendanceSheet = json['attendanceSheet'];
    tPFeedbackForm = json['tPFeedbackForm'];
    annexureM = json['annexureM'];
    assesmentCheckList = json['assesmentCheckList'];
    assessorFeedbackForm = json['assessorFeedbackForm'];
    assessorUndertaking = json['assessorUndertaking'];
    mannualOrBiometric = json['mannualOrBiometric'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['annexure'] = annexure;
    data['attendanceSheet'] = attendanceSheet;
    data['tPFeedbackForm'] = tPFeedbackForm;
    data['annexureM'] = annexureM;
    data['assesmentCheckList'] = assesmentCheckList;
    data['assessorFeedbackForm'] = assessorFeedbackForm;
    data['assessorUndertaking'] = assessorUndertaking;
    data['mannualOrBiometric'] = mannualOrBiometric;
    return data;
  }
}

class AssessorOtherDocuments {
  List<String>? otherDocumentsKey;
  List<String>? otherDocumentsValue;

  AssessorOtherDocuments({this.otherDocumentsKey, this.otherDocumentsValue});

  AssessorOtherDocuments.fromJson(Map<String, dynamic> json) {
    otherDocumentsKey = json['otherDocumentsKey'].cast<String>();
    otherDocumentsValue = json['otherDocumentsValue'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otherDocumentsKey'] = otherDocumentsKey;
    data['otherDocumentsValue'] = otherDocumentsValue;
    return data;
  }
}
