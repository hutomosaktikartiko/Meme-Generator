import 'package:dio/dio.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/local_storage/dot_env_info.dart';
import '../../domain/entities/caption_image_entity.dart';
import '../../domain/entities/text_caption_entity.dart';
import '../models/caption_image_model.dart';

abstract class MemeEditorRemoteDataSource {
  /// Calls the https://api.imgflip.com/caption_image endpint.
  ///
  /// Throws a [SeverException] for all error codes.
  ///
  /// Params memeImageId for image id, text0 for top meme caption, and text1 for bottom meme caption.
  Future<CaptionImageEntity> setCaptionImage({
    required String? memeImageId,
    required List<TextCaptionEntity> text,
  });
}

class MemeEditorRemoteDataSourceImpl implements MemeEditorRemoteDataSource {
  final Dio dio;
  final DotEnvInfo dotEnvInfo;

  const MemeEditorRemoteDataSourceImpl({
    required this.dio,
    required this.dotEnvInfo,
  });

  @override
  Future<CaptionImageEntity> setCaptionImage({
    required String? memeImageId,
    required List<TextCaptionEntity> text,
  }) async {
    try {
      final String? apiUrl = dotEnvInfo.imgflipApiUrl();
      final String? username = dotEnvInfo.imgflipUsername();
      final String? password = dotEnvInfo.imgflipPassword();

      if (apiUrl == null || username == null || password == null) {
        throw ServerException();
      }

      final FormData formData = FormData.fromMap({
        "template_id": memeImageId,
        "username": username,
        "password": password,
        "boxes": text.map((e) => e.toJson()).toList(),
      });

      final Response response = await dio.post(
        "$apiUrl/caption_image",
        data: formData,
      );

      final Map<String, dynamic>? data = response.data;

      if (data == null) throw ServerException();

      if (data["success"] != true) throw ServerException();

      return CaptionImageModel.fromJson(data["data"]);
    } on DioError catch (_) {
      rethrow;
    }
  }
}
