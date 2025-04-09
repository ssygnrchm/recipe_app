import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/authentication/presentation/pages/login_screen.dart';
import 'package:food_delivery_app/features/authentication/service/firebase_auth_service.dart';
import 'package:food_delivery_app/core/constants/assets.dart';
import 'package:food_delivery_app/presentation/pages/home_screen.dart';
import 'package:food_delivery_app/presentation/widgets/custom_button.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isObsecure = true;
  // Loading state
  bool _isLoading = false;
  // Error message
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(46, 16, 46, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                Row(children: [Image.asset(Assets.registerImage)]),
                CustomText(
                  title: "Let's get you in!",
                  style: theme.textTheme.displayMedium,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      CustomText(title: "Email"),
                      loginTextField(
                        "email@mail.com",
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                      // Password
                      CustomText(title: "Password"),
                      loginTextField(
                        "Enter your password",
                        controller: _passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      CustomText(title: "Comfirm Password"),
                      loginTextField(
                        "Enter your password",
                        controller: _passwordConfirmationController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value != _passwordController.text) {
                            return "Password tidak sama!";
                          }
                          return null;
                        },
                      ),
                      // Display error message if any
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: "Register",
                              onPressed: !_isLoading ? _register : null,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CustomText(title: "Or Sign Up With"),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonIcon: Image.asset(
                                "assets/images/iconGoogle.png",
                                height: 24,
                              ),
                              title: "Google",
                              onPressed: _googleLogin,
                              isSecondary: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(title: "Have an account?"),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: CustomText(
                              title: "Sign In",
                              fcolor: theme.colorScheme.primary,
                              fweight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginTextField(
    String? hinttext, {
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscuringCharacter: "•",
      obscureText: isPassword ? _isObsecure : false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        isDense: true,
        hintText: hinttext,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon:
            isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObsecure = !_isObsecure;
                    });
                  },
                  icon: Icon(
                    _isObsecure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                    size: 24,
                  ),
                )
                : null,
      ),
      validator: validator,
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final user = await _authService.registerWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (user != null) {
          // Navigate to home screen
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _googleLogin() async {
    try {
      final user = await _authService.signInwithGoogle();
      if (user != null) {
        // Navigate to home screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
}
