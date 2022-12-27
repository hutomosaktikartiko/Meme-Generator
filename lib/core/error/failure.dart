import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class NetworkFailure extends Failure {}

class CacheFailure extends Failure {}

class PermissionFailure extends Failure {}

class DirectoryFailure extends Failure {}

class GalleryFailure extends Failure {}

class SelectImageFailure extends Failure {}