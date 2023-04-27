import 'package:flutter/material.dart';
import 'package:mvvm_example/domain/blocs/auth_cubit.dart';
import 'package:mvvm_example/ui/navigation/main_navigation.dart';
import 'package:provider/provider.dart';

import 'package:mvvm_example/domain/data_providers/auth_api_provider.dart';
import 'package:mvvm_example/domain/repository/auth_repository.dart';

// enum _ViewModelAuthButtonState { canSubmit, authProcces, disable }

// class _ViewModelState {
//   String authErrorTitle = '';
//   String login = '';
//   String password = '';
//   bool isAuthInProcess = false;
//   _ViewModelAuthButtonState get authButtonState {
//     if (isAuthInProcess) {
//       return _ViewModelAuthButtonState.authProcces;
//     } else if (login.isNotEmpty && password.isNotEmpty) {
//       return _ViewModelAuthButtonState.canSubmit;
//     } else {
//       return _ViewModelAuthButtonState.disable;
//     }
//   }

//   _ViewModelState();
// }

// class _ViewModel extends ChangeNotifier {
//   final _authRepository = AuthRepository();
//   final _state = _ViewModelState();
//   _ViewModelState get state => _state;

//   void changeLogin(String value) {
//     if (_state.login == value) return;

//     _state.login = value;
//     notifyListeners();
//   }

//   void changePassword(String value) {
//     if (_state.password == value) return;
//     _state.password = value;
//     notifyListeners();
//   }

//   Future<void> onAuthButtonPressed(BuildContext context) async {
//     final login = _state.login;
//     final password = _state.password;

//     if (login.isEmpty || password.isEmpty) return;

//     _state.authErrorTitle = '';
//     _state.isAuthInProcess = true;
//     notifyListeners();

//     try {
//       await _authRepository.login(login, password);
//       _state.isAuthInProcess = false;
//       notifyListeners();
//       MainNavigation.showExample(context);
//     } on AuthProviderIncorectLoginDataError {
//       _state.authErrorTitle = 'Неправильный логин или пароль!';
//       _state.isAuthInProcess = false;
//       notifyListeners();
//     } catch (e) {
//       _state.authErrorTitle = 'Неизвестная ошибка, попробуйте позже';

//       _state.isAuthInProcess = false;
//       notifyListeners();
//     }
//   }
// }

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  static Widget create() {
    return Provider<AuthCubit>(
      create: (_) => AuthCubit(),
      child: const AuthWidget(),
      // dispose: (context, value) => value.close(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _ErrorTitleWidget(),
              SizedBox(
                height: 5,
              ),
              _LoginWidget(),
              SizedBox(
                height: 10,
              ),
              _PasswordWidget(),
              SizedBox(
                height: 10,
              ),
              AuthButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginWidget extends StatelessWidget {
  const _LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return TextField(
      decoration: const InputDecoration(
          labelText: 'Логин', border: OutlineInputBorder()),
      onChanged: cubit.changeLogin,
    );
  }
}

class _PasswordWidget extends StatelessWidget {
  const _PasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return TextField(
      decoration: const InputDecoration(
          labelText: 'Пароль', border: OutlineInputBorder()),
      onChanged: cubit.changePassword,
    );
  }
}

class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final authErrorTitle = cubit.state.authErrorTitle;
    return StreamBuilder(
        initialData: cubit.state,
        stream: cubit.stream,
        builder: (context, snapshot) {
          final authErrorTitle = snapshot.requireData.authErrorTitle;
          return Text(
            authErrorTitle,
            style: const TextStyle(color: Colors.red),
          );
        });
  }
}

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return StreamBuilder(
        initialData: cubit.state,
        stream: cubit.stream,
        builder: (context, snapshot) {
          final authButtonState = snapshot.requireData.authButtonState;
          final onPressed =
              authButtonState == ViewModelAuthButtonState.canSubmit
                  ? cubit.onAuthButtonPressed
                  : null;
          final child = authButtonState == ViewModelAuthButtonState.authProcces
              ? const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator())
              : const Text('Авторизация');
          return ElevatedButton(
            onPressed: () {
              onPressed?.call(context);
              print('authGOO');
            },
            child: child,
          );
        });
  }
}
