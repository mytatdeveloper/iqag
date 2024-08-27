class OnlineLoginCandidateModel {
  int? row;
  Result? result;

  OnlineLoginCandidateModel({this.row, this.result});

  OnlineLoginCandidateModel.fromJson(Map<String, dynamic> json) {
    row = json['row'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['row'] = row;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? id;
  String? assmentId;
  String? name;
  String? userEmail;
  String? enrollmentNo;
  String? password;
  String? institutionID;
  String? assessorId;

  Result(
      {this.id,
      this.assmentId,
      this.name,
      this.userEmail,
      this.enrollmentNo,
      this.password,
      this.institutionID,
      this.assessorId});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assmentId = json['assmentId'];
    name = json['name'];
    userEmail = json['userEmail'];
    enrollmentNo = json['enrollmentNo'];
    password = json['password'];
    institutionID = json['institutionID'];
    assessorId = json['assessorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['assmentId'] = assmentId;
    data['name'] = name;
    data['userEmail'] = userEmail;
    data['enrollmentNo'] = enrollmentNo;
    data['password'] = password;
    data['institutionID'] = institutionID;
    data['assessorId'] = assessorId;
    return data;
  }
}
