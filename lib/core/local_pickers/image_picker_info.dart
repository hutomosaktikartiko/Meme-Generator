import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../error/exception.dart';

abstract class ImagePickerInfo {
  Future<File> selectImage({required ImageSource imageSource});
}

class ImagePickerInfoImpl implements ImagePickerInfo {
  final ImagePicker imagePicker;

  const ImagePickerInfoImpl({
    required this.imagePicker,
  });

  @override
  Future<File> selectImage({
    required ImageSource imageSource,
  }) async {
    try {
      final XFile? result = await imagePicker.pickImage(source: imageSource);

      if (result == null) throw SelectImageException();

      return File(result.path);
    } catch (_) {
      throw SelectImageException();
    }
  }
}