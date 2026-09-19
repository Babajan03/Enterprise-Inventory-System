from flask import Blueprint, request, jsonify
from ..services.product_service import ProductService

products_bp = Blueprint('products', __name__)

@products_bp.route('/products', methods=['GET'])
def get_products():
    try:
        data = ProductService.get_all()
        return jsonify({'success': True, 'data': data}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@products_bp.route('/products', methods=['POST'])
def add_product():
    try:
        product = request.get_json()
        ProductService.add(product)
        return jsonify({'success': True, 'message': 'Product added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@products_bp.route('/products/<int:pid>', methods=['PUT'])
def update_product(pid):
    try:
        product = request.get_json()
        ProductService.update(pid, product)
        return jsonify({'success': True, 'message': 'Product updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@products_bp.route('/products/<int:pid>', methods=['DELETE'])
def delete_product(pid):
    try:
        ProductService.delete(pid)
        return jsonify({'success': True, 'message': 'Product deleted'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
