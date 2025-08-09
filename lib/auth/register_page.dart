import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginScreen extends StatelessWidget {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService(); // TO DO why use _ start of the variable name?

  void _register(BuildContext context) async {
    try {
      await _auth.signUp(_email.text, _password.text);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Email')),
            TextField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true),
            ElevatedButton(
                onPressed: () => _register(context), child: Text('Login')),
            TextButton(
              child: Text('No account? Sign up'),
              onPressed: () => Navigator.pushNamed(context, '/signup'),
            )
          ],
        ),
      ),
    );
  }
}
