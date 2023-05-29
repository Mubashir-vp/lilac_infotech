import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lilac_info_tech/view/home/home.dart';
import 'package:lilac_info_tech/view/login/login.dart';

import '../../core/bloc/auth_bloc/auth_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final AuthBloc _authBloc = AuthBloc();
  @override
  void initState() {
    // TODO: implement initState
    _authBloc.add(CheckUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is LogedInState) {
          log('LogedInState');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
        } else if (state is LogedOutState) {
          log('LogedOutState');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Icon(
            Icons.video_collection_rounded,
          ),
        ),
      ),
    );
  }
}
