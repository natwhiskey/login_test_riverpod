
import 'dart:convert';

import 'package:dio/dio.dart';

class AuthService {
  final Dio dio = Dio();
  String? _authToken;
  String? result;

  Future<bool> login(String username, String password) async {
    try {
      final body = json.encode({
        'username': username,
        'password': password,
      });

      final response = await dio.post(
        'https://zrquf74pl0.execute-api.ap-southeast-1.amazonaws.com/default/flutter-test/login',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.data);
        _authToken = responseData['token'];
        print("Auth Token: $_authToken");
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('Login failed: $e');
      return false;
    }
  }

  Future<String?> fetchData() async {
    if (_authToken == null) {
      print('No auth token found, please login first.');
      return null;
    }

    try {
      final response = await dio.get(
        'https://zrquf74pl0.execute-api.ap-southeast-1.amazonaws.com/default/flutter-test/data',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$_authToken',
          },
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == 200) {
        result = response.data;
        print('Get data successful');
        _authToken = null;
        return result;
      } else {
        print('Failed with status code: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Failed with DioError: ${e.response!.statusCode} - ${e.response!.statusMessage}');
        print('Response data: ${e.response!.data}');
      } else {
        print('Get data Failed: $e');
      }
      return null;
    }
  }
}

