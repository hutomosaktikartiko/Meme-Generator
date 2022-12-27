import '../../domain/entities/meme_image_entity.dart';

class MemeImageModel extends MemeImageEntity {
  const MemeImageModel({
    required String? id,
    required String? name,
    required String? url,
    required int? height,
    required int? width,
    required int? boxCount,
  }) : super(
          id: id,
          name: name,
          url: url,
          height: height,
          width: width,
          boxCount: boxCount,
        );

  factory MemeImageModel.fromJson(Map<String, dynamic> json) {
    return MemeImageModel(
      id: json["id"],
      name: json["name"],
      url: json["url"],
      height: json["height"],
      width: json["width"],
      boxCount: json["box_count"],
    );
  }
}
