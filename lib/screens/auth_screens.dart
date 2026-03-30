import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';
import '../utils/app_assets.dart';
import '../routes/app_routes.dart';
import '../widgets/common_widgets.dart';

//todo welcome screen
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
                        AppRoutes.navigateAndReplace(AppRoutes.onboarding),
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
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                text: 'Sign Up',
                onPressed: () => AppRoutes.navigateTo(AppRoutes.signup),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Log In',
                onPressed: () => AppRoutes.navigateTo(AppRoutes.login),
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
    return Container(
      width: 280,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          AppAssets.signup,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

//todo login screen
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
    return GetX<AuthController>(
      builder: (controller) {
        if (controller.state is AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppRoutes.navigateAndClearStack(AppRoutes.home);
          });
        } else if (controller.state is AuthError) {
          final errorState = controller.state as AuthError;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorState.message),
                backgroundColor: AppColors.error,
              ),
            );
          });
        }
            final isLoading = controller.state is AuthLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
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
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot PIN ?',
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
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
                          controller.add(LoginRequested(
                                phone: _phoneController.text,
                                pin: _pinController.text,
                              ));
                        }
                      },
                    ),
                      const SizedBox(height: 32),
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            AppAssets.fingerprint,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.fingerprint,
                                size: 40,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        ),
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
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                                color: AppColors.black400),
                          ),
                          GestureDetector(
                            onTap: () =>
                                AppRoutes.navigateTo(AppRoutes.signup),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                     SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                    const BottomIssueBar(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
    return GetX<AuthController>(
      builder: (controller) {
        // Handle OTP navigation
        if (controller.state is AuthOtpSent) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppRoutes.navigateTo(AppRoutes.otp, arguments: {'phone': (controller.state as AuthOtpSent).phone});
          });
        }
        final isLoading = controller.state is AuthLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                      PrimaryButton(
                        text: 'Sign Up',
                        isLoading: isLoading,
                        onPressed: () {
                          controller.add(SignUpRequested(
                                phone: _phoneController.text.isEmpty
                                    ? '+8801710234761'
                                    : _phoneController.text,
                                pin: _pinController.text,
                              ));
                        },
                      ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                      const BottomIssueBar(),
                    ],
                  ),
                ),
              ),
            ),
        );
      },
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

    return GetX<AuthController>(
      builder: (controller) {
        // Handle authentication success
        if (controller.state is AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppRoutes.navigateAndClearStack(AppRoutes.home);
          });
        }
        final isLoading = controller.state is AuthLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
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
                          ? () => controller.add(OtpVerified())
                          : null,
                    ),
                    const SizedBox(height: 16),
                    const BottomIssueBar(),
                  ],
                ),
              ),
            ),
        );
      },
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
