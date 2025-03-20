
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../core/errors/failures.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
part 'remote_data_source.g.dart'; // Will be generated


@RestApi(baseUrl: "https://api.amkn.com.sa/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST('userAuth/login')
  Future<HttpResponse<LoginResponse?>> login(@Body() LoginRequest loginRequest);
}


abstract class AuthRemoteDataSource {
  Future<LoginResponse?> login(LoginRequest loginRequest);
}


class AuthRemoteDataSourceImpl implements AuthRemoteDataSource  {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoginResponse?> login(LoginRequest loginRequest) async {
    try {
      final response = await _apiClient.login(loginRequest);
      if (response.response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerFailure("Login failed: ${response.response.statusCode}");
      }
    } on DioException catch (e) {
      throw ServerFailure("Network error: ${e.message}");
    }
  }
  }
