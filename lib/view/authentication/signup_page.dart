import 'dart:developer';

import 'package:chat_app_ayna/controller/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app_ayna/utils/validators.dart';
import 'package:chat_app_ayna/view/authentication/login_page.dart';
import 'package:chat_app_ayna/view/authentication/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/custom_elevated_button.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registered as ${state.user.email}')));
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => LoginPage(),
              ));
        }
      },
      child: Scaffold(
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
                        'Create an account',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        labelText: 'Name',
                        controller: nameController,
                        validator: nameValidation,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        labelText: 'Email',
                        controller: emailController,
                        validator: emailValidation,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        labelText: 'Password',
                        controller: passwordController,
                        validator: passwordValidation,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        labelText: 'Confirm Password',
                        controller: confirmPasswordController,
                        validator: (value) => confirmPassValidation(
                            value, passwordController.text),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      // Signup button handles the form validation and proceeds with the create user event
                      BlocBuilder<AuthBloc, AuthState>(
                        buildWhen: (previous, current) =>
                            current is AuthLoading || current is! AuthLoading,
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return CustomElevatedButton(
                              onPressed: () {},
                              child: const CupertinoActivityIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return CustomElevatedButton(
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
