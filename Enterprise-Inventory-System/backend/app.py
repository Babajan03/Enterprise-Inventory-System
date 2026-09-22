import os
from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
from flask_jwt_extended import JWTManager

app = Flask(__name__, static_folder='../frontend', static_url_path='')
CORS(app)

# JWT configuration
app.config['JWT_SECRET_KEY'] = 'replace-with-strong-secret'
jwt = JWTManager(app)

# Security headers for all responses
@app.after_request
def set_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['Content-Security-Policy'] = (
        "default-src 'self'; "
        "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://code.jquery.com https://cdn.datatables.net https://cdnjs.cloudflare.com; "
        "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdn.datatables.net; "
        "font-src 'self' https://cdn.jsdelivr.net; "
        "img-src 'self' data:; "
        "connect-src 'self' http://127.0.0.1:5000 http://localhost:5000"
    )
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
    return response

# Favicon route
@app.route("/favicon.ico")
def favicon():
    return send_from_directory(app.static_folder, "favicon.ico")

# Import blueprints
from routes.auth import auth_bp
from routes.products import products_bp
from routes.suppliers import suppliers_bp
from routes.customers import customers_bp
from routes.warehouse import warehouse_bp
from routes.users import users_bp
from routes.inventory import inventory_bp
from routes.purchase import purchase_bp
from routes.sales import sales_bp
from routes.transfers import transfers_bp
from routes.forecast import forecast_bp
from routes.anomaly import anomaly_bp
from routes.reports import reports_bp
from routes.notifications import notifications_bp
from routes.audit import audit_bp
from routes.dashboard_api import dashboard_bp

# Register auth and main domain blueprints
app.register_blueprint(auth_bp)
app.register_blueprint(dashboard_bp)
app.register_blueprint(products_bp)
app.register_blueprint(suppliers_bp)
app.register_blueprint(customers_bp)
app.register_blueprint(warehouse_bp)
app.register_blueprint(inventory_bp)
app.register_blueprint(purchase_bp)
app.register_blueprint(sales_bp)
app.register_blueprint(transfers_bp)
app.register_blueprint(users_bp)
app.register_blueprint(audit_bp)
app.register_blueprint(notifications_bp)
app.register_blueprint(reports_bp)
app.register_blueprint(forecast_bp, url_prefix='/api')
app.register_blueprint(anomaly_bp, url_prefix='/api')

# Also register /api prefixes for backward compatibility
app.register_blueprint(products_bp, name='products_api', url_prefix='/api/products')
app.register_blueprint(suppliers_bp, name='suppliers_api', url_prefix='/api/suppliers')
app.register_blueprint(customers_bp, name='customers_api', url_prefix='/api/customers')
app.register_blueprint(warehouse_bp, name='warehouse_api', url_prefix='/api/warehouse')
app.register_blueprint(inventory_bp, name='inventory_api', url_prefix='/api/inventory')
app.register_blueprint(purchase_bp, name='purchase_api', url_prefix='/api/purchase')
app.register_blueprint(sales_bp, name='sales_api', url_prefix='/api/sales')
app.register_blueprint(transfers_bp, name='transfers_api', url_prefix='/api/transfers')
app.register_blueprint(users_bp, name='users_api', url_prefix='/api/users')
app.register_blueprint(dashboard_bp, name='dashboard_api', url_prefix='/api/dashboard')

# Simple health check
@app.route('/api/health')
def health():
    return jsonify({'status': 'ok'}), 200

# Serve SPA front‑end
@app.route('/login.html')
def login_page():
    return send_from_directory(app.static_folder, 'login.html')

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_spa(path):
    if path != "" and os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    return send_from_directory(app.static_folder, 'index.html')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
