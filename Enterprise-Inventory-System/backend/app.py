# from flask import Flask
# from flask_cors import CORS
# from flask_restx import Api
# from flask_jwt_extended import JWTManager

# from routes.dashboard import ns as dashboard_ns
# from routes.products import products_bp
# from routes.auth import auth_bp
# from routes.suppliers import suppliers_bp
# from routes.customers import customers_bp
# from routes.warehouse import warehouse_bp
# from routes.inventory import inventory_bp
# from routes.purchase import purchase_bp
# from routes.sales import sales_bp
# from routes.reports import reports_bp

# app = Flask(__name__)
# app.config["JWT_SECRET_KEY"] = "change-this-to-a-random-secret-later"

# CORS(app)
# JWTManager(app)

# api = Api(app, title="EIMS API", version="1.0")
# api.add_namespace(dashboard_ns)

# app.register_blueprint(products_bp)
# app.register_blueprint(auth_bp)
# app.register_blueprint(suppliers_bp)
# app.register_blueprint(customers_bp)
# app.register_blueprint(warehouse_bp)
# app.register_blueprint(inventory_bp)
# app.register_blueprint(purchase_bp)
# app.register_blueprint(sales_bp)
# app.register_blueprint(reports_bp)

# if __name__ == "__main__":
#     app.run(debug=True)



from flask import Flask
from flask_cors import CORS
from flask_restx import Api
from flask_jwt_extended import JWTManager
from datetime import timedelta

from routes.dashboard import ns as dashboard_ns
from routes.products import products_bp
from routes.auth import auth_bp
from routes.suppliers import suppliers_bp
from routes.customers import customers_bp
from routes.warehouse import warehouse_bp
from routes.inventory import inventory_bp
from routes.purchase import purchase_bp
from routes.sales import sales_bp
from routes.reports import reports_bp

app = Flask(__name__)
app.config["JWT_SECRET_KEY"] = "eims-xK9#mP2$qL7@nR4&wT6"
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(days=7)

CORS(app)
JWTManager(app)

api = Api(app, title="EIMS API", version="1.0")
api.add_namespace(dashboard_ns)

app.register_blueprint(products_bp)
app.register_blueprint(auth_bp)
app.register_blueprint(suppliers_bp)
app.register_blueprint(customers_bp)
app.register_blueprint(warehouse_bp)
app.register_blueprint(inventory_bp)
app.register_blueprint(purchase_bp)
app.register_blueprint(sales_bp)
app.register_blueprint(reports_bp)

if __name__ == "__main__":
    app.run(debug=True)