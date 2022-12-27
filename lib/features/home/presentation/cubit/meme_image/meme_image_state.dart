part of 'meme_image_cubit.dart';

abstract class MemeImageState extends Equatable {
  const MemeImageState();

  @override
  List<Object> get props => [];
}

class MemeImageInitial extends MemeImageState {}

class MemeImageLoading extends MemeImageState {}

class MemeImageLoaded extends MemeImageState {
  final List<MemeImageEntity> images;

  const MemeImageLoaded({required this.images,});

  @override
  List<Object> get props => [images];
}

class MemeImageError extends MemeImageState {
  final Failure failure;

  const MemeImageError({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}