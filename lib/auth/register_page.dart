import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';
import 'auth_service.dart';

class RegisterPage extends StatelessWidget {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService(); // TO DO why use _ start of the variable name?

  void _register(BuildContext context) async {
    try {
      await _auth.signUp(_email.text, _password.text);
      if (context.mounted) context.go(Uri.parse('/').toString());
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Register failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth:
                      constraints.maxWidth >= 600 ? 500 : double.infinity),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_pin_sharp,
                      size: 80, color: Theme.of(context).primaryColor),
                  SizedBox(height: 16),
                  Text(
                    'Create an Account',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),

                  // Email
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Password
                  TextField(
                    controller: _password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _register(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Signup Link
                  Link(
                      uri: Uri.parse('/signin'),
                      builder: (BuildContext context, FollowLink? followLink) =>
                          TextButton(
                            onPressed: followLink,
                            child: Text('Already have an account? Sign in'),
                          )),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
