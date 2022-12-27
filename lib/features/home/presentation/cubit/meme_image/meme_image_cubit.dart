import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../home/domain/entities/meme_image_entity.dart';
import '../../../../home/domain/usecases/get_meme_image.dart';

part 'meme_image_state.dart';

class MemeImageCubit extends Cubit<MemeImageState> {
  final GetMemeImages getMemeImages;

  MemeImageCubit({
    required this.getMemeImages,
  }) : super(MemeImageInitial());

  Future<void> getImages() async {
    emit(MemeImageLoading());

    final result = await getMemeImages(NoParams());

    result.fold((l) {
      emit(MemeImageError(failure: l));
    }, (r) {
      emit(MemeImageLoaded(images: r));
    });
  }
}
