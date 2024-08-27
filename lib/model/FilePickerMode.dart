class FilePickerModel {
  // String fileExtension;
  String fileName;
  // bool isMandatory;
  bool allFilledUp;
  // bool isOpenCamera;
  String? aadharFront;
  String? aadharBack;
  String? profilePhoto;

  FilePickerModel({
    required this.aadharBack,
    required this.aadharFront,
    required this.profilePhoto,
    this.allFilledUp = false,

    //   required this.fileExtension,
    required this.fileName,
    // required this.isMandatory,
    // required this.fileUrl,
    // required this.isOpenCamera
  });
}
