import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/assets.dart';
import 'package:food_delivery_app/presentation/pages/home_screen.dart';
import 'package:food_delivery_app/presentation/widgets/custom_button.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObsecure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(46, 16, 46, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                Row(children: [Image.asset(Assets.loginImage)]),
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
                      GestureDetector(
                        onTap: () => _forgotPassword(),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CustomText(
                            title: "Forgot Password?",
                            fcolor: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: "Login",
                              onPressed: () {},
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
                              onPressed: () {},
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
                                  builder: (context) => const HomeScreen(),
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

  void _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        // _errorMessage = "Please enter your email to reset password";
      });
      return;
    }

    try {
      // await _authService.sendPasswordResetEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent to $email')),
        );
      }
    } catch (e) {
      setState(() {
        // _errorMessage = e.toString();
      });
    }
  }
}
