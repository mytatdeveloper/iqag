class TotalDataSyncedListModel {
  List<UserSyncedDataModel>? userList;

  TotalDataSyncedListModel({this.userList});

  TotalDataSyncedListModel.fromJson(Map<String, dynamic> json) {
    if (json['user_list'] != null) {
      userList = <UserSyncedDataModel>[];
      json['user_list'].forEach((v) {
        userList!.add(UserSyncedDataModel.fromJson(v));
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

class UserSyncedDataModel {
  String? userId;
  String? cnt;

  UserSyncedDataModel({this.userId, this.cnt});

  UserSyncedDataModel.fromJson(Map<String, dynamic> json) {
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
