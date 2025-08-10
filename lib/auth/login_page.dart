import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';
import 'auth_service.dart';

class LoginPage extends StatelessWidget {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();

  void _login(BuildContext context) async {
    try {
      await _auth.signIn(_email.text, _password.text);
      context.go('/');
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
                onPressed: () => _login(context), child: Text('Login')),
            Link(
                uri: Uri.parse('/signup'),
                builder: (BuildContext context, FollowLink? followLink) =>
                    TextButton(
                      onPressed: followLink,
                      child: Text('No account? Sign up'),
                    ))
          ],
        ),
      ),
    );
  }
}
