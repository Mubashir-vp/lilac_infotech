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
    Future.delayed(
        const Duration(
          seconds: 3,
        ), () {
      _authBloc.add(CheckUser());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is LogedInState) {
          log('LogedInState');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                userModel: state.userModel,
              ),
            ),
          );
        } else if (state is LogedOutState) {
          log('LogedOutState');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/images/splash_image.png'),
        ),
      ),
    );
  }
}
