import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/meme_image_entity.dart';

abstract class MemeRepository {
  Future<Either<Failure, List<MemeImageEntity>>> getMemeImages();
}