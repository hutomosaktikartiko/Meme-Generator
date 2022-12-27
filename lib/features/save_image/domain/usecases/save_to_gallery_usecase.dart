import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/save_file_repository.dart';

class SaveToGalleryUseCase implements UseCase<bool, SaveToGalleryParams> {
  final SaveFileRepository saveFileRepository;

  const SaveToGalleryUseCase({
    required this.saveFileRepository,
  });

  @override
  Future<Either<Failure, bool>> call(SaveToGalleryParams params) async {
    return await saveFileRepository.saveToGallery(filePath: params.filePath);
  }
}


class SaveToGalleryParams extends Equatable {
  final String filePath;

  const SaveToGalleryParams({
    required this.filePath,
  });

  @override
  List<Object> get props => [filePath];
}