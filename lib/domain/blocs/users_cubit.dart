import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_example/domain/data_providers/user_data_provider.dart';
import 'package:mvvm_example/domain/entity/user.dart';
import 'package:mvvm_example/domain/repository/auth_repository.dart';
import 'package:mvvm_example/ui/navigation/main_navigation.dart';

class UsersState {
  final User currentUser;

  UsersState({
    required this.currentUser,
  });

  UsersState copyWith({
    User? currentUser,
  }) {
    return UsersState(
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  String toString() => 'UsersState(currentUser: $currentUser)';

  @override
  bool operator ==(covariant UsersState other) {
    if (identical(this, other)) return true;

    return other.currentUser == currentUser;
  }

  @override
  int get hashCode => currentUser.hashCode;
}

class UsersCubit extends Cubit<UsersState> {
  final _authRepository = AuthRepository();
  final _userDataProvider = UserDataProvider();

  UsersCubit() : super(UsersState(currentUser: User(0))) {
    _initialize();
  }

  Future<void> _initialize() async {
    final user = await _userDataProvider.loadValue();
    final newState = state.copyWith(currentUser: user);
    emit(newState);
  }

  void incrementAge() {
    var user = state.currentUser;
    user = user.copyWith(age: user.age + 1);
    final newState = state.copyWith(currentUser: user);
    emit(newState);
    _userDataProvider.saveValue(user);
  }

  void decrementAge() {
    var user = state.currentUser;
    user = user.copyWith(age: max(user.age - 1, 0));
    emit(state.copyWith(currentUser: user));
    _userDataProvider.saveValue(user);
  }

  void onLogoutPressed(BuildContext context) async {
    await _authRepository
        .logout()
        .then((value) => MainNavigation.showLoader(context));
  }
}
