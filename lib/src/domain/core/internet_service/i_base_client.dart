import 'package:http/http.dart';

abstract class IBaseClient {
  Future<Response> get({required String url, Map<String, String>? header});
  Future<Response> post({
    required String url,
    required Object body, // Map<String, dynamic> body,
    Map<String, String>? headers,
  });
  Future<Response> put({
    required String url,
    required Object body, // Map<String, dynamic> body,
    Map<String, String>? headers,
  });
  Future<Response> delete({
    required String url,
    Map<String, String>? headers,
  });
}
