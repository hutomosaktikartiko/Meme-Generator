import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/caption_image_entity.dart';
import '../../../domain/usecases/set_caption_image.dart';

part 'caption_image_state.dart';

class CaptionImageCubit extends Cubit<CaptionImageState> {
  final SetCaptionImage setCaptionImage;

  CaptionImageCubit({
    required this.setCaptionImage,
  }) : super(CaptionImageInitial());

  void init() {
    emit(CaptionImageInitial());
  }

  Future<bool> setCaption({
    required String? memeImageId,
    required String text0,
    required String text1,
  }) async {
    emit(CaptionImageLoading());

    final result = await setCaptionImage(
      Params(
        memeImageId: memeImageId,
        text0: text0,
        text1: text1,
      ),
    );

    return result.fold((l) {
      emit(CaptionImageError(failure: l));

      return false;
    }, (r) {
      emit(CaptionImageLoaded(
        image: r,
        imageMemeId: memeImageId,
      ));

      return true;
    });
  }
}
