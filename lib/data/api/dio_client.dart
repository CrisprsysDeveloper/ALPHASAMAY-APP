import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:get_storage/get_storage.dart';
import '../../utils/utility.dart';
import 'logging.dart';

class DioClient extends GetxService {
  final Dio _dio = Dio(
    BaseOptions(
        baseUrl: AppConstants.baseUrl, headers: {'Accept': 'application/json'}),
  )..interceptors.add(Logging());

  void logError(DioException e) {
    if (e.response != null) {
      if (kDebugMode) {
        print('Dio error!');
        print('URL: ${e.response?.requestOptions.baseUrl}');
        print('HEADERS: ${e.response?.requestOptions.headers}');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data.message}');
      }
    } else {
      if (kDebugMode) {
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future<Response?> get(String url,
      {Map<String, dynamic>? queryParams, Map<String, dynamic>? params}) async {
    Response? response;
    try {
      Response data = await _dio.get(url,
          queryParameters: queryParams ?? {},
          data: params ?? {},
          options: Options(headers: {
            "Authorization":
                "Bearer ${GetStorage().read(AppConstants.accessToken) ?? ''}",
          }));
      if (data.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      } else if (data.statusCode == 404) {
        Utility.showToastMessage(data.statusMessage);
      }
      response = data;
    } on DioException catch (e) {
      logError(e);
      if (e.response?.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = e.response;
    }
    return response;
  }

  Future<Response?> post(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? queryParams}) async {
    Response? response;
    try {
      Response data = await _dio.post(url,
          data: params ?? {},
          queryParameters: queryParams ?? {},
          options: Options(headers: {
            "Authorization":
                "Bearer ${GetStorage().read(AppConstants.accessToken) ?? ''}"
          }));
      if (data.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = data;
    } on DioException catch (e) {
      //final errorMessage = e.response?.data['message'];
      //Utility.showToastMessage(errorMessage ?? 'Unknown error occurred');
      if (e.response?.statusCode == 401)
      {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      } else if (e.response?.statusCode == 400) {
      } else if (e.response?.statusCode == 404) {}
      response = e.response;
    }
    return response;
  }


  Future<Response?> postMultipart1(String url,
      {dynamic params, Map<String, dynamic>? queryParams}) async {
    Response? response;

    try {
      Response data = await _dio.post(
        url,
        data: params ?? {},
        queryParameters: queryParams ?? {},
        options: Options(
          headers: {
            "Authorization":
            "Bearer ${GetStorage().read(AppConstants.accessToken) ?? ''}",
            // Do NOT set 'Content-Type' manually for multipart
          },
        ),
      );

      if (data.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }

      response = data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'];
      Utility.showToastMessage(errorMessage ?? 'Unknown error occurred');

      if (e.response?.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }

      response = e.response;
    }

    return response;
  }

  Future<Response?> postMultipart(
      String url, {
        dynamic params,
        Map<String, dynamic>? queryParams,
      }) async {
    Response? response;

    try {
      final accessToken = GetStorage().read(AppConstants.accessToken) ?? '';

      response = await _dio.post(
        url,
        data: params ?? {},
        queryParameters: queryParams ?? {},
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/json", // Optional but recommended
            // ❗️Don't manually set 'Content-Type' for FormData
          },
        ),
      );

      if (response.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      final errorMessage = errorData is Map ? errorData['message'] ?? 'Unknown error' : 'Unknown error';

      Utility.showToastMessage(errorMessage);

      if (e.response?.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }

      response = e.response;
    } catch (e) {
      Utility.showToastMessage('Unexpected error: $e');
    }

    return response;
  }



  Future<Response?> delete(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? queryParams}) async {
    Response? response;
    try {
      Response data = await _dio.delete(url,
          data: params ?? {},
          queryParameters: queryParams ?? {},
          options: Options(headers: {
            "Authorization":
                "Bearer ${GetStorage().read(AppConstants.accessToken) ?? ''}"
          }));
      if (data.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = e.response;
    }
    return response;
  }

  Future<dynamic> put(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? queryParams}) async {
    Response? response;
    try {
      Response data = await _dio.put(url,
          data: params ?? {},
          queryParameters: queryParams ?? {},
          options: Options(headers: {
            "Authorization":
                "Bearer ${GetStorage().read(AppConstants.accessToken) ?? ''}"
          }));
      if (data.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'];
      Utility.showToastMessage(errorMessage ?? 'Unknown error occurred');
      if (e.response?.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      } else if (e.response?.statusCode == 400) {
      } else if (e.response?.statusCode == 404) {}
      response = e.response;
    }
    return response;
  }

  Future<dynamic> putMultiPart(String url,
      {Map<String, dynamic>? params}) async {
    dynamic response;
    try {
      FormData formData = FormData.fromMap(params ?? {});
      Response data = await _dio.put(url,
          data: formData,
          options: Options(headers: {
            "Authorization":
                "Bearer ${GetStorage().read(AppConstants.accessToken) ?? ''}"
          }));
      if (data.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = data.data;
    } on DioException catch (e) {
      logError(e);
      if (e.response?.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = e.response?.data;
    }
    return response;
  }

  Future<dynamic> putMultiPartE(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? queryParams}) async {
    Response? response;
    try {
      FormData formData = FormData.fromMap(params ?? {});
      Response data = await _dio.put(url,
          data: formData,
          queryParameters: queryParams,
          options: Options(headers: {
            "Authorization":
                "Bearer ${GetStorage().read(AppConstants.accessToken) ?? ''}"
          }));
      if (data.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = data;
    } on DioException catch (e) {
      logError(e);
      if (e.response?.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = e.response;
    }
    return response;
  }

  Future<Response?> postMultiPart(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? queryParams}) async {
    Response? response;
    try {
      FormData formData = FormData.fromMap(params ?? {});
      Response data = await _dio.post(url,
          data: formData,
          queryParameters: queryParams,
          options: Options(headers: {
            "Authorization":
                "Bearer ${GetStorage().read(AppConstants.accessToken) ?? ''}"
          }));
      if (data.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = data;
    } on DioException catch (e) {
      logError(e);
      if (e.response?.statusCode == 401) {
        await GetStorage().erase();
        Get.offAllNamed(Routes.loginScreen);
      }
      response = e.response;
    }
    return response;
  }
}
