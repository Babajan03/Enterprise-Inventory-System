from flask import Blueprint, request, jsonify
from services.customer_service import CustomerService

customers_bp = Blueprint('customers', __name__, url_prefix='/customers')

@customers_bp.route('', methods=['GET'])
@customers_bp.route('/', methods=['GET'])
def get_customers():
    try:
        data = CustomerService.get_all()
        return jsonify(data), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@customers_bp.route('/<int:cid>', methods=['GET'])
def get_customer(cid):
    try:
        c = CustomerService.get_by_id(cid)
        if c:
            return jsonify(c), 200
        return jsonify({'success': False, 'message': 'Customer not found'}), 404
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@customers_bp.route('', methods=['POST'])
@customers_bp.route('/', methods=['POST'])
def add_customer():
    try:
        payload = request.get_json()
        CustomerService.add(payload)
        return jsonify({'success': True, 'message': 'Customer added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@customers_bp.route('/<int:cid>', methods=['PUT'])
def update_customer(cid):
    try:
        payload = request.get_json()
        CustomerService.update(cid, payload)
        return jsonify({'success': True, 'message': 'Customer updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@customers_bp.route('/<int:cid>', methods=['DELETE'])
def delete_customer(cid):
    try:
        CustomerService.delete(cid)
        return jsonify({'success': True, 'message': 'Customer deleted'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
