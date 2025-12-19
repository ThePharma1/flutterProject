import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  bool loading = false;
  String error = "";
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    setState(() {
      loading = true;
      error = "";
    });

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8888/project_2_api/get_students.php'),
      );

      final data = jsonDecode(response.body);

      List rawList = [];

      if (data is List) {
        rawList = data;
      } else if (data is Map && data['students'] is List) {
        rawList = data['students'];
      } else if (data is Map && data['data'] is List) {
        rawList = data['data'];
      } else {
        // Try to find the first List inside the object
        for (final v in (data is Map ? data.values : [])) {
          if (v is List) {
            rawList = v;
            break;
          }
        }
      }

      students = rawList
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      error = 'Network error: $e';
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  String _studentTitle(Map<String, dynamic> s) {
    final first = s['first_name'] ?? s['first'] ?? s['fname'] ?? '';
    final last = s['last_name'] ?? s['last'] ?? s['lname'] ?? '';
    final name = ((first.toString() + ' ' + last.toString()).trim());
    if (name.isNotEmpty) return name;
    if (s['name'] != null) return s['name'].toString();
    if (s['username'] != null) return s['username'].toString();
    return s.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: RefreshIndicator(
        onRefresh: fetchStudents,
        child: Builder(
          builder: (context) {
            if (loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (error.isNotEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: fetchStudents,
                    child: const Text('Retry'),
                  ),
                ],
              );
            }

            if (students.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No students found.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: fetchStudents,
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: students.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final s = students[index];
                final initials = (() {
                  final name = _studentTitle(s);
                  final parts = name.split(' ');
                  final a = parts.isNotEmpty && parts[0].isNotEmpty
                      ? parts[0][0]
                      : '?';
                  final b = parts.length > 1 && parts[1].isNotEmpty
                      ? parts[1][0]
                      : '';
                  return (a + b).toUpperCase();
                })();
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(child: Text(initials)),
                  title: Text(_studentTitle(s)),
                  subtitle: Text('ID: ${s['id'] ?? s['student_id'] ?? ''}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
