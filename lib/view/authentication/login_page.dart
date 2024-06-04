import 'package:chat_app_ayna/controller/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app_ayna/utils/validators.dart';
import 'package:chat_app_ayna/view/authentication/signup_page.dart';
import 'package:chat_app_ayna/view/chats/responsive_chat_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/custom_elevated_button.dart';
import 'widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    ResponsiveChatScreen(userId: state.user.uid),
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
                width: isPortrait ? double.infinity : 600,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
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
                      BlocBuilder<AuthBloc, AuthState>(
                        buildWhen: (previous, current) =>
                            current is AuthLoading,
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return CustomElevatedButton(
                                child: const CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                                onPressed: () {});
                          } else {
                            return CustomElevatedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Email and Password are required')));
                                } else {
                                  context.read<AuthBloc>().add(LoginRequested(
                                      email: emailController.text,
                                      password: passwordController.text));
                                }
                              },
                              child: const Text('Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ));
                        },
                        child: const Text('Dont have an account? Sign Up'),
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
