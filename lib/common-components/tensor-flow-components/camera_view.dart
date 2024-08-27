import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/Online-Models/ServerDateTimeModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateScreenshotUploadModel.dart';
import 'package:image/image.dart' as img;
import 'package:mytat/utilities/AppConstants.dart';

CameraController? tensorFlowController;
Timer? _captureTimer;
String? filePath;

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.back})
      : super(key: key);

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  static List<CameraDescription> _cameras = [];
  int _cameraIndex = -1;

  int frameCounter = 0;

  void addObservor() {
    WidgetsBinding.instance.addObserver(this);
  }

  void removeObservor() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (tensorFlowController?.value.isInitialized == false) {
        print("App Resumed and Controller not Initialized");
      } else {
        _startLiveFeed();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
    addObservor();
  }

  @override
  void dispose() {
    super.dispose();
    removeObservor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<CandidateOnboardingController>(
      builder: (candidateOnboardingController) {
        return _liveFeedBody();
      },
    ));
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (tensorFlowController == null) return Container();
    if (tensorFlowController?.value.isInitialized == false) return Container();
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: CameraPreview(
              tensorFlowController!,
              child: widget.customPaint,
            ),
          ),
        ],
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    tensorFlowController = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    tensorFlowController?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      if (Get.find<CandidateOnboardingController>().tensorFlow == "Y") {
        tensorFlowController
            ?.startImageStream(_processCameraImage)
            .then((value) {
          if (widget.onCameraFeedReady != null) {
            widget.onCameraFeedReady!();
          }
          if (widget.onCameraLensDirectionChanged != null) {
            widget.onCameraLensDirectionChanged!(camera.lensDirection);
          }
        });
      }

      setState(() {});
    });
  }

  void _processCameraImage(CameraImage image) {
    frameCounter++;
    if (frameCounter % 25 != 0) return; // Skip frames
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    // bool allowTracking =
    //     Get.find<CandidateOnboardingController>().getDiableTensorFlowStatus();
    // setState(() {});

    widget.onImage(inputImage);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (tensorFlowController == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${tensorFlowController?.value.deviceOrientation} ${tensorFlowController?.value.lockedCaptureOrientation} ${tensorFlowController?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[tensorFlowController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}

// timer code
void startCaptureTimer() {
  print("--------------- Starting Clicking Pictures ---------------");
  _captureTimer = Timer.periodic(
      Duration(
          minutes: int.parse(
              Get.find<CandidateOnboardingController>().imageInterval)),
      (timer) {
    if (tensorFlowController?.value.isInitialized == true) {
      capturePicture(
          null,
          Get.find<CandidateOnboardingController>()
                  .assessmentDurationInformation!
                  .accessLocation ==
              "Y");
    }
  });
}

void stopCaptureTimer() {
  print("--------------- Stoping Clicking Pictures ---------------");

  _captureTimer?.cancel();
}

void capturePicture(String? count, bool allowWatermark) async {
  try {
    print("CAPTURING PICTURE <=========== ============> ");
    await tensorFlowController!.setFocusMode(FocusMode.locked);
    await tensorFlowController!.setExposureMode(ExposureMode.locked);

    XFile file = await tensorFlowController!.takePicture();

    await tensorFlowController!.setFocusMode(FocusMode.auto);
    await tensorFlowController!.setExposureMode(ExposureMode.auto);
    // XFile file = await tensorFlowController!.takePicture();
    await Get.find<SplashController>().getLocation();
    // if (allowWatermark == true) {
    await addWatermarkToImage(file.path, isAllWatermarkNeeded: allowWatermark);
    // }

    // Do something with the captured picture file (e.g., display or process it)
    CandidateScreenshotUploadModel newImage = CandidateScreenshotUploadModel(
        assmentId: Get.find<CandidateOnboardingController>().assessmentId != ""
            ? Get.find<CandidateOnboardingController>().assessmentId
            : AppConstants.assesmentId ?? "",
        userId: Get.find<CandidateOnboardingController>().presentCandidate!.id,
        faceCount: count ?? "1",
        userimg: filePath ?? file.path,
        // date time of server
        dateTime: AppConstants.photoWatermarkText3
        // date time of server

        );
    Get.find<CandidateOnboardingController>()
        .addToScreenShotImageList(newImage);
    print("Picture captured: ${file.path}");
  } catch (e) {
    print("Error capturing picture: $e");
  }
}

Future stopLiveFeed() async {
  try {
    print(
        "----------------------- Stopping Live Feed of the Camera -----------------");
    if (Get.find<CandidateOnboardingController>().tensorFlow == "Y") {
      await tensorFlowController?.stopImageStream();
    }
    await closeTensorFlowCamera();
  } catch (e) {
    print("Exception Occured While Disposing the Camera Controller ${e}");
  }
}

closeTensorFlowCamera() async {
  print("CLOSING CAMERA");
  if (tensorFlowController != null) {
    await tensorFlowController?.dispose();
    tensorFlowController = null;
  }
}

Future<void> addWatermarkToImage(String imagePath,
    {bool isAllWatermarkNeeded = true}) async {
  if (AppConstants.isOnlineMode != true) {
    AppConstants.photoWatermarkText3 =
        Get.find<SplashController>().getCurrentDateTime();
  } else {
    ServerDateTimeModel? serverDateTimeModel =
        await AppConstants.getServerDateAndTime();
    if (serverDateTimeModel != null) {
      AppConstants.photoWatermarkText3 =
          "${serverDateTimeModel.date}, ${serverDateTimeModel.time}";
    }
  }

  final image = img.decodeImage(File(imagePath).readAsBytesSync());

  // Create a copy of the image to draw on
  final imageCopy =
      img.copyResize(image!, width: image.width, height: image.height);

  // Add text as watermark
  final font = img.arial_14; // Choose a font and size
  final color =
      img.getColor(255, 255, 255); // Choose text color (white in this case)
  final shadowColor =
      img.getColor(0, 0, 0, 100); // Choose shadow color (black with opacity)
  final text = AppConstants.photoWatermarkText; // Text to be added as watermark
  final text2 =
      AppConstants.photoWatermarkText2; // Text to be added as watermark
  final text3 =
      AppConstants.photoWatermarkText3; // Text to be added as watermark

  // Calculate watermark text position (you can adjust this based on your needs)
  const textX = 5; // Adjust the X position of the text
  final textY = imageCopy.height - 40; // Adjust the Y position of the text
  const textX2 = 5; // Adjust the X position of the text
  final textY2 = imageCopy.height - 20; // Adjust the Y position of the text
  const textX3 = 5; // Adjust the X position of the text
  final textY3 = isAllWatermarkNeeded == true
      ? imageCopy.height - 60
      : imageCopy.height - 20; // Adjust the Y position of the text

  // Draw the shadow text multiple times to create a bolder effect
  for (int i = 1; i <= 3; i++) {
    if (isAllWatermarkNeeded == true) {
      img.drawString(imageCopy, font, textX + i, textY + i, text,
          color: shadowColor);
      img.drawString(imageCopy, font, textX2 + i, textY2 + i, text2,
          color: shadowColor);
    }

    img.drawString(imageCopy, font, textX3 + i, textY3 + i, text3,
        color: shadowColor);
  }

  // Draw the actual text
  if (isAllWatermarkNeeded == true) {
    img.drawString(imageCopy, font, textX, textY, text, color: color);
    img.drawString(imageCopy, font, textX2, textY2, text2, color: color);
  }
  img.drawString(imageCopy, font, textX3, textY3, text3, color: color);

  // Save the new image with text watermark
  filePath = imagePath;

  File(filePath!).writeAsBytesSync(img.encodePng(imageCopy));
}
