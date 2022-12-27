import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/meme_image/meme_image_cubit.dart';
import 'states/error.dart';
import 'states/loaded.dart';
import 'states/loading.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MIM GENERATOR"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: ListView(
          children: [
            BlocBuilder<MemeImageCubit, MemeImageState>(
                builder: (context, state) {
              if (state is MemeImageLoaded) {
                return Loaded(
                  images: state.images,
                );
              } else if (state is MemeImageError) {
                return Error(
                  failure: state.failure,
                );
              }

              return const Loading();
            })
          ],
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    return await BlocProvider.of<MemeImageCubit>(context).getImages();
  }
}
