class AllCandidateDataSyncListModel {
  AllCandidateDataSyncModel? data;

  AllCandidateDataSyncListModel({this.data});

  AllCandidateDataSyncListModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? AllCandidateDataSyncModel.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AllCandidateDataSyncModel {
  String? result;
  List<CandidateDetailsWithStatus>? users;

  AllCandidateDataSyncModel({this.result, this.users});

  AllCandidateDataSyncModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['users'] != null) {
      users = <CandidateDetailsWithStatus>[];
      json['users'].forEach((v) {
        users!.add(CandidateDetailsWithStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CandidateDetailsWithStatus {
  String? userFullName;
  String? mytatAutoNumber;
  String? userId;
  String? resultId;

  CandidateDetailsWithStatus(
      {this.userFullName, this.mytatAutoNumber, this.userId, this.resultId});

  CandidateDetailsWithStatus.fromJson(Map<String, dynamic> json) {
    userFullName = json['user_full_name'];
    mytatAutoNumber = json['mytat_auto_number'];
    userId = json['user_id'];
    resultId = json['result_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_full_name'] = userFullName;
    data['mytat_auto_number'] = mytatAutoNumber;
    data['user_id'] = userId;
    data['result_id'] = resultId;
    return data;
  }
}
