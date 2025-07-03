import mysql.connector

# MySQL 연결 설정
db = mysql.connector.connect(
    host="localhost",         # MySQL 서버 주소 (로컬일 경우 localhost)
    user="root",              # MySQL 사용자 이름
    password="4907",  # MySQL 비밀번호
    database="user_db"        # 연결할 데이터베이스 이름
)

# 커서 생성
cursor = db.cursor()

# 간단한 쿼리 실행 (예: 테이블 목록 조회)
cursor.execute("SHOW TABLES")

# 쿼리 결과 출력
for table in cursor:
    print(table)

# 연결 종료
cursor.close()
db.close()
