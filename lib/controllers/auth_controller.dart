import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

abstract class AuthState {
  bool get isLoading;
  bool get isAuthenticated;
  String? get errorMessage;
}

class AuthInitial extends AuthState {
  @override
  bool get isLoading => false;
  @override
  bool get isAuthenticated => false;
  @override
  String? get errorMessage => null;
}

class AuthLoading extends AuthState {
  @override
  bool get isLoading => true;
  @override
  bool get isAuthenticated => false;
  @override
  String? get errorMessage => null;
}

class AuthAuthenticated extends AuthState {
  @override
  bool get isLoading => false;
  @override
  bool get isAuthenticated => true;
  @override
  String? get errorMessage => null;
}

class AuthOtpSent extends AuthState {
  final String phone;
  AuthOtpSent({required this.phone});
  
  @override
  bool get isLoading => false;
  @override
  bool get isAuthenticated => false;
  @override
  String? get errorMessage => null;
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
  
  @override
  bool get isLoading => false;
  @override
  bool get isAuthenticated => false;
  @override
  String? get errorMessage => message;
}

class AuthUnauthenticated extends AuthState {
  @override
  bool get isLoading => false;
  @override
  bool get isAuthenticated => false;
  @override
  String? get errorMessage => null;
}

abstract class AuthEvent {
  const AuthEvent();
}

class LoginRequested extends AuthEvent {
  final String phone;
  final String pin;
  LoginRequested({required this.phone, required this.pin});
}

class SignUpRequested extends AuthEvent {
  final String phone;
  final String pin;
  SignUpRequested({required this.phone, required this.pin});
}

class OtpVerified extends AuthEvent {
  const OtpVerified();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthController extends GetxController {
  final GetStorage _storage = GetStorage();
  
  final authState = Rx<AuthState>(AuthInitial());
  
  final loginPhoneController = TextEditingController();
  final loginPinController = TextEditingController();
  final signupPhoneController = TextEditingController();
  final signupPinController = TextEditingController();
  final signupConfirmPinController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  
  final otpControllers = List.generate(4, (_) => TextEditingController());
  final otpFocusNodes = List.generate(4, (_) => FocusNode());
  
  AuthState get state => authState.value;
  bool get isLoading => authState.value.isLoading;
  bool get isAuthenticated => authState.value.isAuthenticated;
  String? get errorMessage => authState.value.errorMessage;
  
  bool get isOtpComplete => otpControllers.every((c) => c.text.isNotEmpty);
  
  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }
  
  @override
  void onClose() {
    // Dispose controllers
    loginPhoneController.dispose();
    loginPinController.dispose();
    signupPhoneController.dispose();
    signupPinController.dispose();
    signupConfirmPinController.dispose();
    
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in otpFocusNodes) {
      f.dispose();
    }
    super.onClose();
  }
  
  void _checkAuthStatus() {
    final token = _storage.read('auth_token');
    if (token != null) {
      authState.value = AuthAuthenticated();
    }
  }
  
  void add(AuthEvent event) {
    if (event is LoginRequested) {
      _onLoginRequested(event);
    } else if (event is SignUpRequested) {
      _onSignUpRequested(event);
    } else if (event is OtpVerified) {
      _onOtpVerified();
    } else if (event is LogoutRequested) {
      _onLogoutRequested();
    }
  }

  Future<void> _onLoginRequested(LoginRequested event) async {
    authState.value = AuthLoading();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (event.phone.isNotEmpty && event.pin.length >= 4) {
        _storage.write('auth_token', 'dummy_token');
        _storage.write('user_phone', event.phone);
        authState.value = AuthAuthenticated();
        // Navigate to home after successful authentication
        Get.offAllNamed('/home');
      } else {
        authState.value = AuthError(message: 'Invalid credentials');
      }
    } catch (e) {
      authState.value = AuthError(message: 'Login failed: ${e.toString()}');
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event) async {
    authState.value = AuthLoading();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      authState.value = AuthOtpSent(phone: event.phone);
      // Navigate to OTP screen after successful signup
      Get.toNamed('/otp', arguments: {'phone': event.phone});
    } catch (e) {
      authState.value = AuthError(message: 'Sign up failed: ${e.toString()}');
    }
  }

  Future<void> _onOtpVerified() async {
    authState.value = AuthLoading();
    
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _storage.write('auth_token', 'dummy_token');
      authState.value = AuthAuthenticated();
      // Navigate to home after successful OTP verification
      Get.offAllNamed('/home');
    } catch (e) {
      authState.value = AuthError(message: 'OTP verification failed: ${e.toString()}');
    }
  }

  void _onLogoutRequested() {
    _storage.remove('auth_token');
    _storage.remove('user_phone');
    authState.value = AuthUnauthenticated();
    // Navigate to welcome screen after logout
    Get.offAllNamed('/welcome');
  }
  
  // OTP handling
  void onOtpDigitEntered(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
    update(); // Trigger UI update
  }
  
  // Convenience methods
  String? getUserPhone() {
    return _storage.read('user_phone');
  }
  
  // Login method
  void login() {
    if (loginFormKey.currentState!.validate()) {
      add(LoginRequested(
        phone: loginPhoneController.text,
        pin: loginPinController.text,
      ));
    }
  }
  
  // Signup method
  void signup() {
    add(SignUpRequested(
      phone: signupPhoneController.text.isEmpty
          ? '+8801710234761'
          : signupPhoneController.text,
      pin: signupPinController.text,
    ));
  }
  
  // OTP verification method
  void verifyOtp() {
    if (isOtpComplete) {
      add(OtpVerified());
    }
  }
}
