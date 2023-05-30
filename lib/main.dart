import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lilac_info_tech/core/bloc/auth_bloc/auth_bloc.dart';
import 'package:lilac_info_tech/view/splash/splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'core/bloc/theme_bloc.dart/themebloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDir = await getApplicationDocumentsDirectory();

  // Set the storage path for HydratedBloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: appDocumentDir,
  );
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => AuthBloc()),
    BlocProvider(
      create: (context) => BrightnessCubit(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrightnessCubit, Brightness>(
      builder: (context, brightness) {
        return ThemeProvider(
          child: MaterialApp(
            darkTheme: ThemeData.dark(),
            title: 'Flutter Demo',
            theme: ThemeData(brightness: brightness),
            home: const Splash(),
          ),
        );
      },
    );
  }
}
