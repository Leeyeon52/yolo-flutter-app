import mysql.connector
from bcrypt import hashpw, gensalt

# MySQL 연결 설정
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="4907",
    database="user_db"
)

# 커서 생성
cursor = db.cursor()

# 비밀번호 해싱
password = "your_password"
hashed_password = hashpw(password.encode('utf-8'), gensalt()).decode('utf-8')

# 사용자 정보 삽입
cursor.execute(
    "INSERT INTO users (email, password, phone, name) VALUES (%s, %s, %s, %s)",
    ("user@example.com", hashed_password, "010-1234-5678", "John Doe")
)

# 데이터베이스에 반영
db.commit()

# 성공 메시지 출력
print("회원가입이 완료되었습니다!")

# 연결 종료
cursor.close()
db.close()
