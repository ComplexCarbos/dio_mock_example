import 'package:dio/dio.dart';

class PostService {
  final _httpClient;

  const PostService({required Dio httpClient}) : _httpClient = httpClient;

  Future<void> postSomething(
      {required String url, required FormData formData}) async {
    try {
      final response = await _httpClient.post(url, data: formData);
      if (response.statusCode != 200) {
        print('Request failed ${response.statusCode}');
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.type);

      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw Exception('TIMEOUT');
      } else {
        print('Doing something cool with unexepcted error');
      }
    }
  }
}
