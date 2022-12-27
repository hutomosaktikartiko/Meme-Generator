part of 'caption_image_cubit.dart';

abstract class CaptionImageState extends Equatable {
  const CaptionImageState();

  @override
  List<Object?> get props => [];
}

class CaptionImageInitial extends CaptionImageState {}

class CaptionImageLoading extends CaptionImageState {}

class CaptionImageLoaded extends CaptionImageState {
  final CaptionImageEntity image;
  final String? imageMemeId;

  const CaptionImageLoaded({
    required this.image,
    required this.imageMemeId,
  });

  @override
  List<Object?> get props => [image, imageMemeId,];
}

class CaptionImageError extends CaptionImageState {
  final Failure failure;

  const CaptionImageError({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}