import os

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from prometheus_flask_exporter import PrometheusMetrics

from models import db, Task

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = (
    f"postgresql://"
    f"{os.getenv('DB_USER')}:"
    f"{os.getenv('DB_PASSWORD')}@"
    f"{os.getenv('DB_HOST')}:5432/"
    f"{os.getenv('DB_NAME')}"
)

app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)

metrics = PrometheusMetrics(app)

with app.app_context():
    db.create_all()

@app.route("/")
def home():
    return "Task Management API Running"

@app.route("/health")
def health():
    return {"status": "healthy"}, 200

@app.route("/tasks", methods=["POST"])
def create_task():

    data = request.get_json()

    task = Task(
        title=data["title"]
    )
    
    db.session.add(task)

    db.session.commit()

    if not data or "title" not in data:
        return {
            "error": "title is required"
        }, 400

    return {
        "message": "Task created successfully"
    }, 201
    

@app.route("/tasks", methods=["GET"])
def get_tasks():

    tasks = Task.query.all()

    result = []

    for task in tasks:

        result.append({
            "id": task.id,
            "title": task.title,
            "status": task.status,
            "created_at": task.created_at.isoformat()
        })

    return jsonify(result)

@app.route("/tasks/<int:id>", methods=["DELETE"])
def delete_task(id):

    task = Task.query.get(id)

    if not task:
        return {
            "error": "Task not found"
        }, 404

    db.session.delete(task)

    db.session.commit()

    return {
        "message": "Task deleted successfully"
    }, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)