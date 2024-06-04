import 'package:chat_app_ayna/controller/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app_ayna/utils/validators.dart';
import 'package:chat_app_ayna/view/authentication/signup_page.dart';
import 'package:chat_app_ayna/view/chats/session_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                builder: (context) => SessionListScreen(userId: state.user.uid),
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AuthBloc, AuthState>(
                        buildWhen: (previous, current) =>
                            current is AuthLoading,
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue),
                                ),
                                child: const CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                                onPressed: () {});
                          } else {
                            return ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                              ),
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Email and Password is required')));
                                } else {
                                  context.read<AuthBloc>().add(LoginRequested(
                                      email: emailController.text,
                                      password: passwordController.text));
                                }
                              },
                              child: const Text('Login'),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // TextButton(
                          //   onPressed: () {},
                          //   child: const Text('Forgot Password?'),
                          // ),
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
