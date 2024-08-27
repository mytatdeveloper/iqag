class AssessorDocumentsModel {
  List<Annexurelist>? annexurelist;

  AssessorDocumentsModel({this.annexurelist});

  AssessorDocumentsModel.fromJson(Map<String, dynamic> json) {
    if (json['annexurelist'] != null) {
      annexurelist = <Annexurelist>[];
      json['annexurelist'].forEach((v) {
        annexurelist!.add(Annexurelist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (annexurelist != null) {
      data['annexurelist'] = annexurelist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Annexurelist {
  String? id;
  String? name;
  String? image;

  Annexurelist({this.id, this.name, this.image});

  Annexurelist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
