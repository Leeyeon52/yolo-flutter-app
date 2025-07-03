import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _emailController = TextEditingController();
  String message = '';
  final String apiUrl = "http://127.0.0.1:5000";  // 실제 API URL을 입력

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> deleteAccount() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        message = "이메일을 입력하세요.";
      });
      return;
    }

    final response = await http.delete(
      Uri.parse('$apiUrl/delete_account'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    setState(() {
      if (response.statusCode == 200) {
        message = '회원 탈퇴 성공!';
      } else {
        final data = json.decode(response.body);
        message = data['message'] ?? '회원 탈퇴 실패';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원 탈퇴')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: deleteAccount,
              child: const Text('회원 탈퇴'),
            ),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: message.contains('성공') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
