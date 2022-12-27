import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/core/local_pickers/image_picker_info.dart';

import 'core/directories/directory_info.dart';
import 'core/local_storage/dot_env_info.dart';
import 'core/network/network_info.dart';
import 'features/home/data/datasources/meme_remote_data_source.dart';
import 'features/home/data/repositories/meme_repository_impl.dart';
import 'features/home/domain/repositories/meme_repository.dart';
import 'features/home/domain/usecases/get_meme_image.dart';
import 'features/home/presentation/cubit/meme_image/meme_image_cubit.dart';
import 'features/meme_editor/data/datasources/meme_editor_remote_data_source.dart';
import 'features/meme_editor/data/repositories/meme_editory_repository_impl.dart';
import 'features/meme_editor/domain/repositories/meme_editor_repository.dart';
import 'features/meme_editor/domain/usecases/set_caption_image.dart';
import 'features/meme_editor/presentation/cubit/caption_image/caption_image_cubit.dart';
import 'features/save_image/data/datasources/download_file_remote_data_source.dart';
import 'features/save_image/data/datasources/save_file_local_data_source.dart';
import 'features/save_image/data/repositories/save_file_repository_impl.dart';
import 'features/save_image/domain/repositories/save_file_repository.dart';
import 'features/save_image/domain/usecases/download_file_usecase.dart';
import 'features/save_image/domain/usecases/save_to_gallery_usecase.dart';
import 'features/save_image/presentation/cubit/save_image_cubit.dart';
import 'shared/config/asset_path.dart';

final sl = GetIt.instance;

Future<void> main() async {
  await _external();

  await _core();

  await _shared();

  await _home();

  await _memeEditor();

  await _saveImage();

  await _shareImage();
}

Future<void> _external() async {
  await dotenv.load(fileName: AssetPath.envDevelopment);
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<ImagePicker>(() => ImagePicker());
}

Future<void> _core() async {
  sl.registerLazySingleton<DotEnvInfo>(() => DotEnvInfoImpl());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: sl()));
  sl.registerLazySingleton<DirectoryInfo>(() => DirectoryInfoImpl());
  sl.registerLazySingleton<ImagePickerInfo>(() => ImagePickerInfoImpl(imagePicker: sl()));
}

Future<void> _shared() async {}

Future<void> _home() async {
  // Datasources
  sl.registerLazySingleton<MemeRemoteDataSource>(() => MemeRemoteDataSourceImpl(dio: sl(), dotEnvInfo: sl()));

  // Repository
  sl.registerLazySingleton<MemeRepository>(() => MemeRepositoryImpl(memeRemoteDataSource: sl(), networkInfo: sl()));
  
  // Usecase
  sl.registerLazySingleton<GetMemeImages>(() => GetMemeImages(memeRepository: sl()));

  // Cubit
  sl.registerFactory<MemeImageCubit>(() => MemeImageCubit(getMemeImages: sl()));
}

Future<void> _memeEditor() async {
  // Datasources
  sl.registerLazySingleton<MemeEditorRemoteDataSource>(() => MemeEditorRemoteDataSourceImpl(dio: sl(), dotEnvInfo: sl()));

  // Repository
  sl.registerLazySingleton<MemeEditorRepository>(() => MemeEditorRepositoryImpl(memeEditorRemoteDataSource: sl(), networkInfo: sl()));

  // Usecase
  sl.registerLazySingleton<SetCaptionImage>(() => SetCaptionImage(memeEditorRepository: sl()));

  // Cubit
  sl.registerFactory<CaptionImageCubit>(() => CaptionImageCubit(setCaptionImage: sl()));
}

Future<void> _saveImage() async {
  // Datasources
  sl.registerLazySingleton<SaveFileLocalDataSource>(() => SaveFileLocalDataSourceImpl());
  sl.registerLazySingleton<DownloadFileRemoteDataSource>(() => DownloadFileRemoteDataSourceImpl(dio: sl(), directoryInfo: sl()));

  // Repository
  sl.registerLazySingleton<SaveFileRepository>(() => SaveFileRepositoryImpl(downloadFileRemoteDataSource: sl(), networkInfo: sl(), saveFileLocalDataSource: sl()));

  // Usecase
  sl.registerLazySingleton<DownloadFileUseCase>(() => DownloadFileUseCase(saveFileRepository: sl()));
  sl.registerLazySingleton<SaveToGalleryUseCase>(() => SaveToGalleryUseCase(saveFileRepository: sl()));

  // Cubit
  sl.registerFactory<SaveImageCubit>(() => SaveImageCubit(downloadFileUseCase: sl(), saveToGalleryUseCase: sl()));
}

Future<void> _shareImage() async {}
