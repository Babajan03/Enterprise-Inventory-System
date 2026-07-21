from flask import Flask
from flask_cors import CORS
from flask_restx import Api
from flask_jwt_extended import JWTManager

from routes.dashboard import ns as dashboard_ns
from routes.products import products_bp
from routes.auth import auth_bp
from routes.suppliers import suppliers_bp

app = Flask(__name__)
app.config["JWT_SECRET_KEY"] = "change-this-to-a-random-secret-later"

CORS(app)
JWTManager(app)

api = Api(app, title="EIMS API", version="1.0")
api.add_namespace(dashboard_ns)

app.register_blueprint(products_bp)
app.register_blueprint(auth_bp)
app.register_blueprint(suppliers_bp)

if __name__ == "__main__":
    app.run(debug=True)