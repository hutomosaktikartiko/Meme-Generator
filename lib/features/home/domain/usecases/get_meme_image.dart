import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/meme_image_entity.dart';
import '../repositories/meme_repository.dart';

class GetMemeImages implements UseCase<List<MemeImageEntity>, NoParams> {
  final MemeRepository memeRepository;

  const GetMemeImages({
    required this.memeRepository,
  });

  @override
  Future<Either<Failure, List<MemeImageEntity>>> call(NoParams params) async {
    return await memeRepository.getMemeImages();
  }
}

