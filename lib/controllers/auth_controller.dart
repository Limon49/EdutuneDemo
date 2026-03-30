import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Auth States (keeping same structure for UI compatibility)
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

// Auth Events (keeping same structure for UI compatibility)
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

// Pure GetX AuthController
class AuthController extends GetxController {
  final GetStorage _storage = GetStorage();
  
  // Reactive state
  final authState = Rx<AuthState>(AuthInitial());
  
  // Getters for current state
  AuthState get state => authState.value;
  bool get isLoading => authState.value.isLoading;
  bool get isAuthenticated => authState.value.isAuthenticated;
  String? get errorMessage => authState.value.errorMessage;
  
  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }
  
  void _checkAuthStatus() {
    final token = _storage.read('auth_token');
    if (token != null) {
      authState.value = AuthAuthenticated();
    }
  }
  
  // BLoC-like add method for UI compatibility
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
  
  // Convenience methods
  String? getUserPhone() {
    return _storage.read('user_phone');
  }
}
