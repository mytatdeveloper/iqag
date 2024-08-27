class OnlineAssessorSyncedDocumentsListModel {
  AlreadySyncedAnnexure? annexure;

  OnlineAssessorSyncedDocumentsListModel({this.annexure});

  OnlineAssessorSyncedDocumentsListModel.fromJson(Map<String, dynamic> json) {
    annexure = json['annexure'] != null
        ? AlreadySyncedAnnexure.fromJson(json['annexure'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (annexure != null) {
      data['annexure'] = annexure!.toJson();
    }
    return data;
  }
}

class AlreadySyncedAnnexure {
  int? row;
  String? msg;
  List<OnlineAnnexureDetailsModel>? result;

  AlreadySyncedAnnexure({this.row, this.msg, this.result});

  AlreadySyncedAnnexure.fromJson(Map<String, dynamic> json) {
    row = json['row'];
    msg = json['msg'];
    if (json['result'] != null) {
      result = <OnlineAnnexureDetailsModel>[];
      json['result'].forEach((v) {
        result!.add(OnlineAnnexureDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['row'] = row;
    data['msg'] = msg;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OnlineAnnexureDetailsModel {
  String? id;
  String? assmentId;
  String? caption;
  String? captionVal;
  String? assessorId;
  String? studentId;
  String? address;
  String? latitude;
  String? longitude;
  String? type;
  String? mode;

  OnlineAnnexureDetailsModel(
      {this.id,
      this.assmentId,
      this.caption,
      this.captionVal,
      this.assessorId,
      this.studentId,
      this.address,
      this.latitude,
      this.longitude,
      this.type,
      this.mode});

  OnlineAnnexureDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assmentId = json['assmentId'];
    caption = json['caption'];
    captionVal = json['captionVal'];
    assessorId = json['assessorId'];
    studentId = json['studentId'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    type = json['type'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['assmentId'] = assmentId;
    data['caption'] = caption;
    data['captionVal'] = captionVal;
    data['assessorId'] = assessorId;
    data['studentId'] = studentId;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['type'] = type;
    data['mode'] = mode;
    return data;
  }
}
