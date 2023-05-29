import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lilac_info_tech/view/home/bloc/home_bloc.dart';
import 'package:lilac_info_tech/view/home/home.dart';
import 'package:lilac_info_tech/view/login/login.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => HomeBloc()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  LoginScreen(),
    );
  }
}
