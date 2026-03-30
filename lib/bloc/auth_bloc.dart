import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String phone;
  final String pin;
  LoginRequested({required this.phone, required this.pin});
  @override
  List<Object?> get props => [phone, pin];
}

class SignUpRequested extends AuthEvent {
  final String phone;
  final String pin;
  SignUpRequested({required this.phone, required this.pin});
  @override
  List<Object?> get props => [phone, pin];
}

class OtpVerified extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthOtpSent extends AuthState {
  final String phone;
  AuthOtpSent({required this.phone});
  @override
  List<Object?> get props => [phone];
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}

class AuthUnauthenticated extends AuthState {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<OtpVerified>(_onOtpVerified);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    if (event.phone.isNotEmpty && event.pin.length >= 4) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthError(message: 'Invalid credentials'));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthOtpSent(phone: event.phone));
  }

  Future<void> _onOtpVerified(
    OtpVerified event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    emit(AuthAuthenticated());
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}
