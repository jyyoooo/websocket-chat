import 'dart:developer';
import 'package:chat_app_ayna/controller/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app_ayna/controller/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app_ayna/controller/cubits/session_cubit/session_list_cubit.dart';
import 'package:chat_app_ayna/controller/cubits/theme_cubit/theme_cubit.dart';
import 'package:chat_app_ayna/model/chat_session.dart';
import 'package:chat_app_ayna/view/authentication/login_page.dart';
import 'package:chat_app_ayna/view/authentication/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'chat_screen.dart';

class SessionListScreen extends StatelessWidget {
  final String userId;
  final Function(String)? onSessionSelected;

  const SessionListScreen({
    super.key,
    required this.userId,
    this.onSessionSelected,
  });

  @override
  Widget build(BuildContext context) {
    context.read<SessionListCubit>().loadSessions();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Sessions',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                FirebaseAuth.instance.currentUser!.email!,
                style: const TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
        actions: [
          _themeSwitch(),
          IconButton(
              color: CupertinoColors.destructiveRed,
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(CupertinoIcons.square_arrow_left))
        ],
      ),
      body: BlocBuilder<SessionListCubit, SessionListState>(
        builder: (context, state) {
          if (state is SessionListLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is SessionListError) {
            return const Center(
                child: Text('Something went wrong. Please try again.'));
          } else if (state is SessionListEmpty) {
            return const Center(child: Text('Create a new chat'));
          } else if (state is SessionListLoaded) {
            final sessions = state.sessions;
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return _chatSessionTile(session, context);
              },
              separatorBuilder: (context, index) => const Divider(
                thickness: .5,
                height: .5,
              ),
            );
          } else {
            return const Center(child: Text('unknown error'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSessionDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  //REFACTORED WIDGETS

  ListTile _chatSessionTile(ChatSession session, BuildContext context) {
    return ListTile(
      title: SizedBox(
        height: 60,
        child: Text(
          session.name,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: CupertinoColors.activeBlue,
        size: 15,
      ),
      onTap: () {
        if (onSessionSelected != null) {
          onSessionSelected!(session.id);
        } else {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => BlocProvider<ChatCubit>(
                create: (context) => ChatCubit(session.id),
                child: ChatScreen(
                  sessionId: session.id,
                  userId: userId,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  BlocBuilder<ThemeCubit, bool> _themeSwitch() {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) => IconButton(
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          icon: Icon(
            state ? CupertinoIcons.moon : CupertinoIcons.sun_max,
            color: CupertinoColors.activeBlue,
          )),
    );
  }

  Future<void> _showCreateSessionDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('New session'),
          content: CustomTextFormField(
            labelText: 'Session name',
            controller: controller,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final newSessionName = controller.text.trim();
                if (newSessionName.isNotEmpty) {
                  final sessionId =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  log('session id $sessionId');
                  BlocProvider.of<SessionListCubit>(context)
                      .addSession(sessionId, newSessionName);

                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Create'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                try {
                  Hive.close();
                  context.read<AuthBloc>().add(LogoutEvent());
                  await FirebaseAuth.instance.signOut().then((_) {
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  });
                } on FirebaseAuthException catch (error) {
                  log('FirebaseAuth Exception during logout : $error');
                }
              },
              child: const Text('Logout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
