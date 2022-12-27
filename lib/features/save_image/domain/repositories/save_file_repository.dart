import 'package:dartz/dartz.dart';
import 'package:meme_generator/core/error/failure.dart';

abstract class SaveFileRepository {
  Future<Either<Failure, bool>> downloadFile({
    required String fileUrl,
    required String directoryPath,
  });
  Future<Either<Failure, bool>> saveToGallery({
    required String filePath,
  });
}