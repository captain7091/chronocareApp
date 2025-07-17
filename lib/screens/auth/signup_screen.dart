import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../health_info/health_info_screen.dart';
import 'package:provider/provider.dart';
import 'package:chronocare_app/providers/auth_provider.dart' as my_auth;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final fullName = _fullNameController.text.trim();
    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please fill all fields.';
      });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // Optionally, update display name
      await FirebaseAuth.instance.currentUser?.updateDisplayName(fullName);
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (mounted) {
        Provider.of<my_auth.AuthProvider>(context, listen: false).setUser(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!'), backgroundColor: Colors.green, duration: Duration(milliseconds: 1500)),
        );
        await Future.delayed(const Duration(milliseconds: 1500));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HealthInfoScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Registration failed. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
                      children: [
                        TextSpan(text: 'Chrono', style: TextStyle(color: Color(0xFF1ED760))),
                        TextSpan(text: 'Care', style: TextStyle(color: Color(0xFF0A4DA2))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Create Your Account',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Please enter your details to Sign Up',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Email Address', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Password', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeTerms,
                      onChanged: (val) {
                        setState(() {
                          _agreeTerms = val ?? false;
                        });
                      },
                      activeColor: const Color(0xFF1ED760),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 13, color: Colors.black54),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: const TextStyle(color: Color(0xFF1ED760)),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(color: Color(0xFF1ED760)),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _agreeTerms && !_isLoading
                        ? _register
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A4DA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: Colors.black54)),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Login', style: TextStyle(color: Color(0xFF0A4DA2), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 