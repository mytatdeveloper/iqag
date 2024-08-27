class CandidateSubmitDocumentsModel {
  String? candidateId;
  String? candidateAadharFront; // File path for Aadhar front image
  String? candidateAadharBack; // File path for Aadhar back image
  String? candidateProfile; // File path for profile image
  String? latitude; // File path for profile image
  String? longitude; // File path for profile image
  String type;

  CandidateSubmitDocumentsModel(
      {this.candidateId,
      this.candidateAadharFront,
      this.candidateAadharBack,
      this.candidateProfile,
      this.latitude,
      this.longitude,
      required this.type});

  // Convert CandcandidateIdateModel object to a map for database operations
  Map<String, dynamic> toJson() {
    return {
      'candidateId': candidateId,
      'candidateAadharFront': candidateAadharFront,
      'candidateAadharBack': candidateAadharBack,
      'candidateProfile': candidateProfile,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
    };
  }

  // Convert a map from the database to a CandcandidateIdateModel object
  factory CandidateSubmitDocumentsModel.fromJson(Map<String, dynamic> map) {
    return CandidateSubmitDocumentsModel(
      candidateId: map['candidateId'],
      candidateAadharFront: map['candidateAadharFront'],
      candidateAadharBack: map['candidateAadharBack'],
      candidateProfile: map['candidateProfile'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      type: map['type'],
    );
  }
}
