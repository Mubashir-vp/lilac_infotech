import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../core/bloc/auth_bloc/auth_bloc.dart';
import '../../widgets/otpsheet.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final AuthBloc _authBloc = AuthBloc();
  final TextEditingController _mobileEditingController =
      TextEditingController();
  void _showOtpBottomSheet(
    BuildContext context,
    String verifcationId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => OtpBottomSheet(
        verificationId: verifcationId,
        phone: _mobileEditingController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, listenerState) {
        if (listenerState is OtpSent) {
          _showOtpBottomSheet(
            context,
            listenerState.verificationId,
          );
        }
        if (listenerState is NewUser) {
          Fluttertoast.showToast(
              msg: 'Please register to Login',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: HexColor('#57EE9D'),
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const RegisterScreen()),
            ),
          );
        }
      },
      bloc: _authBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/login.png'),
                  const Padding(
                    padding: EdgeInsets.only(
                      bottom: 26.0,
                      left: 8,
                    ),
                    child: Text(
                      'Login with your Phone Number',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _mobileEditingController,
                      validator: (value) {
                        if (value!.isEmpty || value == '') {
                          return 'Enter your phone number';
                        } else if (value.length != 10) {
                          return 'Enter a valid phone number';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _authBloc.add(
                            LoginUserwithPhone(
                                mobile: _mobileEditingController.text,
                                isRegister: false),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blue,
                        ),
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'New here? Click to Register',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
