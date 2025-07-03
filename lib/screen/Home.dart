class ImageDiagnosisScreen extends StatelessWidget {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이미지 진단')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 구강 사진 업로드 UI
            ElevatedButton(
              onPressed: () {
                // 이미지 업로드 처리 로직
              },
              child: Text('사진 업로드'),
            ),
            SizedBox(height: 12),
            // 문진 정보 입력
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: '문진 코멘트'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // 진단 요청 로직
                Navigator.pushNamed(context, '/diagnosis_waiting');
              },
              child: Text('진단 요청'),
            ),
          ],
        ),
      ),
    );
  }
}
