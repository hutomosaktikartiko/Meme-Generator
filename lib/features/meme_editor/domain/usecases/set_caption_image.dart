import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/caption_image_entity.dart';
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
      text0: params.text0,
      text1: params.text1,
    );
  }
}

class Params extends Equatable {
  final String? memeImageId;
  final String text0, text1;

  const Params({
    required this.memeImageId,
    required this.text0,
    required this.text1,
  });

  @override
  List<Object?> get props => [memeImageId, text0, text1];
}
