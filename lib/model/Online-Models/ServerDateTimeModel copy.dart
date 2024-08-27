class ServerDateTimeModel {
  String? date;
  String? time;

  ServerDateTimeModel({this.date, this.time});

  ServerDateTimeModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
