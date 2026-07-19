from flask import Flask
from flask_cors import CORS
from flask_restx import Api

from routes.dashboard import ns as dashboard_ns
from routes.products import products_bp

app = Flask(__name__)

CORS(app)

api = Api(
    app,
    title="EIMS API",
    version="1.0"
)

# RESTX Namespace
api.add_namespace(dashboard_ns)

# Flask Blueprint
app.register_blueprint(products_bp)

if __name__ == "__main__":
    app.run(debug=True)