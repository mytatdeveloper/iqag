class StudentsBatchModel {
  List<Batches>? batch;

  StudentsBatchModel({this.batch});

  StudentsBatchModel.fromJson(Map<String, dynamic> json) {
    if (json['Batch'] != null) {
      batch = <Batches>[];
      json['Batch'].forEach((v) {
        batch!.add(Batches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (batch != null) {
      data['Batch'] = batch!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Batches {
  String? id;
  String? assmentId;
  String? name;
  String? userEmail;
  String? enrollmentNo;
  String? password;
  String? institutionID;
  String? isPracticalDone;
  String? isVivaDone;
  String? isTheoryDone;
  String? pImg;
  String? vImg;

  Batches(
      {this.id,
      this.assmentId,
      this.name,
      this.userEmail,
      this.enrollmentNo,
      this.password,
      this.institutionID,
      this.isPracticalDone,
      this.isTheoryDone,
      this.isVivaDone,
      this.pImg,
      this.vImg});

  Batches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assmentId = json['assmentId'];
    name = json['name'];
    userEmail = json['userEmail'];
    enrollmentNo = json['enrollmentNo'];
    password = json['password'];
    institutionID = json['institutionID'];
    isPracticalDone = json['P'];
    isVivaDone = json['V'];
    isTheoryDone = json['T'];
    pImg = json['P_img'];
    vImg = json['V_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['assmentId'] = assmentId;
    data['name'] = name;
    data['userEmail'] = userEmail;
    data['enrollmentNo'] = enrollmentNo;
    data['password'] = password;
    data['institutionID'] = institutionID;
    data['T'] = isTheoryDone;
    data['P'] = isPracticalDone;
    data['V'] = isVivaDone;
    data['P_img'] = pImg;
    data['V_img'] = vImg;

    return data;
  }
}
