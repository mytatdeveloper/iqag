class CandidateScreenshotUploadModel {
  String? assmentId;
  String? userId;
  String? userimg;
  String? faceCount;
  int? serialnumber;
  String? dateTime;

  CandidateScreenshotUploadModel(
      {this.assmentId,
      this.userId,
      this.userimg,
      this.faceCount,
      this.serialnumber,
      required this.dateTime});

  CandidateScreenshotUploadModel.fromJson(Map<String, dynamic> json) {
    assmentId = json['assmentId'];
    userId = json['userId'];
    userimg = json['userimg'];
    faceCount = json['faceCount'];
    serialnumber = json['serialnumber'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assmentId'] = assmentId;
    data['userId'] = userId;
    data['userimg'] = userimg;
    data['faceCount'] = faceCount;
    data['serialnumber'] = serialnumber;
    data['dateTime'] = dateTime;

    return data;
  }
}
