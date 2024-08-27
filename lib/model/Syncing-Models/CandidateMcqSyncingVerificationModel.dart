class McqSyncingVerificationModel {
  String? candidateIds;
  String? isDocumentsSynced;
  String? isScreenshotsSynced;
  String? isAnswersSynced;

  McqSyncingVerificationModel(
      {this.candidateIds,
      this.isDocumentsSynced,
      this.isScreenshotsSynced,
      this.isAnswersSynced});

  McqSyncingVerificationModel.fromJson(Map<String, dynamic> json) {
    candidateIds = json['candidateIds'];
    isDocumentsSynced = json['isDocumentsSynced'];
    isScreenshotsSynced = json['isScreenshotsSynced'];
    isAnswersSynced = json['isAnswersSynced'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['candidateIds'] = candidateIds;
    data['isDocumentsSynced'] = isDocumentsSynced;
    data['isScreenshotsSynced'] = isScreenshotsSynced;
    data['isAnswersSynced'] = isAnswersSynced;
    return data;
  }
}
