import mysql.connector
from bcrypt import checkpw

# MySQL 연결 설정
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="4907",
    database="user_db"
)

# 커서 생성
cursor = db.cursor()

# 사용자 입력 이메일과 비밀번호
email = "user@example.com"
password = "user_password"

# 사용자 이메일 조회
cursor.execute("SELECT email, password FROM users WHERE email = %s", (email,))
user = cursor.fetchone()

if user:
    # 비밀번호 확인
    stored_password = user[1]  # 비밀번호는 1번 인덱스에 저장됨
    if checkpw(password.encode('utf-8'), stored_password.encode('utf-8')):
        print("로그인 성공!")
    else:
        print("비밀번호가 틀렸습니다.")
else:
    print("사용자를 찾을 수 없습니다.")

# 연결 종료
cursor.close()
db.close()
