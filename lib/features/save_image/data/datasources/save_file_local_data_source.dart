import 'package:gallery_saver/gallery_saver.dart';

import '../../../../core/directories/directory_info.dart';
import '../../../../core/error/exception.dart';

abstract class SaveFileLocalDataSource {
  Future<bool> saveToGallery({
    required String filePath,
  });
}

class SaveFileLocalDataSourceImpl implements SaveFileLocalDataSource {
  @override
  Future<bool> saveToGallery({required String filePath}) async {
    try {
      final bool? result = await GallerySaver.saveImage(filePath);

      if (result == null) throw GalleryException();

      return result;
    } catch (_) {
      throw GalleryException();
    }
  }
}
