from flask import Blueprint, request, jsonify
from services.product_service import ProductService

products_bp = Blueprint('products', __name__, url_prefix='/products')

@products_bp.route('', methods=['GET'])
@products_bp.route('/', methods=['GET'])
def get_products():
    try:
        data = ProductService.get_all()
        return jsonify(data), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@products_bp.route('/<int:pid>', methods=['GET'])
def get_product(pid):
    try:
        data = ProductService.get_all()
        prod = next((p for p in data if p.get('ProductID') == pid), None)
        if prod:
            return jsonify(prod), 200
        return jsonify({'success': False, 'message': 'Product not found'}), 404
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@products_bp.route('', methods=['POST'])
@products_bp.route('/', methods=['POST'])
def add_product():
    try:
        product = request.get_json()
        ProductService.add(product)
        return jsonify({'success': True, 'message': 'Product added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@products_bp.route('/<int:pid>', methods=['PUT'])
def update_product(pid):
    try:
        product = request.get_json()
        ProductService.update(pid, product)
        return jsonify({'success': True, 'message': 'Product updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@products_bp.route('/<int:pid>', methods=['DELETE'])
def delete_product(pid):
    try:
        ProductService.delete(pid)
        return jsonify({'success': True, 'message': 'Product deleted'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
