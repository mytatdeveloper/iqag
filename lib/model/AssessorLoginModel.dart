class AssessorLoginModel {
  List<Assessor>? assessor;

  AssessorLoginModel({this.assessor});

  AssessorLoginModel.fromJson(Map<String, dynamic> json) {
    if (json['Assessor'] != null) {
      assessor = <Assessor>[];
      json['Assessor'].forEach((v) {
        assessor!.add(Assessor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assessor != null) {
      data['Assessor'] = assessor!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Assessor {
  String? assessorId;
  String? compId;
  String? name;
  String? userEmail;
  String? password;
  String? msg;

  Assessor(
      {this.assessorId,
      this.compId,
      this.name,
      this.userEmail,
      this.password,
      this.msg});

  Assessor.fromJson(Map<String, dynamic> json) {
    assessorId = json['assessorId'];
    compId = json['compId'];
    name = json['name'];
    userEmail = json['userEmail'];
    password = json['password'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assessorId'] = assessorId;
    data['compId'] = compId;
    data['name'] = name;
    data['userEmail'] = userEmail;
    data['password'] = password;
    data['msg'] = msg;
    return data;
  }
}
