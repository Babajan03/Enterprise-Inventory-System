"""Suppliers route blueprint – CRUD operations for Suppliers.
All endpoints return JSON with {success, data/message} and use try/except.
"""
from flask import Blueprint, request, jsonify
from services.supplier_service import SupplierService

suppliers_bp = Blueprint('suppliers', __name__)

@suppliers_bp.route('/suppliers', methods=['GET'])
def get_suppliers():
    try:
        data = SupplierService.get_all()
        return jsonify({'success': True, 'data': data}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@suppliers_bp.route('/suppliers', methods=['POST'])
def add_supplier():
    try:
        payload = request.get_json()
        SupplierService.add(payload)
        return jsonify({'success': True, 'message': 'Supplier added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@suppliers_bp.route('/suppliers/<int:sid>', methods=['PUT'])
def update_supplier(sid):
    try:
        payload = request.get_json()
        SupplierService.update(sid, payload)
        return jsonify({'success': True, 'message': 'Supplier updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@suppliers_bp.route('/suppliers/<int:sid>', methods=['DELETE'])
def delete_supplier(sid):
    try:
        SupplierService.delete(sid)
        return jsonify({'success': True, 'message': 'Supplier deleted'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
