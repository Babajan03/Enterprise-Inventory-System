"""Customers route blueprint – CRUD operations for Customers.
All endpoints return JSON with {success, data/message} and use try/except.
"""
from flask import Blueprint, request, jsonify
from services.customer_service import CustomerService

customers_bp = Blueprint('customers', __name__)

@customers_bp.route('/customers', methods=['GET'])
def get_customers():
    try:
        data = CustomerService.get_all()
        return jsonify({'success': True, 'data': data}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@customers_bp.route('/customers', methods=['POST'])
def add_customer():
    try:
        payload = request.get_json()
        CustomerService.add(payload)
        return jsonify({'success': True, 'message': 'Customer added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@customers_bp.route('/customers/<int:cid>', methods=['PUT'])
def update_customer(cid):
    try:
        payload = request.get_json()
        CustomerService.update(cid, payload)
        return jsonify({'success': True, 'message': 'Customer updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@customers_bp.route('/customers/<int:cid>', methods=['DELETE'])
def delete_customer(cid):
    try:
        CustomerService.delete(cid)
        return jsonify({'success': True, 'message': 'Customer deleted'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
