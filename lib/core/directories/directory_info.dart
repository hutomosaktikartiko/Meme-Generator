import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../error/exception.dart';

abstract class DirectoryInfo {
  Future<Directory> getTemporary();
}

class DirectoryInfoImpl implements DirectoryInfo {
  @override
  Future<Directory> getTemporary() async {
    try {
      return await getTemporaryDirectory();
    } catch (_) {
      throw PermissionException();
    }
  }
}
