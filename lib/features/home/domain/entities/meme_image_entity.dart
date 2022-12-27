import 'package:equatable/equatable.dart';

class MemeImageEntity extends Equatable {
  final String? id, name, url;
  final int? width, height, boxCount;

  const MemeImageEntity({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    required this.boxCount,
  });

  @override
  List<Object?> get props => [id, name, url, width, height, boxCount];
}
