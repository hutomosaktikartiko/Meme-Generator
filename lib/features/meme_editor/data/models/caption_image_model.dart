import '../../domain/entities/caption_image_entity.dart';

class CaptionImageModel extends CaptionImageEntity {
  const CaptionImageModel({
    required String? url,
    required String? pageUrl,
  }) : super(
          url: url,
          pageUrl: pageUrl,
        );

  factory CaptionImageModel.fromJson(Map<String, dynamic> json) {
    return CaptionImageModel(
      url: json["url"],
      pageUrl: json["page_url"],
    );
  }
}
