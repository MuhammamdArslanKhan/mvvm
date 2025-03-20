import 'package:bloc/bloc.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login_usecase.dart';

/*
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});
}


abstract class LoginState {}


class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess({required this.user});
}


class LoginFailure extends LoginState {
  final Failure failure;

  LoginFailure({required this.failure});
}


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final user = await loginUseCase(event.email, event.password);
        yield LoginSuccess(user: user);
      } on Failure catch (failure) {
        yield LoginFailure(failure: failure);
      } catch (e) {
        yield LoginFailure(failure: ServerFailure('An unexpected error occurred.'));
      }
    }
  }
}
*/



abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess({required this.user});
}

class LoginFailure extends LoginState {
  final Failure failure;

  LoginFailure({required this.failure});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed); // Register the event handler
  }

  Future<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await loginUseCase("u2@gmail.com", "1111111#");
      emit(LoginSuccess(user: user));
    } on Failure catch (failure) {
      emit(LoginFailure(failure: failure));
    } catch (e) {
      emit(LoginFailure(failure: ServerFailure('An unexpected error occurred.')));
    }
  }
}