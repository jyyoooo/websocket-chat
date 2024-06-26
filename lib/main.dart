import 'package:chat_app_ayna/controller/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app_ayna/controller/blocs/websocket_bloc/websocket_bloc.dart';
import 'package:chat_app_ayna/controller/cubits/session_cubit/session_list_cubit.dart';
import 'package:chat_app_ayna/controller/cubits/theme_cubit/theme_cubit.dart';
import 'package:chat_app_ayna/firebase_options.dart';
import 'package:chat_app_ayna/model/chat_session.dart';
import 'package:chat_app_ayna/model/message.dart';
import 'package:chat_app_ayna/view/authentication/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ChatSessionAdapter());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.openBox('sessions');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => SessionListCubit()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => WebSocketBloc())
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) => MaterialApp(
          theme: state ? ThemeData.dark() : ThemeData.light(),
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
        ),
      ),
    );
  }
}
