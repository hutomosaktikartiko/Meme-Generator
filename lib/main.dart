import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/presentation/cubit/meme_image/meme_image_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/meme_editor/presentation/cubit/caption_image/caption_image_cubit.dart';
import 'features/save_image/presentation/cubit/save_image_cubit.dart';
import 'service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load service locator
  await di.main();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<MemeImageCubit>()..getImages(),
        ),
        BlocProvider(
          create: (context) => di.sl<CaptionImageCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<SaveImageCubit>(),
        ),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
