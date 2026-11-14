import os
import mariadb
from flask import Flask, render_template
from dotenv import load_dotenv

load_dotenv()


app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY")

HOST = os.getenv("DB_HOST")
PORT = int(os.getenv("DB_PORT"))
USER = os.getenv("DB_USER")
PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

def get_db():
    return mariadb.connect(
            host=HOST,
            port=PORT,
            user=USER,
            password=PASSWORD,
            database=DB_NAME   
    )


@app.route("/")
def test_conn():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("""
    SELECT COUNT(*)
    FROM professor
    """)
    row = cur.fetchone()
    conn.close()
    return render_template("index.html", count=row[0])

