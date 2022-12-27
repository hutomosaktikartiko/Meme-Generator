import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/directories/directory_info.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/local_pickers/image_picker_info.dart';
import '../../../../service_locator.dart';
import '../../../../shared/config/asset_path.dart';
import '../../../../shared/extensions/failure_parsing.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../../home/domain/entities/meme_image_entity.dart';
import '../../../save_image/presentation/cubit/save_image_cubit.dart';
import '../cubit/caption_image/caption_image_cubit.dart';

class EditMemePage extends StatefulWidget {
  final MemeImageEntity image;

  const EditMemePage({
    super.key,
    required this.image,
  });

  @override
  State<EditMemePage> createState() => _EditMemePageState();
}

class _EditMemePageState extends State<EditMemePage> {
  bool isLoading = false;
  File? _selectedLogo;
  final TextEditingController _textTopController = TextEditingController();
  final TextEditingController _textBottomController = TextEditingController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    final CaptionImageState state =
        BlocProvider.of<CaptionImageCubit>(context).state;
    if (state is CaptionImageLoaded) {
      if (state.imageMemeId == widget.image.id) {
        return;
      }
    }

    // init CaptionImageCubit
    BlocProvider.of<CaptionImageCubit>(context).init();
  }

  @override
  void dispose() {
    _textTopController.dispose();
    _textBottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_textTopController ${_textTopController.text}");
    print("_textBottomController ${_textBottomController.text}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("MIM GENERATOR"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                _buildImagePreview(),
                (isLoading)
                    ? Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEditButton(
                  label: "Add Logo",
                  icon: Icons.image,
                  onTap: _onAddLogo,
                ),
                const SizedBox(
                  width: 10,
                ),
                _buildEditButton(
                  label: "Add Text Top",
                  icon: Icons.text_fields_sharp,
                  onTap: () {
                    _showEditingTextDialog(
                      label: "Text Top",
                      controller: _textTopController,
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                _buildEditButton(
                  label: "Add Text Bottom",
                  icon: Icons.text_fields_sharp,
                  onTap: () {
                    _showEditingTextDialog(
                      label: "Text Bottom",
                      controller: _textBottomController,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: (isLoading) ? null : _onPreviewCaption,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("Preview"),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildButton(
              label: "Simpan",
              onTap: _onSaveImage,
            ),
            const SizedBox(
              width: 10,
            ),
            _buildButton(
              label: "Share",
              onTap: _onShareImage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final state = context.watch<CaptionImageCubit>().state;

    if (state is CaptionImageLoaded) {
      return FadeInImage(
        placeholder: const AssetImage(AssetPath.placeholderImage),
        image: NetworkImage(state.image.url ?? ""),
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.contain,
      );
    }

    return FadeInImage(
      placeholder: const AssetImage(AssetPath.placeholderImage),
      image: NetworkImage(widget.image.url ?? ""),
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.contain,
    );
  }

  SizedBox _buildButton({
    required String label,
    required Function() onTap,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3,
      child: ElevatedButton(
        onPressed: (isLoading) ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildEditButton({
    required String label,
    required Function() onTap,
    required IconData icon,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: (isLoading) ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(
              height: 5,
            ),
            Icon(
              icon,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditingTextDialog({
    required TextEditingController controller,
    required String label,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddLogo() async {
    _showSelectImageActionSheet();
  }

  void _onPreviewCaption() async {
    // set loading to true
    setState(() {
      isLoading = true;
    });

    // set caption image
    final bool result =
        await BlocProvider.of<CaptionImageCubit>(context).setCaption(
      memeImageId: widget.image.id,
      text0: _textTopController.text,
      text1: _textBottomController.text,
    );

    // set loading to false
    setState(() {
      isLoading = false;
    });

    if (!result) {
      // error
      CustomSnackbar.error(
        context: context,
        label: "Failed set caption image, please try again",
      );
    }
  }

  void _onSaveImage() async {
    // Show loading dialog
    showDialog(
      context: context,
      builder: (contex) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(
                margin: const EdgeInsets.only(left: 7),
                child: const Text("Loading..."),
              ),
            ],
          ),
        );
      },
    );

    String? imageUrl;

    final CaptionImageState state =
        BlocProvider.of<CaptionImageCubit>(context).state;

    if (state is CaptionImageLoaded) {
      imageUrl = state.image.url;
    } else {
      imageUrl = widget.image.url;
    }

    if (imageUrl == null) {
      return;
    }

    try {
      final Directory directory = await sl<DirectoryInfo>().getTemporary();

      final String directoryPath =
          "${directory.path}/${imageUrl.split("/").last}-${DateTime.now().microsecondsSinceEpoch}.jpg";

      if (!await _onDownloadImage(
        imageUrl: imageUrl,
        directoryPath: directoryPath,
      )) {
        throw ServerException();
      }

      if (!await _onDownloadImage(
        imageUrl: imageUrl,
        directoryPath: directoryPath,
      )) {
        throw ServerException();
      }

      if (!await _onSaveImageToGallery(
        filePath: directoryPath,
      )) {
        throw ServerException();
      }

      // success
      CustomSnackbar.success(
        context: context,
        label: "Image saved at $directoryPath",
      );
    } catch (e) {
      // error
      CustomSnackbar.error(
        context: context,
        label: "Failed download image, please try again $e",
      );
    }

    // Close loading
    Navigator.pop(context);
  }

  void _onShareImage() async {
    _showShareActionSheet();
  }

  Future<bool> _onDownloadImage({
    required String imageUrl,
    required String directoryPath,
  }) async {
    try {
      // Download file
      final result =
          await BlocProvider.of<SaveImageCubit>(context).downloadFile(
        fileUrl: imageUrl,
        directoryPath: directoryPath,
      );

      return result.fold(
        (l) => false,
        (r) => true,
      );
    } on DirectoryException {
      return false;
    }
  }

  Future<bool> _onSaveImageToGallery({
    required String filePath,
  }) async {
    try {
      // Download file
      final result =
          await BlocProvider.of<SaveImageCubit>(context).saveToGallery(
        filePath: filePath,
      );

      return result.fold(
        (l) => false,
        (r) => true,
      );
    } on DirectoryException {
      return false;
    }
  }

  void _showSelectImageActionSheet() {
    // Show modalBottomSheet
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: mockListSelectImageActions
              .asMap()
              .map(
                (key, value) => MapEntry(
                  key,
                  ListTile(
                    leading: Icon(value.icon),
                    title: Text(value.title),
                    onTap: () => _onSelectPhoto(
                      context: context,
                      imageSource: value.imageSource,
                    ),
                  ),
                ),
              )
              .values
              .toList(),
        );
      },
    );
  }

  void _onSelectPhoto({
    required BuildContext context,
    required ImageSource imageSource,
  }) async {
    try {
      // Select Image
      File result =
          await sl<ImagePickerInfo>().selectImage(imageSource: imageSource);

      setState(() {
        _selectedLogo = result;
      });

      // Close bottomSheet
      Navigator.pop(context);

      // TODO: Implement how to combine selected image to image template
      // imgflip.com not support to add image in the caption image
    } on SelectImageException {
      // error
      CustomSnackbar.error(
          context: context, label: SelectImageFailure().toStringMessage());
    }
  }

  void _showShareActionSheet() {
    // Show modalBottomSheet
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: mockListSelectShareActions
              .asMap()
              .map(
                (key, value) => MapEntry(
                  key,
                  ListTile(
                    leading: Icon(value.icon),
                    title: Text("Share to ${value.title}"),
                    onTap: () => _onShare(target: value.title),
                  ),
                ),
              )
              .values
              .toList(),
        );
      },
    );
  }

  void _onShare({required String target}) {
    if (target.toUpperCase() == "FACEBOOK") {
      _onShareToFacebook();
    } else {
      _onShareToTwitter();
    }
  }

  void _onShareToFacebook() {
    // TODO: Implement share to facebook
  }

  void _onShareToTwitter() {
    // TODO: Implement share to twitter
  }
}

class SelectImageActionModel {
  IconData icon;
  String title;
  ImageSource imageSource;

  SelectImageActionModel({
    required this.icon,
    required this.title,
    required this.imageSource,
  });
}

final List<SelectImageActionModel> mockListSelectImageActions = [
  SelectImageActionModel(
    icon: Icons.photo_camera,
    title: "Camera",
    imageSource: ImageSource.camera,
  ),
  SelectImageActionModel(
    icon: Icons.perm_media,
    title: "Gallery",
    imageSource: ImageSource.gallery,
  ),
];

class SelectShareActionModel {
  IconData icon;
  String title;

  SelectShareActionModel({
    required this.icon,
    required this.title,
  });
}

final List<SelectShareActionModel> mockListSelectShareActions = [
  SelectShareActionModel(
    icon: Icons.facebook,
    title: "Facebook",
  ),
  SelectShareActionModel(
    icon: Icons.flutter_dash,
    title: "Twitter",
  ),
];
