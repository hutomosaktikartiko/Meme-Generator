import 'package:dio/dio.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/local_storage/dot_env_info.dart';
import '../../../home/data/models/meme_image_model.dart';
import '../../../home/domain/entities/meme_image_entity.dart';

abstract class MemeRemoteDataSource {
  /// Calls the https://api.imgflip.com/get_memes endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<MemeImageEntity>> getMemeImages();
}

class MemeRemoteDataSourceImpl implements MemeRemoteDataSource {
  final Dio dio;
  final DotEnvInfo dotEnvInfo;

  const MemeRemoteDataSourceImpl({
    required this.dio,
    required this.dotEnvInfo,
  });

  @override
  Future<List<MemeImageEntity>> getMemeImages() async {
    try {
      final String? apiUrl = dotEnvInfo.imgflipApiUrl();

      if (apiUrl == null) throw ServerException();

      final Response response = await dio.get("$apiUrl/get_memes");

      final Map<String, dynamic>? data = response.data;

      if (data == null) throw ServerException();

      if (data["success"] != true) throw ServerException();

      final List results =
          (data["data"]["memes"] is List) ? (data["data"]["memes"] ?? []) : [];

      return results.map((e) => MemeImageModel.fromJson(e)).toList();
    } on DioError catch (_) {
      rethrow;
    }
  }
}
