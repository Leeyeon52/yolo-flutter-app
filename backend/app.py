from flask import Flask, request, jsonify
import mysql.connector
from bcrypt import hashpw, gensalt, checkpw
from cryptography.fernet import Fernet 

app = Flask(__name__)

# MySQL 연결 설정
db = mysql.connector.connect(
    host="localhost",         # MySQL 서버 주소 (로컬일 경우 localhost)
    user="root",              # MySQL 사용자 이름
    password="4907",  # MySQL 비밀번호
    database="user_db"        # 사용할 데이터베이스 이름
)

# Fernet 키 생성 (프로덕션 환경에서는 고정 키를 안전하게 저장해야 합니다)
# 한 번만 생성하여 저장된 키를 사용하는 것이 좋습니다.
key = Fernet.generate_key()
cipher = Fernet(key)

@app.route('/')
def home():
    return 'Welcome to the Flask app with MySQL integration!'

@app.route('/signup', methods=['POST'])
def signup():
    data = request.get_json()
    email = data['email']
    password = data['password']
    phone = data['phone']
    name = data['name']

    # 비밀번호 해싱
    hashed_password = hashpw(password.encode('utf-8'), gensalt()).decode('utf-8')

    cursor = db.cursor()

    # 이메일 중복 체크
    cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
    if cursor.fetchone():
        return jsonify({'message': '이미 사용 중인 이메일입니다.'}), 400

    # 비식별화된 휴대폰 번호 및 이름 저장 (암호화 처리)
    phone_encrypted = cipher.encrypt(phone.encode('utf-8')).decode('utf-8')
    name_encrypted = cipher.encrypt(name.encode('utf-8')).decode('utf-8')

    # 데이터베이스에 회원 정보 저장
    cursor.execute(
        "INSERT INTO users (email, password, phone, name) VALUES (%s, %s, %s, %s)",
        (email, hashed_password, phone_encrypted, name_encrypted)
    )
    db.commit()

    return jsonify({'message': '회원가입이 완료되었습니다!'}), 200

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data['email']
    password = data['password']

    cursor = db.cursor()
    cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
    user = cursor.fetchone()

    if user:
        stored_password = user[1]  # 비밀번호는 1번 인덱스에 저장됨
        if checkpw(password.encode('utf-8'), stored_password.encode('utf-8')):
            return jsonify({'message': '로그인 성공!'}), 200
        else:
            return jsonify({'message': '비밀번호가 틀렸습니다.'}), 400
    else:
        return jsonify({'message': '계정이 존재하지 않습니다.'}), 400

@app.route('/find-id', methods=['POST'])
def find_id():
    data = request.get_json()
    email = data['email']

    cursor = db.cursor()
    cursor.execute("SELECT email FROM users WHERE email = %s", (email,))
    user = cursor.fetchone()

    if user:
        return jsonify({'message': f'찾은 아이디: {user[0]}'}), 200
    else:
        return jsonify({'message': '등록된 이메일이 없습니다.'}), 400

@app.route('/delete_account', methods=['POST'])
def delete_account():
    data = request.get_json()
    email = data['email']

    cursor = db.cursor()
    cursor.execute("DELETE FROM users WHERE email = %s", (email,))
    db.commit()

    return jsonify({'message': '회원 탈퇴가 완료되었습니다.'}), 200

if __name__ == '__main__':
    app.run(debug=True)
