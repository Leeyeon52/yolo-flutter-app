import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FindIdPage extends StatefulWidget {
  const FindIdPage({super.key});

  @override
  _FindIdPageState createState() => _FindIdPageState();
}

class _FindIdPageState extends State<FindIdPage> {
  final _emailController = TextEditingController();
  String message = '';
  final String apiUrl = "http://127.0.0.1:5000";  // 백엔드 API URL

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> findId() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        message = "이메일을 입력하세요.";
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/find_id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    setState(() {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        message = '아이디 찾기 성공! 아이디는 ${data['id']}입니다.';
      } else {
        final data = json.decode(response.body);
        message = data['message'] ?? '아이디 찾기 실패';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('아이디 찾기')),
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
              onPressed: findId,
              child: const Text('아이디 찾기'),
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
