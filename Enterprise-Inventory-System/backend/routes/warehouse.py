"""Warehouse route blueprint – CRUD operations for Warehouses.
All endpoints return JSON with {success, data/message} and use try/except.
"""
from flask import Blueprint, request, jsonify
from services.warehouse_service import WarehouseService

warehouse_bp = Blueprint('warehouse', __name__)

@warehouse_bp.route('/warehouses', methods=['GET'])
def get_warehouses():
    try:
        data = WarehouseService.get_all()
        return jsonify({'success': True, 'data': data}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@warehouse_bp.route('/warehouses', methods=['POST'])
def add_warehouse():
    try:
        payload = request.get_json()
        WarehouseService.add(payload)
        return jsonify({'success': True, 'message': 'Warehouse added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@warehouse_bp.route('/warehouses/<int:wid>', methods=['PUT'])
def update_warehouse(wid):
    try:
        payload = request.get_json()
        WarehouseService.update(wid, payload)
        return jsonify({'success': True, 'message': 'Warehouse updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@warehouse_bp.route('/warehouses/<int:wid>', methods=['DELETE'])
def delete_warehouse(wid):
    try:
        WarehouseService.delete(wid)
        return jsonify({'success': True, 'message': 'Warehouse deleted'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
