class LanguageModel {
  List<Languages>? languages;

  LanguageModel({this.languages});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Languages {
  String? id;
  String? langName;
  String? langcode;

  Languages({this.id, this.langName, this.langcode});

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    langName = json['langName'];
    langcode = json['langcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['langName'] = langName;
    data['langcode'] = langcode;
    return data;
  }
}
