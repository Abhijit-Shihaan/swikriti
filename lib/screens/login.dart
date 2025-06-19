import 'package:flutter/material.dart';
import 'dart:convert';
import 'forgot.dart';
// import '../services/api_service.dart'; // Commented out - not using backend
// import 'package:camera/camera.dart';
import 'welcome.dart'; // Your welcome.dart file

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Hardcoded credentials
  static const String ADMIN_EMAIL = "Admin@gmail.com";
  static const String ADMIN_PASSWORD = "Admin@1234";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() async {
    setState(() {
      _isLoading = true;
    });

    // Show loading for 2 seconds (simulate API call)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Navigate to forgot password page
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ForgotPasswordPage(),
        ),
      );
    }
  }

  // Simplified login method with hardcoded credentials
  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      // Check hardcoded credentials
      if (email == ADMIN_EMAIL && password == ADMIN_PASSWORD) {
        // Login successful
        setState(() {
          _isLoading = false;
        });

        _showSuccessSnackBar('Login successful!');

        if (mounted) {
          // Get available cameras
          //final cameras = await availableCameras();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CoffeeQCApp(),
            ),
          );
        }
      }  else {
        // Login failed
        setState(() {
          _isLoading = false;
        });

        _showErrorSnackBar('Invalid email or password. Please use Admin@gmail.com and Admin@1234');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorSnackBar('Login error: ${e.toString()}');
    }

    /* COMMENTED OUT - BACKEND IMPLEMENTATION
    try {
      print('Starting login process...'); // Debug log

      final response = await ApiService.authUser(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      print('API Response received - Status: ${response.statusCode}'); // Debug log
      print('Raw Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        try {
          // Parse the response
          final responseData = jsonDecode(response.body);
          print('Parsed response data: $responseData'); // Debug log

          // UPDATED: More flexible success checking
          // First check if it's a simple success response
          bool isSuccess = false;

          // Check various success indicators
          if (responseData is Map<String, dynamic>) {
            isSuccess = responseData['success'] == true ||
                responseData['status'] == 'success' ||
                responseData['Status'] == 'success' ||
                responseData.containsKey('token') ||
                responseData.containsKey('user') ||
                responseData.containsKey('data');
          } else if (responseData is String) {
            // If response is just a string, consider it success for status 200
            isSuccess = true;
          } else if (responseData is bool) {
            // If response is boolean
            isSuccess = responseData;
          } else {
            // For other types, assume success if we got status 200
            isSuccess = true;
          }

          if (isSuccess) {
            // Login successful - navigate to welcome page
            _showSuccessSnackBar('Login successful!');

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WelcomePage(email: _emailController.text.trim()),
                ),
              );
            }
          } else {
            // Login failed - show error message from API
            String errorMessage = 'Login failed. Please try again.';

            if (responseData is Map<String, dynamic>) {
              errorMessage = responseData['message'] ??
                  responseData['error'] ??
                  responseData['Error'] ??
                  responseData['Message'] ??
                  'Login failed. Please try again.';
            }

            _showErrorSnackBar(errorMessage);
          }
        } catch (jsonError) {
          print('JSON parsing error: $jsonError'); // Debug log
          print('Response body that failed to parse: ${response.body}'); // Debug log

          // If JSON parsing fails but we got 200, it might be a plain text success response
          if (response.body.toLowerCase().contains('success') ||
              response.body.toLowerCase().contains('true') ||
              response.body.trim() == 'true') {
            _showSuccessSnackBar('Login successful!');
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WelcomePage(email: _emailController.text.trim()),
                ),
              );
            }
          } else {
            _showErrorSnackBar('Invalid response from server. Please try again.');
          }
        }
      } else if (response.statusCode == 401) {
        // Unauthorized - invalid credentials
        _showErrorSnackBar('Invalid email or password. Please try again.');
      } else if (response.statusCode == 400) {
        // Bad request
        try {
          final responseData = jsonDecode(response.body);
          String errorMessage = 'Invalid request. Please check your input.';

          if (responseData is Map<String, dynamic>) {
            errorMessage = responseData['message'] ??
                responseData['error'] ??
                responseData['Error'] ??
                responseData['Message'] ??
                errorMessage;
          }
          _showErrorSnackBar(errorMessage);
        } catch (e) {
          _showErrorSnackBar('Bad request. Please check your input.');
        }
      } else if (response.statusCode == 500) {
        // Server error
        _showErrorSnackBar('Server error. Please try again later.');
      } else {
        // Other errors - show the response body if available
        String errorMessage = 'Unexpected error (${response.statusCode}).';
        try {
          final responseData = jsonDecode(response.body);
          if (responseData is Map<String, dynamic>) {
            errorMessage = responseData['message'] ??
                responseData['error'] ??
                responseData['Error'] ??
                responseData['Message'] ??
                errorMessage;
          }
        } catch (e) {
          // If can't parse JSON, use the raw response body if it's not too long
          if (response.body.length < 100) {
            errorMessage += ' ${response.body}';
          }
        }
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Login error: $e'); // Debug log

      // Better error handling for different types of exceptions
      String errorMessage;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException')) {
        errorMessage = 'No internet connection. Please check your network and try again.';
      } else if (e.toString().contains('TimeoutException') ||
          e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.toString().contains('HandshakeException') ||
          e.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
        errorMessage = 'SSL/Certificate error. Please check your connection.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Invalid server response. Please try again.';
      } else {
        errorMessage = 'Network error: ${e.toString()}';
      }

      _showErrorSnackBar(errorMessage);
    }
    */ // END OF COMMENTED BACKEND CODE
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 1024;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Key change: Set this to false to prevent screen resizing
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  // Remove keyboard-based padding since we're using overlay approach
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                    vertical: 16,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32,
                      maxWidth: isDesktop ? 400 : (isTablet ? 500 : double.infinity),
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo Section
                            Container(
                              height: isDesktop ? 100 : (isTablet ? 90 : 70),
                              margin: EdgeInsets.only(
                                bottom: isDesktop ? 32 : (isTablet ? 24 : 16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: isDesktop ? 70 : (isTablet ? 60 : 50),
                                    height: isDesktop ? 70 : (isTablet ? 60 : 50),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[600],
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'S',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isDesktop ? 32 : (isTablet ? 28 : 24),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'SWIKRITI',
                                    style: TextStyle(
                                      color: Colors.orange[600],
                                      fontSize: isDesktop ? 14 : (isTablet ? 12 : 10),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Welcome Text
                            Text(
                              'Welcome Back!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isDesktop ? 28 : (isTablet ? 24 : 20),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Login to your account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isDesktop ? 16 : (isTablet ? 14 : 12),
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Added hint for demo credentials

                            SizedBox(height: isDesktop ? 32 : (isTablet ? 24 : 16)),

                            // Email Field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email Address',
                                  style: TextStyle(
                                    fontSize: isDesktop ? 14 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  enabled: !_isLoading, // Disable when loading
                                  decoration: InputDecoration(
                                    hintText: 'Enter Email Address',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: isDesktop ? 14 : 12,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Colors.grey[400],
                                      size: isDesktop ? 20 : 18,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.orange[600]!),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: isDesktop ? 16 : 14,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: isDesktop ? 14 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  enabled: !_isLoading, // Disable when loading
                                  decoration: InputDecoration(
                                    hintText: 'Enter Password',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: isDesktop ? 14 : 12,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.grey[400],
                                      size: isDesktop ? 20 : 18,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: _isLoading ? null : () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.grey[400],
                                        size: isDesktop ? 20 : 18,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.orange[600]!),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: isDesktop ? 16 : 14,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: isDesktop ? 24 : (isTablet ? 20 : 16)),

                            // Login Button - Updated to call hardcoded login
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown[700],
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: Colors.brown.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: isDesktop ? 16 : 14,
                                ),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : Text(
                                'Login Here',
                                style: TextStyle(
                                  fontSize: isDesktop ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: isDesktop ? 16 : (isTablet ? 14 : 12)),

                            // Forgot Password
                            Center(
                              child: TextButton(
                                onPressed: _isLoading ? null : _handleForgotPassword,
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: _isLoading ? Colors.grey[400] : Colors.grey[600],
                                    fontSize: isDesktop ? 14 : 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isDesktop ? 24 : (isTablet ? 16 : 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Full Screen Loader
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Main app to run the login page
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swikriti Login',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(const MyApp());
}