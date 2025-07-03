class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그아웃')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 로그아웃 처리
            Navigator.pushNamed(context, '/login');
          },
          child: Text('로그아웃'),
        ),
      ),
    );
  }
}

class DeleteAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원 탈퇴')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 회원 탈퇴 처리
            Navigator.pushNamed(context, '/');
          },
          child: Text('회원 탈퇴'),
        ),
      ),
    );
  }
}
