import 'dart:developer';
import 'package:chat_app_ayna/controller/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app_ayna/view/authentication/login_page.dart';
import 'package:chat_app_ayna/view/chats/responsive_chat_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 950), () {
      context.read<AuthBloc>().add(AppStartEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          log('user found ${state.user.email}');
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => ResponsiveChatScreen(
                      userId: state.user.uid,
                    )),
          );
        } else if (state is Unauthenticated) {
          log('no user found');
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => LoginPage()));
        }
      },
      child: const Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'WebSocket Chat',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 15),
          CupertinoActivityIndicator()
        ],
      ))),
    );
  }
}
