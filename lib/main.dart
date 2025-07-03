import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 화면 파일 임포트
import 'screen/find_id.dart';       // 아이디 찾기 화면
import 'screen/find_password.dart'; // 비밀번호 찾기 화면

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toothie Login',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const MyHomePage(title: 'Toothie Login'),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/find_id': (context) => const FindIdPage(), // 아이디 찾기 페이지
        '/find_password': (context) => const FindPasswordPage(), // 비밀번호 찾기 페이지
        '/delete_account': (context) => const DeleteAccountPage(), // 회원 탈퇴 페이지
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/toothie.png', // 이미지 경로 확인
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                "어서오세요!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text('회원가입'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('로그인'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 회원가입 페이지
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  String message = '';

  final String apiUrl = "http://127.0.0.1:5000";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || phone.isEmpty || name.isEmpty) {
      setState(() => message = "모든 항목을 입력하세요.");
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'phone': phone,
        'name': name,
      }),
    );

    setState(() {
      if (response.statusCode == 200) {
        message = '회원가입 성공!';
      } else {
        message = '회원가입 실패: ${response.body}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '전화번호'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: signup, child: const Text('회원가입')),
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

// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String message = '';

  final String apiUrl = "http://127.0.0.1:5000";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => message = "이메일과 비밀번호를 입력하세요.");
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    setState(() {
      if (response.statusCode == 200) {
        message = '로그인 성공!';
        // 로그인 성공 후 별도의 화면으로 이동하지 않고, 그 상태에서 각 페이지를 사용할 수 있게 설정
      } else {
        message = '로그인 실패: ${response.body}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: login, child: const Text('로그인')),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: message.contains('성공') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            // 회원가입 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('회원가입'),
            ),
            const SizedBox(height: 10),
            // 아이디 찾기 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/find_id');
              },
              child: const Text('아이디 찾기'),
            ),
            const SizedBox(height: 10),
            // 비밀번호 찾기 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/find_password');
              },
              child: const Text('비밀번호 찾기'),
            ),
            const SizedBox(height: 10),
            // 회원 탈퇴 버튼 추가
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/delete_account');
              },
              child: const Text('회원 탈퇴'),
            ),
          ],
        ),
      ),
    );
  }
}

// 회원 탈퇴 페이지
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
