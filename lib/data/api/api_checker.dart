import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:six_pos/common/models/error_response.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/features/auth/screens/log_in_screen.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      Get.find<SplashController>().removeSharedData();
      Get.to(() => const LogInScreen());
    } else {
      String errorMessage = '';
      if (response.body != null && response.body is Map<String, dynamic>) {
        if (response.body.containsKey('message')) {
          errorMessage = response.body['message'];
        } else {
          try {
            var errorResponse = ErrorResponse.fromJson(response.body);
            errorMessage =
                errorResponse.errors?.first.message ??
                'Se produjo una excepción';
          } catch (e) {
            errorMessage = 'Se produjo una excepción';
          }
        }
      } else {
        errorMessage = response.statusText ?? 'Error desconocido';
      }

      showCustomSnackBarHelper(errorMessage, isError: true);
    }
  }

  static Future<Response> getResponse(http.StreamedResponse response) async {
    var r = await http.Response.fromStream(response);
    String error = '';
    try {
      var body = jsonDecode(r.body);
      if (body is Map<String, dynamic>) {
        if (body.containsKey('errors') &&
            body['errors'] is List &&
            body['errors'].isNotEmpty) {
          error = body['errors'][0]['message'] ?? 'Error occurred';
        } else if (body.containsKey('message')) {
          error = body['message'] ?? 'Error occurred';
        } else {
          error = 'failed'.tr;
        }
      } else {
        error = 'failed'.tr;
      }
    } catch (e) {
      try {
        var body = jsonDecode(r.body);
        error = body['message'] ?? 'failed'.tr;
      } catch (e2) {
        error = 'failed'.tr;
      }
    }
    return Response(statusText: error, statusCode: response.statusCode);
  }
}
