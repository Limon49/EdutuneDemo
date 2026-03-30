import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

// ─── Welcome Screen ──────────────────────────────────────────────────────────
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/onboarding'),
                  ),
                  const Spacer(),
                  const LanguageBadge(),
                ],
              ),
              const SizedBox(height: 24),
              // Illustration
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildWelcomeIllustration(),
                    const SizedBox(height: 40),
                    Text(
                      'Create Your Epay\nAccount',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                text: 'Sign Up',
                onPressed: () => Navigator.pushNamed(context, '/signup'),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Log In',
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
              const SizedBox(height: 16),
              const BottomIssueBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeIllustration() {
    return SizedBox(
      height: 220,
      width: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
          ),
          // Phone with person icon
          Container(
            width: 90,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  ),
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 24),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  ),
                  child: const Icon(Icons.work, color: Colors.white, size: 12),
                ),
              ],
            ),
          ),
          // Colored dots
          Positioned(
              top: 30, left: 10,
              child: _dot(Colors.teal, 14)),
          Positioned(
              top: 20, right: 30,
              child: _dot(Colors.pink, 22)),
          Positioned(
              bottom: 40, left: 20,
              child: _dot(AppColors.accent, 20)),
          Positioned(
              bottom: 50, right: 10,
              child: _dot(Colors.blue, 14)),
          Positioned(
              top: 45, right: 5,
              child: _dot(AppColors.primary, 10)),
        ],
      ),
    );
  }

  Widget _dot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ─── Login Screen ─────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          const LanguageBadge(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Log in Epay',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      InputField(
                        label: 'Phone Number',
                        hint: '01701*****4',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        label: 'Enter 6 Digit PIN',
                        hint: '123456',
                        isPassword: true,
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot PIN ?',
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: 'Log In',
                        isLoading: isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(LoginRequested(
                                  phone: _phoneController.text,
                                  pin: _pinController.text,
                                ));
                          }
                        },
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Icon(
                          Icons.fingerprint,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: GoogleFonts.poppins(
                                  color: AppColors.textSecondary),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/signup'),
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      const BottomIssueBar(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Sign Up Screen ────────────────────────────────────────────────────────────
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent) {
          Navigator.pushNamed(context, '/otp',
              arguments: {'phone': state.phone});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          const LanguageBadge(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create an account',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      InputField(
                        label: 'Phone Number',
                        hint: '+8801701*****4',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        label: 'Enter 4 Digit PIN',
                        hint: '123456',
                        isPassword: true,
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        label: 'Re-Enter PIN',
                        hint: '123456',
                        isPassword: true,
                        controller: _confirmPinController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        text: 'Sign Up',
                        isLoading: isLoading,
                        onPressed: () {
                          context.read<AuthBloc>().add(SignUpRequested(
                                phone: _phoneController.text.isEmpty
                                    ? '+8801710234761'
                                    : _phoneController.text,
                                pin: _pinController.text,
                              ));
                        },
                      ),
                      const SizedBox(height: 40),
                      const BottomIssueBar(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── OTP Screen ───────────────────────────────────────────────────────────────
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  bool get _isComplete =>
      _controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final phone = args?['phone'] ?? '+8801710234761';

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        const LanguageBadge(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Confirm your Phone',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We send 4 digit of code to $phone',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // OTP boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (i) => _OtpBox(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          onChanged: (v) => _onDigitEntered(i, v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't get the code? ",
                            style: GoogleFonts.poppins(
                                color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Resend',
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: 'Verify Your Phone',
                      isLoading: isLoading,
                      isEnabled: _isComplete,
                      onPressed: _isComplete
                          ? () => context.read<AuthBloc>().add(OtpVerified())
                          : null,
                    ),
                    const SizedBox(height: 16),
                    const BottomIssueBar(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.langBadge,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
