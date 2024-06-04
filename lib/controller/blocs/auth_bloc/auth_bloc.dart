import 'package:chat_app_ayna/controller/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<AppStartEvent>(_appStartEvent);
  }

  void _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    log('in _onSignUpRequested');
    emit(AuthLoading());
    log('loading emitted');
    try {
      final user = await authRepository.signUp(
          email: event.email, password: event.password);
      if (user != null) {
        await Hive.openBox('user_${user.uid}_sessions');
        emit(Authenticated(user: user));
      } else {
        emit(AuthError(message: 'Sign Up Failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(
          email: event.email, password: event.password);
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(AuthError(message: 'Login Failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _appStartEvent(AppStartEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    log('in app start');
    final user = await AuthRepository().checkForActiveUser();
    if (user != null && user is User) {
      log('user found ${user.email}');
      emit(Authenticated(user: user));
    } else {
      log('no user found');
      emit(Unauthenticated());
    }
  }
}
