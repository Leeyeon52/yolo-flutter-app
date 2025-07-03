import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  _FindPasswordPageState createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String message = '';
  final String apiUrl = "http://127.0.0.1:5000";  // 백엔드 API URL

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> findPassword() async {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (email.isEmpty || phone.isEmpty) {
      setState(() {
        message = "이메일과 전화번호를 입력하세요.";
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/find_password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'phone': phone}),
    );

    setState(() {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        message = data['message'] ?? '비밀번호 찾기 성공!';
      } else {
        final data = json.decode(response.body);
        message = data['message'] ?? '비밀번호 찾기 실패';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 찾기')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '전화번호'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: findPassword,
              child: const Text('비밀번호 찾기'),
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
