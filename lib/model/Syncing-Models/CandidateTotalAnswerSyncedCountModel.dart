class CandidateTotalAnswerSyncedCountListModel {
  List<CandidateTotalAnswerSyncedCountModel>? userList;

  CandidateTotalAnswerSyncedCountListModel({this.userList});

  CandidateTotalAnswerSyncedCountListModel.fromJson(Map<String, dynamic> json) {
    if (json['user_list'] != null) {
      userList = <CandidateTotalAnswerSyncedCountModel>[];
      json['user_list'].forEach((v) {
        userList!.add(CandidateTotalAnswerSyncedCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userList != null) {
      data['user_list'] = userList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CandidateTotalAnswerSyncedCountModel {
  String? userId;
  String? cnt;

  CandidateTotalAnswerSyncedCountModel({this.userId, this.cnt});

  CandidateTotalAnswerSyncedCountModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    cnt = json['cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['cnt'] = cnt;
    return data;
  }
}
