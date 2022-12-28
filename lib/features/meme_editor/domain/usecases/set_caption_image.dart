import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/caption_image_entity.dart';
import '../entities/text_caption_entity.dart';
import '../repositories/meme_editor_repository.dart';

class SetCaptionImage implements UseCase<CaptionImageEntity, Params> {
  final MemeEditorRepository memeEditorRepository;

  const SetCaptionImage({
    required this.memeEditorRepository,
  });

  @override
  Future<Either<Failure, CaptionImageEntity>> call(Params params) async {
    return await memeEditorRepository.setCaptionImage(
      memeImageId: params.memeImageId,
      text: params.text,
    );
  }
}

class Params extends Equatable {
  final String? memeImageId;
  final List<TextCaptionEntity> text;

  const Params({
    required this.memeImageId,
    required this.text,
  });

  @override
  List<Object?> get props => [memeImageId, text,];
}
