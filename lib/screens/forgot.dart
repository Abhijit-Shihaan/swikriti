import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleBackToLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Show loading for 1.5 seconds
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
    });

    // Navigate back to login page
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handlePasswordReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password reset instructions sent to your email'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 1024;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 24),
                    child: InkWell(
                      onTap: _isLoading ? null : _handleBackToLogin,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: _isLoading ? Colors.grey[400] : Colors.grey[700],
                          size: isDesktop ? 24 : 20,
                        ),
                      ),
                    ),
                  ),

                  // Title and Description
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isDesktop ? 400 : (isTablet ? 500 : double.infinity),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                'Forgot Password',
                                style: TextStyle(
                                  fontSize: isDesktop ? 32 : (isTablet ? 28 : 24),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: isDesktop ? 16 : 12),

                              // Description
                              Text(
                                'Enter your registered email. Our admin team will contact you with reset instructions.',
                                style: TextStyle(
                                  fontSize: isDesktop ? 16 : (isTablet ? 14 : 13),
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: isDesktop ? 40 : (isTablet ? 32 : 28)),

                              // Email Address Label
                              Text(
                                'Email Address',
                                style: TextStyle(
                                  fontSize: isDesktop ? 14 : 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Email Input Field
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'nikhil@gmail.com',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: isDesktop ? 14 : 13,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.grey[400],
                                    size: isDesktop ? 20 : 18,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: const BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: const BorderSide(color: Colors.red, width: 2),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: isDesktop ? 18 : 16,
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
                              SizedBox(height: isDesktop ? 32 : (isTablet ? 28 : 24)),

                              // Request Password Reset Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handlePasswordReset,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.brown[700],
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.brown.withOpacity(0.3),
                                    disabledBackgroundColor: Colors.grey[400],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: isDesktop ? 18 : 16,
                                    ),
                                  ),
                                  child: Text(
                                    'Request Password Reset',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: isDesktop ? 24 : (isTablet ? 20 : 16)),

                              // Back to Login Page Link
                              Center(
                                child: TextButton(
                                  onPressed: _isLoading ? null : _handleBackToLogin,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        size: isDesktop ? 16 : 14,
                                        color: _isLoading ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Back to Login page',
                                        style: TextStyle(
                                          color: _isLoading ? Colors.grey[400] : Colors.grey[600],
                                          fontSize: isDesktop ? 14 : 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Full Screen Loader
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}