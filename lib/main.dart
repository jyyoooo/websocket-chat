import 'package:chat_app_ayna/controller/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app_ayna/controller/blocs/websocket_bloc/websocket_bloc.dart';
import 'package:chat_app_ayna/controller/blocs/websocket_bloc/websocket_event.dart';
import 'package:chat_app_ayna/firebase_options.dart';
import 'package:chat_app_ayna/view/authentication/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(
            create: (context) => WebSocketBloc()..add(ConnectWebSocket()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthBloc()),
            BlocProvider(
                create: (context) => WebSocketBloc()..add(ConnectWebSocket()))
          ],
          child: SignUpPage(),
        ),
      ),
    );
  }
}
