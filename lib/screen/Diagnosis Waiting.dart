class DiagnosisWaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('진단 대기')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // 로딩 애니메이션
            SizedBox(height: 20),
            Text('AI가 구강 상태를 분석 중입니다...'),
          ],
        ),
      ),
    );
  }
}
