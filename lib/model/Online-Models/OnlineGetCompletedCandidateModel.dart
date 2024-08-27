class OnlineSyncedCandidateDataModel {
  int? row;
  List<CandidateDetails>? result;

  OnlineSyncedCandidateDataModel({this.row, this.result});

  OnlineSyncedCandidateDataModel.fromJson(Map<String, dynamic> json) {
    row = json['row'];
    if (json['result'] != null) {
      result = <CandidateDetails>[];
      json['result'].forEach((v) {
        result!.add(CandidateDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['row'] = row;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CandidateDetails {
  String? isVideo;
  String? isMCQ;
  String? id;
  String? assmentId;
  String? name;
  String? userEmail;
  String? enrollmentNumber;

  CandidateDetails(
      {this.isVideo,
      this.isMCQ,
      this.id,
      this.assmentId,
      this.name,
      this.userEmail,
      this.enrollmentNumber});

  CandidateDetails.fromJson(Map<String, dynamic> json) {
    isVideo = json['isVideo'];
    isMCQ = json['isMCQ'];
    id = json['id'];
    assmentId = json['assmentId'];
    name = json['name'];
    userEmail = json['userEmail'];
    enrollmentNumber = json['enroll'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isVideo'] = isVideo;
    data['isMCQ'] = isMCQ;
    data['id'] = id;
    data['assmentId'] = assmentId;
    data['name'] = name;
    data['userEmail'] = userEmail;
    data['enroll'] = enrollmentNumber;

    return data;
  }
}
