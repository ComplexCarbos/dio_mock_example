import 'package:dio/dio.dart';
import 'package:dio_test/post_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  const path = 'https://example.com';
  late Dio dio;
  late DioAdapter dioAdapter;
  late FormData formData;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter();
    dio.httpClientAdapter = dioAdapter;

    final multipartFile = MultipartFile.fromBytes(
      [123, 456],
      filename: 'file-name',
    );

    formData = FormData.fromMap({'file': multipartFile});
  });
  group('PostServiceTest - ', () {
    test('postSomething', () {
      final errorToThrow = DioError(
          requestOptions: RequestOptions(path: path),
          type: DioErrorType.receiveTimeout,
          response: Response(
            statusCode: 408,
            requestOptions: RequestOptions(path: path),
          ),
          error: {'message': 'Timeout'});

      print('Form Length: ${formData.length}');
      print('Form Boundary: ${formData.boundary}');

      dioAdapter.onPost(path, (request) => request.throws(408, errorToThrow),
          data: formData);

      final postService = PostService(httpClient: dio);

      expect(
        () async =>
            await postService.postSomething(url: path, formData: formData),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().startsWith('TIMEOUT'),
          ),
        ),
      );
    });
  });
}
