import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'ApiEndpoints.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio();

  Future<dynamic> get(String path, {Map<String, dynamic>? headers}) async {
    print("URL ==> ${ApiEndpoints.baseUrl}$path");

    try {
      final Response response = await _dio.get(
        '${ApiEndpoints.baseUrl}$path',
        options: Options(headers: headers),
      );
      return _decodeResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String path,
      {Map<String, dynamic>? headers, dynamic data}) async {
    print("URL: ${ApiEndpoints.baseUrl}$path");
    print("URL: $data");

    try {
      final Response response = await _dio.post(
        '${ApiEndpoints.baseUrl}$path',
        data: data,
        options: Options(headers: headers),
      );

      return _decodeResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Implement the put and delete methods similarly

  dynamic _decodeResponse(Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.toString());
    } else {
      return response.toString();
    }
  }

  // Helper method to handle DioException and return appropriate error message
  Exception _handleError(DioException e) {
    String? message = e.message;
    if (e.response != null &&
        e.response!.data != null &&
        e.response!.data['message'] != null) {
      message = e.response!.data['message'];
    }
    return Exception(message);
  }

  Future<void> uploadImageToServer(String? imageFilePath) async {
    if (imageFilePath != null) {
      var request = http.MultipartRequest('POST',
          Uri.parse('${ApiEndpoints.baseUrl}/sscfiles/apk_img_upload.php'));
      request.files.add(
          await http.MultipartFile.fromPath('uploadedFile', imageFilePath));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }
  }

  Future<dynamic> uploadVideoToServer(String? videoPath) async {
    // print(
    //     "File path Received Here: ${videoPath!.replaceFirst(AppConstants.replacementPath, "")}");

    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiEndpoints.baseUrl}/sscfiles/apk_upload.php'));
    request.files
        .add(await http.MultipartFile.fromPath('uploadedFile', videoPath!));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> uploadScreenshotToServer(
      String? imageFilePath, String assessmentId, String candidateId) async {
    if (imageFilePath != null) {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${ApiEndpoints.baseUrl}/sscfiles/apk_screenshot_upload.php'));

      // Add the assessmentId and candidateId to the request body as fields
      request.fields['assessmentId'] = assessmentId;
      request.fields['candidateId'] = candidateId;

      request.files.add(await http.MultipartFile.fromPath(
        'uploadedFile',
        imageFilePath,
      ));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }
  }

  postFormData(String path,
      {Map<String, dynamic>? headers,
      String? assesmentId,
      String? questionId,
      String? videoUrl,
      String? assessorId,
      String? studentId,
      String? assesorMarks,
      String? assesorFeedback}) async {
    try {
      var data = FormData.fromMap({
        'assesmentId': assesmentId,
        'questionId': questionId,
        'videoUrl': videoUrl,
        'assessorId': assessorId,
        'studentId': studentId,
        'assesorMarks': assesorMarks,
        'assesorFeedback': assesorFeedback
      });

      var response = await _dio.request(
        "${ApiEndpoints.baseUrl}$path",
        options: Options(
          method: 'POST',
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print("$questionId is Synced for $studentId");
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      print("Exceptions Occured: $e");
    }
  }

  Future<dynamic> postFormRequest(
      String path, Map<String, dynamic> body) async {
    print("Body Data: $body");
    try {
      var data = FormData.fromMap(body);
      var response = await _dio.request(
        "${ApiEndpoints.baseUrl}$path",
        options: Options(
          method: 'POST',
        ),
        data: data,
      );
      return _decodeResponse(response);
    } on DioException catch (e) {
      print(
          "Exception Occurred while put the request using post form request ${e}");
      return false;
      // throw _handleError(e);
    }
  }
}
