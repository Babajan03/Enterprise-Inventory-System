import os
from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS

app = Flask(__name__, static_folder='../frontend', static_url_path='')
CORS(app)

# Register blueprints (will be created later)
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
app.register_blueprint(auth_bp, url_prefix='/api/auth')
app.register_blueprint(products_bp, url_prefix='/api')
app.register_blueprint(suppliers_bp, url_prefix='/api')
app.register_blueprint(customers_bp, url_prefix='/api')
app.register_blueprint(warehouse_bp, url_prefix='/api')
app.register_blueprint(users_bp, url_prefix='/api')
app.register_blueprint(inventory_bp, url_prefix='/api')
app.register_blueprint(purchase_bp, url_prefix='/api')
app.register_blueprint(sales_bp, url_prefix='/api')
app.register_blueprint(transfers_bp, url_prefix='/api')
app.register_blueprint(forecast_bp, url_prefix='/api')
app.register_blueprint(anomaly_bp, url_prefix='/api')

# Simple health check
@app.route('/api/health')
def health():
    return jsonify({'status': 'ok'}), 200

# Serve SPA front‑end
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_spa(path):
    if path != "" and os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    return send_from_directory(app.static_folder, 'index.html')

if __name__ == '__main__':
    # For development use
    app.run(debug=True, host='0.0.0.0', port=5000)
