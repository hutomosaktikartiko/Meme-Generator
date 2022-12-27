import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/save_file_repository.dart';

class DownloadFileUseCase implements UseCase<bool, DownloadFileParams> {
  final SaveFileRepository saveFileRepository;

  const DownloadFileUseCase({
    required this.saveFileRepository,
  });

  @override
  Future<Either<Failure, bool>> call(DownloadFileParams params) async {
    return await saveFileRepository.downloadFile(
      fileUrl: params.fileUrl,
      directoryPath: params.directoryPath,
    );
  }
}

class DownloadFileParams extends Equatable {
  final String fileUrl, directoryPath;

  const DownloadFileParams({
    required this.fileUrl,
    required this.directoryPath,
  });

  @override
  List<Object> get props => [
        fileUrl,
        directoryPath,
      ];
}
