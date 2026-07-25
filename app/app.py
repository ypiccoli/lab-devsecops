import os
from flask import Flask, jsonify
import pymysql

app = Flask(__name__)


def get_db_config():
    return {
        "host": os.environ.get("DB_HOST", "localhost"),
        "port": int(os.environ.get("DB_PORT", "3306")),
        "user": os.environ.get("DB_USER", "root"),
        "password": os.environ.get("DB_PASSWORD", ""),
        "database": os.environ.get("DB_NAME", "lab"),
        "connect_timeout": 5,
    }


@app.route("/")
def health():
    return jsonify({"status": "ok"})


@app.route("/db")
def db_check():
    config = get_db_config()
    try:
        conn = pymysql.connect(**config)
        with conn.cursor() as cursor:
            cursor.execute("SELECT 1")
            cursor.fetchone()
        conn.close()
        return jsonify({"status": "ok", "db": "connected", "host": config["host"]})
    except Exception as e:
        return jsonify({"status": "error", "db": "unreachable", "detail": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
