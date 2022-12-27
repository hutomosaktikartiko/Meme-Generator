import 'package:equatable/equatable.dart';

class CaptionImageEntity extends Equatable {
  final String? url, pageUrl;

  const CaptionImageEntity({
    required this.url,
    required this.pageUrl,
  });

  @override
  List<Object?> get props => [url, pageUrl];
}