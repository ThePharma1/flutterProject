import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController lastController = TextEditingController();

  String firstError = "";
  String lastError = "";
  String message = "";

  Future<void> addStudent() async {
    setState(() {
      firstError = "";
      lastError = "";
      message = "";
    });

    bool hasError = false;
    if (firstController.text.trim().isEmpty) {
      firstError = "Please enter first name";
      hasError = true;
    }
    if (lastController.text.trim().isEmpty) {
      lastError = "Please enter last name";
      hasError = true;
    }
    if (hasError) {
      setState(() {});
      return;
    }

    final url = Uri.parse(
      "http://127.0.0.1:8888/project_2_api/add_student.php",
    ); // Use same as login

    try {
      print(
        "Sending POST request with first: ${firstController.text}, last: ${lastController.text}",
      );
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "first_name": firstController.text.trim(),
          "last_name": lastController.text.trim(),
        }),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() {
          message = data['message'];
          firstController.clear();
          lastController.clear();
        });
      } else {
        setState(() {
          message = data['message'];
        });
      }
    } catch (e) {
      print("Network error: $e");
      setState(() {
        message =
            "Network error: Unable to reach server.\nMake sure XAMPP Apache is running and Firewall allows access.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: firstController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    errorText: firstError.isEmpty ? null : firstError,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    errorText: lastError.isEmpty ? null : lastError,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await addStudent();
                    if (message.isNotEmpty) {
                      final color = message.toLowerCase().contains('success')
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: color,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text("Add Student"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
