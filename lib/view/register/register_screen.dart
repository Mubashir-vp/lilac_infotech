import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lilac_info_tech/view/home/home.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../core/bloc/auth_bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final AuthBloc _authBloc = AuthBloc();
  String? selectedDate;
  File? _image;
  void _showOtpBottomSheet(
    BuildContext context,
    String verifcationId,
  ) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BlocBuilder<AuthBloc, AuthState>(
            bloc: _authBloc,
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter OTP',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PinCodeTextField(
                        onCompleted: (value) {
                          log('state $state');
                          _authBloc.add(
                            RegisterVerifyOtp(
                              verficationCode: value,
                              verficationId: verifcationId,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        appContext: context,
                        length: 6,
                        onChanged: (value) {},
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                          fieldHeight: 50,
                          fieldWidth: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Verify the entered OTP
                          // String otp = enteredOtp;
                          // Add your OTP verification logic here

                          // Close the bottom sheet
                          Navigator.of(context).pop();
                        },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Verify'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        // OtpBottomSheet(
        //   verificationId: verifcationId,
        //   isRegister: true,
        //   loginStatusCallback: (status) {
        //     if (status) {
        //       _authBloc.add(
        //         AddUserDetails(
        //           dob: selectedDate!,
        //           email: emailController.text,
        //           image: _image!,
        //           mobile: phoneController.text,
        //           name: nameController.text,
        //         ),
        //       );
        //     }
        //   },
        // ),
        );
  }

  Future<void> _getImageFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = DateFormat.yMMMd().format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, listenerState) {
        log('Listener State $listenerState');
        if (listenerState is OtpSent) {
          _showOtpBottomSheet(
            context,
            listenerState.verificationId,
          );
        } else if (listenerState is RegisteredUser) {
          log('Logged in State listener');
          _authBloc.add(
            AddUserDetails(
              dob: selectedDate!,
              email: emailController.text,
              image: _image!,
              mobile: phoneController.text,
              name: nameController.text,
            ),
          );
        } else if (listenerState is RegistrationSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => MyHomePage(
                    userModel: listenerState.userModel,
                  )),
            ),
          );
        } else if (listenerState is RegistrationFailed) {
          Fluttertoast.showToast(
              msg: listenerState.errorMesage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: HexColor('#57EE9D'),
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      bloc: _authBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Register with your details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(
                        20.0,
                      ),
                      child: GestureDetector(
                        onTap: () => _getImageFromGallery(),
                        child: _image != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(_image!),
                              )
                            : Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    50.0,
                                  ),
                                ),
                                elevation: 12,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        50,
                                      ),
                                    ),
                                  ),
                                  child: _image != null
                                      ? Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.image),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      validator: (val) {
                        if (val == '') {
                          return 'Name is required';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      validator: (val) {
                        if (val == '') {
                          return 'Email is required';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      validator: (val) {
                        if (val == '') {
                          return 'Phone number is required';
                        } else if (val!.length != 10) {
                          return 'Please enter a valid Phone number';
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
                    Padding(
                      padding: const EdgeInsets.all(
                        18.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(selectedDate != null
                            ? selectedDate!.toString()
                            : 'Select Date of Birth'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          if (selectedDate == null || selectedDate == '') {
                            Fluttertoast.showToast(
                                msg: "Please select your Date of birth",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: HexColor('#57EE9D'),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (_image == null) {
                            Fluttertoast.showToast(
                                msg: "Please select a profile image",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: HexColor('#57EE9D'),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (_formKey.currentState!.validate()) {
                            _authBloc.add(
                              LoginUserwithPhone(
                                  mobile: phoneController.text,
                                  isRegister: true),
                            );
                          } else {}
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.blue,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: state is AuthLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
