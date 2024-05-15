import 'package:dio/dio.dart';

abstract interface class RequestRepository {
  Future<String> post(
      String path, {
        Object? data,
        Map<String, Object?>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      });

  Future<String> get(
      String path, {
        Object? data,
        Map<String, Object?>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      });

  Future<String> delete(
      String path, {
        Object? data,
        Map<String, Object?>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      });

  Future<String> put(
      String path, {
        Object? data,
        Map<String, Object?>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      });

  Future<String> patch(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      });

  Future<Object?> download(
      String urlPath,
      Object? savePath, {
        ProgressCallback? onReceiveProgress,
        Map<String, Object?>? queryParameters,
        CancelToken? cancelToken,
        bool deleteOnError = true,
        String lengthHeader = Headers.contentLengthHeader,
        Object? data,
        Options? options,
      });
}