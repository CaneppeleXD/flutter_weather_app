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
                onPressed: () => _register(context), child: Text('Register')),
            Link(
                uri: Uri.parse('/signin'),
                builder: (BuildContext context, FollowLink? followLink) =>
                    TextButton(
                      onPressed: followLink,
                      child: Text('Already have an account? Sign in'),
                    ))
          ],
        ),
      ),
    );
  }
}
