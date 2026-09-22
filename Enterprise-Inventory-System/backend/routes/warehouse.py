from flask import Blueprint, request, jsonify
from services.warehouse_service import WarehouseService

warehouse_bp = Blueprint('warehouse', __name__, url_prefix='/warehouse')

@warehouse_bp.route('', methods=['GET'])
@warehouse_bp.route('/', methods=['GET'])
def get_warehouses():
    try:
        data = WarehouseService.get_all()
        return jsonify(data), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@warehouse_bp.route('/<int:wid>', methods=['GET'])
def get_warehouse(wid):
    try:
        wh = WarehouseService.get_by_id(wid)
        if wh:
            return jsonify(wh), 200
        return jsonify({'success': False, 'message': 'Warehouse not found'}), 404
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@warehouse_bp.route('', methods=['POST'])
@warehouse_bp.route('/', methods=['POST'])
def add_warehouse():
    try:
        payload = request.get_json()
        WarehouseService.add(payload)
        return jsonify({'success': True, 'message': 'Warehouse added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@warehouse_bp.route('/<int:wid>', methods=['PUT'])
def update_warehouse(wid):
    try:
        payload = request.get_json()
        WarehouseService.update(wid, payload)
        return jsonify({'success': True, 'message': 'Warehouse updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@warehouse_bp.route('/<int:wid>', methods=['DELETE'])
def delete_warehouse(wid):
    try:
        WarehouseService.delete(wid)
        return jsonify({'success': True, 'message': 'Warehouse deleted'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
