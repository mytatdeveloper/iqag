class AssessmentAllLanguagesListModel {
  int? result;
  List<AssessmentAvailableLanguageModel>? languages;

  AssessmentAllLanguagesListModel({this.result, this.languages});

  AssessmentAllLanguagesListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['languages'] != null) {
      languages = <AssessmentAvailableLanguageModel>[];
      json['languages'].forEach((v) {
        languages!.add(AssessmentAvailableLanguageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssessmentAvailableLanguageModel {
  String? id;
  String? name;

  AssessmentAvailableLanguageModel({this.id, this.name});

  AssessmentAvailableLanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
