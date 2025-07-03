class DiagnosisResultScreen extends StatelessWidget {
  final String diagnosisSummary = "충치 발견, 치아 상태 개선 필요";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('진단 결과')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('진단 요약: $diagnosisSummary'),
            ElevatedButton(
              onPressed: () {
                // 예측 결과 저장
              },
              child: Text('결과 저장'),
            ),
            ElevatedButton(
              onPressed: () {
                // 비대면 진단 신청
              },
              child: Text('비대면 진단 신청'),
            ),
          ],
        ),
      ),
    );
  }
}
