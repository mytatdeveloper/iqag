class AssessorAnnexurelistUploadModel {
  String? id;
  String? name;
  String? image;
  String? lat;
  String? long;
  late String time;

  AssessorAnnexurelistUploadModel(
      {this.id,
      this.name,
      this.image,
      this.lat,
      this.long,
      required this.time});

  AssessorAnnexurelistUploadModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    lat = json['lat'];
    long = json['long'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['lat'] = lat;
    data['long'] = long;
    data['time'] = time;

    return data;
  }
}
