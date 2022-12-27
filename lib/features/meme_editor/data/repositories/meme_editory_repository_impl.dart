import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/caption_image_entity.dart';
import '../../domain/repositories/meme_editor_repository.dart';
import '../datasources/meme_editor_remote_data_source.dart';

class MemeEditorRepositoryImpl implements MemeEditorRepository {
  final MemeEditorRemoteDataSource memeEditorRemoteDataSource;
  final NetworkInfo networkInfo;

  const MemeEditorRepositoryImpl({
    required this.memeEditorRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CaptionImageEntity>> setCaptionImage({
    required String? memeImageId,
    required String text0,
    required String text1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final CaptionImageEntity result =
            await memeEditorRemoteDataSource.setCaptionImage(
          memeImageId: memeImageId,
          text0: text0,
          text1: text1,
        );

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
