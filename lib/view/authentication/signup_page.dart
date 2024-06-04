import 'dart:developer';

import 'package:chat_app_ayna/controller/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app_ayna/utils/validators.dart';
import 'package:chat_app_ayna/view/authentication/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isPortrait = constraints.maxWidth < 600;

          return Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: isPortrait ? double.infinity : 500,
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Create an Account',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      validator: nameValidation,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      validator: emailValidation,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      validator: passwordValidation,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
                      validator: (value) =>
                          confirmPassValidation(value, passwordController.text),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Signup button handles the form validation and proceeds with the create user event
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (previous, current) => current is AuthLoading,
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue),
                            ),
                            onPressed: () {},
                            child: const CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue),
                            ),
                            onPressed: () {
                              if (_formkey.currentState!.validate() &&
                                  confirmPasswordController.text ==
                                      passwordController.text) {
                                context.read<AuthBloc>().add(SignUpRequested(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ));
                              }
                            },
                            child: const Text('Sign Up'),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    //Text button for switching to the login page
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: const Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
