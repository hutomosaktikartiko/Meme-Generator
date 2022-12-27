import 'package:dio/dio.dart';

import '../../../../core/directories/directory_info.dart';
import '../../../../core/error/exception.dart';

abstract class DownloadFileRemoteDataSource {
  Future<bool> downloadFile({
    required String fileUrl,
    required String directoryPath,
  });
}

class DownloadFileRemoteDataSourceImpl implements DownloadFileRemoteDataSource {
  final Dio dio;
  final DirectoryInfo directoryInfo;

  const DownloadFileRemoteDataSourceImpl({
    required this.dio,
    required this.directoryInfo,
  });

  @override
  Future<bool> downloadFile({
    required String fileUrl,
    required String directoryPath,
  }) async {
    try {
      await dio.download(fileUrl, directoryPath);

      return true;
    } on DirectoryException {
      throw DirectoryException();
    } catch (_) {
      throw ServerException();
    }
  }
}
