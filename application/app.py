from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics

def test_home():
    client = app.test_client()

    response = client.get("/")

    assert response.status_code == 200
app = Flask(__name__)

metrics = PrometheusMetrics(app)

@app.route("/")
def home():
    return "Hello There!"

@app.route("/health")
def health():
    return {"status": "healthy"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)