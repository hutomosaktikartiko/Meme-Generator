import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/download_file_usecase.dart';
import '../../domain/usecases/save_to_gallery_usecase.dart';

part 'save_image_state.dart';

class SaveImageCubit extends Cubit<SaveImageState> {
  final DownloadFileUseCase downloadFileUseCase;
  final SaveToGalleryUseCase saveToGalleryUseCase;

  SaveImageCubit({
    required this.downloadFileUseCase,
    required this.saveToGalleryUseCase,
  }) : super(SaveImageInitial());

  Future<Either<Failure, bool>> downloadFile({
    required String fileUrl,
    required String directoryPath,
  }) async {
    return await downloadFileUseCase(DownloadFileParams(
      fileUrl: fileUrl,
      directoryPath: directoryPath,
    ));
  }

  Future<Either<Failure, bool>> saveToGallery({
    required String filePath,
  }) async {
    return await saveToGalleryUseCase(SaveToGalleryParams(filePath: filePath));
  }
}
