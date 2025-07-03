const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bcrypt = require('bcryptjs'); // bcrypt 추가

const app = express();
const port = 5000;

// MySQL 연결 설정
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '4907',  // MySQL 비밀번호
  database: 'user_db', // 데이터베이스 이름
});

// CORS 설정 (Flutter와의 통신을 허용)
app.use(cors());
app.use(express.json()); // JSON 데이터 받기

// 데이터베이스 연결 확인
db.connect((err) => {
  if (err) {
    console.error('MySQL 연결 실패:', err);
    return;
  }
  console.log('MySQL 연결 성공');
});

// 회원가입 API
app.post('/signup', (req, res) => {
  const { email, password, phone, name } = req.body;

  if (!email || !password || !phone || !name) {
    return res.status(400).json({ message: '모든 항목을 입력하세요.' });
  }

  // 이메일 중복 검사
  const checkEmailQuery = 'SELECT * FROM users WHERE email = ?';
  db.query(checkEmailQuery, [email], (err, results) => {
    if (err) {
      console.error('쿼리 오류:', err);
      return res.status(500).json({ message: '서버 오류' });
    }

    if (results.length > 0) {
      return res.status(409).json({ message: '이미 가입된 이메일입니다.' });
    }

    // 비밀번호 해싱
    bcrypt.hash(password, 10, (err, hashedPassword) => {
      if (err) {
        console.error('비밀번호 해싱 오류:', err);
        return res.status(500).json({ message: '서버 오류' });
      }

      // 회원가입 쿼리
      const query = 'INSERT INTO users (email, password, phone, name) VALUES (?, ?, ?, ?)';
      db.query(query, [email, hashedPassword, phone, name], (err, results) => {
        if (err) {
          console.error('쿼리 오류:', err);
          return res.status(500).json({ message: '서버 오류' });
        }
        res.status(200).json({ message: '회원가입 성공!' });
      });
    });
  });
});

// 로그인 API
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  const query = 'SELECT * FROM users WHERE email = ?';
  db.query(query, [email], (err, results) => {
    if (err) {
      console.error('쿼리 오류:', err);
      return res.status(500).json({ message: '서버 오류' });
    }

    if (results.length > 0) {
      // 비밀번호 확인
      bcrypt.compare(password, results[0].password, (err, isMatch) => {
        if (err) {
          console.error('비밀번호 비교 오류:', err);
          return res.status(500).json({ message: '서버 오류' });
        }

        if (isMatch) {
          res.status(200).json({ message: '로그인 성공!' });
        } else {
          res.status(401).json({ message: '이메일 또는 비밀번호가 틀립니다.' });
        }
      });
    } else {
      res.status(401).json({ message: '이메일 또는 비밀번호가 틀립니다.' });
    }
  });
});

// 서버 시작
app.listen(port, () => {
  console.log(`서버가 ${port} 포트에서 실행 중`);
});
