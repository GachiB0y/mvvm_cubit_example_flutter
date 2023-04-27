
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_example/domain/data_providers/auth_api_provider.dart';

import 'package:mvvm_example/domain/repository/auth_repository.dart';
import 'package:mvvm_example/ui/navigation/main_navigation.dart';

enum ViewModelAuthButtonState { canSubmit, authProcces, disable }

class AuthState {
  String authErrorTitle = '';
  String login = '';
  String password = '';
  bool isAuthInProcess = false;
  ViewModelAuthButtonState get authButtonState {
    if (isAuthInProcess) {
      return ViewModelAuthButtonState.authProcces;
    } else if (login.isNotEmpty && password.isNotEmpty) {
      return ViewModelAuthButtonState.canSubmit;
    } else {
      return ViewModelAuthButtonState.disable;
    }
  }

  AuthState({
    required this.authErrorTitle,
    required this.login,
    required this.password,
    required this.isAuthInProcess,
  });

  AuthState copyWith({
    String? authErrorTitle,
    String? login,
    String? password,
    bool? isAuthInProcess,
  }) {
    return AuthState(
      authErrorTitle: authErrorTitle ?? this.authErrorTitle,
      login: login ?? this.login,
      password: password ?? this.password,
      isAuthInProcess: isAuthInProcess ?? this.isAuthInProcess,
    );
  }

  @override
  String toString() {
    return 'AuthState(authErrorTitle: $authErrorTitle, login: $login, password: $password, isAuthInProcess: $isAuthInProcess)';
  }

  @override
  bool operator ==(covariant AuthState other) {
    if (identical(this, other)) return true;

    return other.authErrorTitle == authErrorTitle &&
        other.login == login &&
        other.password == password &&
        other.isAuthInProcess == isAuthInProcess;
  }

  @override
  int get hashCode {
    return authErrorTitle.hashCode ^
        login.hashCode ^
        password.hashCode ^
        isAuthInProcess.hashCode;
  }
}

class AuthCubit extends Cubit<AuthState> {
  final _authRepository = AuthRepository();

  AuthCubit()
      : super(AuthState(
            authErrorTitle: '',
            login: '',
            password: '',
            isAuthInProcess: false));

  void changeLogin(String value) {
    if (state.login == value) return;
    emit(state.copyWith(login: value));
    print('New login: "${state.login}"');
  }

  void changePassword(String value) {
    if (state.password == value) return;
    emit(state.copyWith(password: value));
    print('New pass: "${state.password}"');
  }

  Future<void> onAuthButtonPressed(BuildContext context) async {
    final login = state.login;
    final password = state.password;
    print('New isAuthInProcess: "${state.isAuthInProcess}"');
    print('New login: "${state.login}"');
    print('New password: "${state.password}"');
    if (login.isEmpty || password.isEmpty) return;

    // state.authErrorTitle = '';
    // state.isAuthInProcess = true;
    emit(state.copyWith(authErrorTitle: '', isAuthInProcess: true));
    print('New isAuthInProcess: "${state.isAuthInProcess}"');
    try {
      await _authRepository.login(login, password);
      // state.isAuthInProcess = false;
      emit(state.copyWith(isAuthInProcess: false));
      MainNavigation.showExample(context);
    } on AuthProviderIncorectLoginDataError {
      emit(state.copyWith(
          authErrorTitle: 'Неправильный логин или пароль!',
          isAuthInProcess: false));
    } catch (e) {
      emit(state.copyWith(
          authErrorTitle: 'Неизвестная ошибка, попробуйте позже',
          isAuthInProcess: false));
    }
  }
}
