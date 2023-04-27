import 'package:flutter/material.dart';
import 'package:mvvm_example/domain/blocs/users_cubit.dart';
import 'package:mvvm_example/domain/repository/auth_repository.dart';
import 'package:mvvm_example/ui/navigation/main_navigation.dart';
import 'package:mvvm_example/ui/widget/nav_bar_widget.dart';
import 'package:provider/provider.dart';

// class _ViewModelState {
//   final String ageTitle;
//   _ViewModelState({
//     required this.ageTitle,
//   });
// }

// class _ViewModel extends ChangeNotifier {
//   final _userRepository = UserRepository();
//   final _authRepository = AuthRepository();

//   var _state = _ViewModelState(ageTitle: '');
//   _ViewModelState get state => _state;

//   _ViewModel() {
//     _userRepository.initialize().then((_) {
//       _updateState();
//     });
//   }

//   Future<void> onIncrementButtonPressed() async {
//     _userRepository.incrementAge();
//     _updateState();
//   }

//   Future<void> onDecrementButtonPressed() async {
//     _userRepository.decrementAge();
//     _updateState();
//   }

//   Future<void> onLogoutPressed(BuildContext context) async {
//     await _authRepository.logout();
//     MainNavigation.showLoader(context);
//   }

//   void _updateState() {
//     final user = _userRepository.user;

//     _state = _ViewModelState(ageTitle: user.age.toString());
//     notifyListeners();
//   }
// }

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  static Widget create() {
    return Provider<UsersCubit>(
      create: (_) => UsersCubit(),
      child: const ExampleWidget(),
      dispose: (context, value) {
        value.close();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () => {cubit.onLogoutPressed(context)},
              child: const Text('Выход')),
        ],
      ),
      drawer: const NavBarWidget(),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _AgeTitle(),
            _AgeIncrementWidget(),
            _AgeDecrementWidget(),
          ],
        ),
      )),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();
    return StreamBuilder(
        initialData: cubit.state,
        stream: cubit.stream,
        builder: (context, snapshot) {
          final age = snapshot.requireData.currentUser.age;
          return Text('$age');
        });
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();
    return ElevatedButton(
        onPressed: () => cubit.incrementAge(), child: const Text('+'));
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();

    return ElevatedButton(
        onPressed: () => cubit.decrementAge(), child: const Text('-'));
  }
}
