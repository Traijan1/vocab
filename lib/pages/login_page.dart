import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/appwrite_provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(hintText: "E-Mail"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
          ),
          const SizedBox(height: 30),
          MaterialButton(
              child: const Text("Login"),
              onPressed: () {
                var appwrite =
                    Provider.of<AppwriteProvider>(context, listen: false);
                appwrite.login(email.text, password.text);
              })
        ],
      ),
    );
  }
}
