import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/theme_bloc.dart/themebloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrightnessCubit, Brightness>(
      builder: (context, state) {
        bool isNightMode = state == Brightness.dark;
        return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: SwitchListTile(
              title: const Text('Dark mode'),
              value: isNightMode,
              onChanged: (value) {
                context.read<BrightnessCubit>().toggleBrightness();
              },
            ));
      },
    );
  }
}
