class CandidateExamTimeModel {
  String? date;
  String? startTime;
  String? endTime;
  String? userId;
  String? switchCount;

  CandidateExamTimeModel(
      {this.date, this.startTime, this.endTime, this.userId, this.switchCount});

  CandidateExamTimeModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    userId = json['user_id'];
    switchCount = json['tab_switch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['user_id'] = userId;
    data['tab_switch'] = switchCount;

    return data;
  }
}
