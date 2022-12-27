import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/save_file_repository.dart';
import '../datasources/download_file_remote_data_source.dart';
import '../datasources/save_file_local_data_source.dart';

class SaveFileRepositoryImpl implements SaveFileRepository {
  final SaveFileLocalDataSource saveFileLocalDataSource;
  final DownloadFileRemoteDataSource downloadFileRemoteDataSource;
  final NetworkInfo networkInfo;

  const SaveFileRepositoryImpl({
    required this.saveFileLocalDataSource,
    required this.downloadFileRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> downloadFile({
    required String fileUrl,
    required String directoryPath,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final bool result = await downloadFileRemoteDataSource.downloadFile(
          fileUrl: fileUrl,
          directoryPath: directoryPath,
        );

        return Right(result);
      } on DirectoryException {
        return Left(DirectoryFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveToGallery({
    required String filePath,
  }) async {
    try {
      final bool result =
          await saveFileLocalDataSource.saveToGallery(filePath: filePath);

      return Right(result);
    } on GalleryException {
      return Left(GalleryFailure());
    }
  }
}
