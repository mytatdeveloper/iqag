class VivaSyncingVerificationModel {
  String? candidateIds;
  String? isDocumentsSynced;
  String? isPracticalSynced;
  String? isVivaSynced;

  VivaSyncingVerificationModel(
      {this.candidateIds,
      this.isDocumentsSynced,
      this.isPracticalSynced,
      this.isVivaSynced});

  VivaSyncingVerificationModel.fromJson(Map<String, dynamic> json) {
    candidateIds = json['candidateIds'];
    isDocumentsSynced = json['isDocumentsSynced'];
    isPracticalSynced = json['isPracticalSynced'];
    isVivaSynced = json['isVivaSynced'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['candidateIds'] = candidateIds;
    data['isDocumentsSynced'] = isDocumentsSynced;
    data['isPracticalSynced'] = isPracticalSynced;
    data['isVivaSynced'] = isVivaSynced;
    return data;
  }
}
