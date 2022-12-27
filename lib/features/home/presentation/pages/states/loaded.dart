import 'package:flutter/material.dart';

import '../../../../../shared/config/asset_path.dart';
import '../../../../meme_editor/presentation/pages/edit_meme_page.dart';
import '../../../domain/entities/meme_image_entity.dart';

class Loaded extends StatelessWidget {
  final List<MemeImageEntity> images;

  const Loaded({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.center,
        children: images
            .asMap()
            .map(
              (key, value) => MapEntry(
                key,
                _buildImage(
                  image: value,
                  context: context,
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }

  Widget _buildImage({
    required MemeImageEntity image,
    required BuildContext context,
  }) {
    return Stack(
      children: [
        FadeInImage(
          placeholder: const AssetImage(AssetPath.placeholderImage),
          image: NetworkImage(image.url ?? ""),
          width: MediaQuery.of(context).size.width / 3.5,
          height: MediaQuery.of(context).size.width / 3.5,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditMemePage(image: image),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
