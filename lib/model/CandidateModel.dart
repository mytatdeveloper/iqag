class CandidateModel {
  String? candidateId;
  String? latitude;
  String? longitude;
  String? assessorId;
  String? candidateAadharFront; // File path for Aadhar front image
  String? candidateAadharBack; // File path for Aadhar back image
  String? candidateProfile; // File path for profile image
  String type; // File path for profile image

  CandidateModel(
      {this.candidateId,
      this.candidateAadharFront,
      this.candidateAadharBack,
      this.candidateProfile,
      this.assessorId,
      this.latitude,
      this.longitude,
      required this.type});

  // Convert CandcandidateIdateModel object to a map for database operations
  Map<String, dynamic> toJson() {
    return {
      'candidateId': candidateId,
      'latitude': latitude,
      'longitude': longitude,
      'assessorId': assessorId,
      'candidateAadharFront': candidateAadharFront,
      'candidateAadharBack': candidateAadharBack,
      'candidateProfile': candidateProfile,
      'type': type,
    };
  }

  // Convert a map from the database to a CandcandidateIdateModel object
  factory CandidateModel.fromJson(Map<String, dynamic> map) {
    return CandidateModel(
        candidateId: map['candidateId'],
        candidateAadharFront: map['candidateAadharFront'],
        candidateAadharBack: map['candidateAadharBack'],
        candidateProfile: map['candidateProfile'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        assessorId: map['assessorId'],
        type: map['type']);
  }
}
