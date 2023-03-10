import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/caption_image_entity.dart';
import '../entities/text_caption_entity.dart';

abstract class MemeEditorRepository {
  Future<Either<Failure, CaptionImageEntity>> setCaptionImage({
    required String? memeImageId,
    required List<TextCaptionEntity> text,
  });
}