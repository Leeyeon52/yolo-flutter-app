class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마이페이지')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이름: 사용자명'),
            Text('이메일: user@example.com'),
            ElevatedButton(
              onPressed: () {
                // 비밀번호 변경 화면으로 이동
                Navigator.pushNamed(context, '/change_password');
              },
              child: Text('비밀번호 변경'),
            ),
            ElevatedButton(
              onPressed: () {
                // 로그아웃 처리
                Navigator.pushNamed(context, '/login');
              },
              child: Text('로그아웃'),
            ),
            ElevatedButton(
              onPressed: () {
                // 회원 탈퇴 확인
                Navigator.pushNamed(context, '/delete_account');
              },
              child: Text('회원 탈퇴'),
            ),
          ],
        ),
      ),
    );
  }
}
