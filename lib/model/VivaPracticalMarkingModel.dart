class VivaPracticalMarkingListModel {
  List<VivaPracticalMarkingModel>? scheme;

  VivaPracticalMarkingListModel({this.scheme});

  VivaPracticalMarkingListModel.fromJson(Map<String, dynamic> json) {
    if (json['scheme'] != null) {
      scheme = <VivaPracticalMarkingModel>[];
      json['scheme'].forEach((v) {
        scheme!.add(VivaPracticalMarkingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (scheme != null) {
      data['scheme'] = scheme!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VivaPracticalMarkingModel {
  String? title;
  String? marks;

  VivaPracticalMarkingModel({this.title, this.marks});

  VivaPracticalMarkingModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    marks = json['marks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['marks'] = marks;
    return data;
  }
}
