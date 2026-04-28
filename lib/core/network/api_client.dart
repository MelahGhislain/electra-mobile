import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<Response> get(String path) async {
    return await dio.get(path);
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    return await dio.post(path, data: data, options: options);
  }

  Future<Response> patch(String path, {dynamic data, Options? options}) async {
    return await dio.patch(path, data: data, options: options);
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    return await dio.delete(path, data: data, options: options);
  }
}
