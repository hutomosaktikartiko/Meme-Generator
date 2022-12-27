import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../home/domain/entities/meme_image_entity.dart';
import '../../domain/repositories/meme_repository.dart';
import '../datasources/meme_remote_data_source.dart';

class MemeRepositoryImpl implements MemeRepository {
  final MemeRemoteDataSource memeRemoteDataSource;
  final NetworkInfo networkInfo;

  const MemeRepositoryImpl({
    required this.memeRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MemeImageEntity>>> getMemeImages() async {
    if (await networkInfo.isConnected) {
      try {
        final List<MemeImageEntity> result =
            await memeRemoteDataSource.getMemeImages();

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
