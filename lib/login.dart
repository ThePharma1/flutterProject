import 'package:flutter/material.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String idError = "";
  String passwordError = "";
  bool rememberMe = false;

  Future<void> login() async {
    setState(() {
      idError = "";
      passwordError = "";
    });

    if (idController.text.isEmpty) {
      setState(() {
        idError = "Please enter your ID";
      });
      return;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Please enter your password";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8888/project_2_api/login.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": idController.text,
          "password": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);
      // print(data);
      if (data['success'] == true) {
        // TODO: handle rememberMe if needed
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        // show error messages under fields
        setState(() {
          idError = "Invalid ID";
          passwordError = "Invalid password";
        });
      }
    } catch (e) {
      setState(() {
        idError = "Error connecting to server";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Welcome',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please sign in to continue',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: "ID",
                    errorText: idError.isEmpty ? null : idError,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: passwordError.isEmpty ? null : passwordError,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text("Remember Me"),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: login, child: const Text("Login")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
