import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mytat/common-components/tensor-flow-components/FaceDetectorPainter.dart';
import 'package:mytat/common-components/tensor-flow-components/camera_view.dart';
import 'package:mytat/common-components/tensor-flow-components/detector_view.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/utilities/AppConstants.dart';

class FaceDetectorView extends StatefulWidget {
  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  var _cameraLensDirection = CameraLensDirection.front;
  int numberOfFaces = 0;

  bool isPopupOpen = false;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);

    print("Total number of Faces found ==> ${faces.length}");

    // Update the number of faces detected
    numberOfFaces = faces.length;
    // If two faces are detected, show a popup
    if (numberOfFaces == 1 && isPopupOpen == true) {
      setState(() {
        isPopupOpen = false;
      });
      Get.back();
    }
    if (numberOfFaces == 0 && isPopupOpen == false) {
      capturePicture(
          "0",
          Get.find<CandidateOnboardingController>()
                  .assessmentDurationInformation!
                  .accessLocation ==
              "Y");
      showTwoFacesPopup();
    }
    if (numberOfFaces > 1 && isPopupOpen == false) {
      capturePicture(
          "2",
          Get.find<CandidateOnboardingController>()
                  .assessmentDurationInformation!
                  .accessLocation ==
              "Y");
      showTwoFacesPopup();
    }

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void showTwoFacesPopup() {
    setState(() {
      isPopupOpen = true;
    });
    Get.dialog(
        barrierDismissible: false,
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            child: SizedBox(
              height: Get.height * 0.15,
              width: Get.width * 0.4,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingDefault),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      numberOfFaces == 0
                          ? "No Face found or not visible properly."
                          : "More than One face Detected",
                      style: AppConstants.titleBold,
                    ),
                    SizedBox(
                      height: AppConstants.paddingDefault,
                    ),
                    // CustomElevatedButton(
                    //     height: 35,
                    //     width: 150,
                    //     onTap: () {
                    //       Get.back();
                    //       setState(() {
                    //         isPopupOpen = false;
                    //       });
                    //     },
                    //     text: "OK")
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
