import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/directories/directory_info.dart';
import '../../../../core/error/exception.dart';
import '../../../../service_locator.dart';
import '../../../../shared/config/asset_path.dart';
import '../../../../shared/widgets/keyboards/close_keyboard.dart';
import '../../../../shared/widgets/loadings/custom_loading.dart';
import '../../../../shared/widgets/snackbars/custom_snackbar.dart';
import '../../../home/domain/entities/meme_image_entity.dart';
import '../../../save_image/presentation/cubit/save_image_cubit.dart';
import '../../domain/entities/text_caption_entity.dart';
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

  final List<TextCaptionEntity> _textCaptions = [];

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Meme"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => CloseKeyboard.close(context),
        child: SingleChildScrollView(
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
              _buildAddTextButton(),
              const SizedBox(
                height: 10,
              ),
              ..._textCaptions
                  .asMap()
                  .map(
                    (key, value) => MapEntry(
                      key,
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _buildForm(index: key),
                      ),
                    ),
                  )
                  .values
                  .toList(),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: (isLoading) ? null : _onPreview,
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
              label: "Save to Gallery",
              onTap: _onSaveImage,
            ),
            const SizedBox(
              width: 10,
            ),
            _buildButton(
              label: "Share",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTextButton() {
    if (_textCaptions.length < (widget.image.boxCount ?? 0)) {
      return _buildEditButton(
        label: "Add Text",
        icon: Icons.text_fields_sharp,
        onTap: _onAddText,
      );
    }

    return const SizedBox.shrink();
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: (isLoading) ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
      ),
    );
  }

  Widget _buildForm({required int index}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Text caption ${index + 1}",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 15,
              ),
            ),
            onChanged: (val) {
              setState(() {
                _textCaptions[index] = _textCaptions[index].copyWith(
                  text: val,
                );
              });
            },
          ),
        ),
        const SizedBox(
          width: 7,
        ),
        GestureDetector(
          child: const Icon(
            Icons.delete_forever,
            color: Colors.grey,
          ),
          onTap: () {
            setState(() {
              _textCaptions.removeAt(index);
            });
          },
        )
      ],
    );
  }

  void _onAddText() {
    if (_textCaptions.length > (widget.image.boxCount ?? 0)) {
      // Text filled more than max box count of image
      CustomSnackbar.warning(
        context: context,
        label: "Max of text box is ${widget.image.boxCount ?? 0}",
      );

      return;
    }

    setState(() {
      _textCaptions.add(
        const TextCaptionEntity(
          text: "",
        ),
      );
    });
  }

  void _onPreview() async {
    final List<TextCaptionEntity> cleanedTextCaptions =
        _textCaptions.where((element) => element.text != "").toList();

    if (cleanedTextCaptions.isEmpty) {
      // empty captions
      CustomSnackbar.warning(
        context: context,
        label: "Set min 1 text caption",
      );

      return;
    }

    // set loading to true
    setState(() {
      isLoading = true;
    });

    // set caption image
    final bool result =
        await BlocProvider.of<CaptionImageCubit>(context).setCaption(
      memeImageId: widget.image.id,
      text: cleanedTextCaptions,
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
    CustomLoading.loadingWithText(context);

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
}
