import mysql.connector
from mysql.connector import Error

try:
    # MySQL 연결 설정
    db = mysql.connector.connect(
        host="localhost",
        user="root",
        password="4907",
        database="user_db"
    )

    if db.is_connected():
        print("MySQL에 연결되었습니다.")
    
    # 쿼리 실행
    cursor = db.cursor()
    cursor.execute("SELECT * FROM users")
    for row in cursor.fetchall():
        print(row)

except Error as e:
    print(f"에러 발생: {e}")
finally:
    if db.is_connected():
        cursor.close()
        db.close()
        print("MySQL 연결이 종료되었습니다.")
