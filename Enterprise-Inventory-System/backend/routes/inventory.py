"""Inventory route blueprint – CRUD-like endpoints for Inventory actions.
Currently only provides GET (list) and placeholder POST/PUT/DELETE.
"""
from flask import Blueprint, request, jsonify
from services.inventory_service import InventoryService

inventory_bp = Blueprint('inventory', __name__)

@inventory_bp.route('/inventory', methods=['GET'])
def get_inventory():
    try:
        data = InventoryService.get_all()
        return jsonify({'success': True, 'data': data}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@inventory_bp.route('/inventory/adjust', methods=['POST'])
def adjust_inventory():
    try:
        payload = request.get_json()
        InventoryService.adjust(payload)
        return jsonify({'success': True, 'message': 'Adjustment recorded'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@inventory_bp.route('/inventory/receive', methods=['POST'])
def receive_inventory():
    try:
        payload = request.get_json()
        InventoryService.receive(payload)
        return jsonify({'success': True, 'message': 'Receipt recorded'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
