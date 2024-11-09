import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tugas1_ui/pages/dashboard.dart';
import 'package:tugas1_ui/pages/register.dart';
import 'package:tugas1_ui/api/service.dart';
import 'package:tugas1_ui/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logging/logging.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _isSchoolIconHovered = false;
  bool _isUsernameIconHovered = false;
  bool _isPasswordIconHovered = false;
  bool _isLoginButtonHovered = false;
  bool _isRememberMeChecked = false;
  String _errorMessage = '';

  late final OdooConnection _odoo;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  final _logger = Logger('LoginPage');

  @override
  void initState() {
    super.initState();
    _odoo = OdooConnection(url: dotenv.env['URL']!);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();

    _loadRememberMeState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberMeState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _usernameController.text = prefs.getString('username') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveRememberMeState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', _rememberMe);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final dbName = dotenv.env['DB']!;
      final user = _usernameController.text.trim();
      final pass = _passwordController.text.trim();

      if (user.isEmpty || pass.isEmpty) {
        setState(() {
          _errorMessage = 'Please fill in all fields';
        });
        return;
      }

      final session = await _odoo.auth(dbName, user, pass);
      if (session != null) {
        if (_rememberMe) {
          await _saveRememberMeState();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(
              targetPage: Dashboard(),
              message: "Logging in ...",
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password.';
        });
        _logger.warning('Login failed: Invalid username or password');
      }
    } catch (e, stackTrace) {
      _logger.severe('Login error:', e, stackTrace);
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _googleSignIn() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(
              targetPage: Dashboard(),
              message: "Logging in ...",
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      _logger.severe('Google sign-in error:', e, stackTrace);
      setState(() {
        _errorMessage = 'Error signing in with Google.';
      });
    }
  }

  Future<void> _facebookSignIn() async {
    try {
      final facebookAuth = FacebookAuth.instance;
      final facebookLoginResult = await facebookAuth.login();
      if (facebookLoginResult.status == LoginStatus.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(
              targetPage: Dashboard(),
              message: "Logging in ...",
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      _logger.severe('Facebook sign-in error:', e, stackTrace);
      setState(() {
        _errorMessage = 'Error signing in with Facebook.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6200EE),
                    Color(0xFF3700B3),
                    Color(0xFF01579B),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // App Logo
                    MouseRegion(
                      onEnter: (_) =>
                          setState(() => _isSchoolIconHovered = true),
                      onExit: (_) =>
                          setState(() => _isSchoolIconHovered = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..scale(_isSchoolIconHovered ? 1.1 : 1.0)
                          ..translate(
                            _isSchoolIconHovered ? -4.0 : 0.0,
                            _isSchoolIconHovered ? -4.0 : 0.0,
                          ),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Icon(
                            Icons.school,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Welcome Text
                    SlideTransition(
                      position: _slideAnimation,
                      child: const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SlideTransition(
                      position: _slideAnimation,
                      child: const Text(
                        "Sign in to continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Username Field
                    // Username Field
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: MouseRegion(
                        onEnter: (_) =>
                            setState(() => _isUsernameIconHovered = true),
                        onExit: (_) =>
                            setState(() => _isUsernameIconHovered = false),
                        child: TextField(
                          controller: _usernameController,
                          style: const TextStyle(
                            color: Colors.white, // Warna teks yang diinputkan
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: const TextStyle(
                                color: Colors.white70), // Warna teks label
                            prefixIcon: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.identity()
                                ..scale(_isUsernameIconHovered ? 1.2 : 1.0)
                                ..translate(
                                  _isUsernameIconHovered ? -2.0 : 0.0,
                                  _isUsernameIconHovered ? -2.0 : 0.0,
                                ),
                              child:
                                  const Icon(Icons.person, color: Colors.white),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2),
                            ),
                            errorText:
                                _errorMessage.isNotEmpty ? _errorMessage : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    // Password Field
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: MouseRegion(
                        onEnter: (_) =>
                            setState(() => _isPasswordIconHovered = true),
                        onExit: (_) =>
                            setState(() => _isPasswordIconHovered = false),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          style: const TextStyle(
                            color: Colors.white, // Warna teks yang diinputkan
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                color: Colors.white70), // Warna teks label
                            prefixIcon: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.identity()
                                ..scale(_isPasswordIconHovered ? 1.2 : 1.0)
                                ..translate(
                                  _isPasswordIconHovered ? -2.0 : 0.0,
                                  _isPasswordIconHovered ? -2.0 : 0.0,
                                ),
                              child:
                                  const Icon(Icons.lock, color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2),
                            ),
                            errorText:
                                _errorMessage.isNotEmpty ? _errorMessage : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Remember Me Checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.2, // Mengubah ukuran checkbox
                          child: Checkbox(
                            value: _isRememberMeChecked,
                            activeColor: Colors
                                .white, // Warna kotak centang saat diaktifkan
                            checkColor: Colors.black, // Warna centang
                            side: const BorderSide(
                                color: Colors.white,
                                width: 2), // Border saat tidak tercentang
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4), // Kotak dengan sudut membulat
                            ),
                            onChanged: (bool? value) {
                              setState(() {
                                _isRememberMeChecked = value ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                            width: 8), // Spasi antara checkbox dan teks
                        const Text(
                          "Remember Me",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Login Button
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: MouseRegion(
                        onEnter: (_) =>
                            setState(() => _isLoginButtonHovered = true),
                        onExit: (_) =>
                            setState(() => _isLoginButtonHovered = false),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.deepPurple)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        transform: Matrix4.identity()
                                          ..scale(
                                              _isLoginButtonHovered ? 1.2 : 1.0)
                                          ..translate(
                                            _isLoginButtonHovered ? -2.0 : 0.0,
                                            _isLoginButtonHovered ? -2.0 : 0.0,
                                          ),
                                        child: const Icon(Icons.login,
                                            color: Colors.deepPurple),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Social Login Options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _googleSignIn,
                          icon: const Icon(Icons.g_mobiledata,
                              color: Colors.white),
                          label: const Text(
                            'Sign in with Google',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _facebookSignIn,
                          icon: const Icon(Icons.facebook, color: Colors.white),
                          label: const Text(
                            'Sign in with Facebook',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B5998),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    // Register Section
                    SlideTransition(
                      position: _slideAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
