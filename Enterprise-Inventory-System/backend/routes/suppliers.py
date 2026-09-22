from flask import Blueprint, request, jsonify
from services.supplier_service import SupplierService

suppliers_bp = Blueprint('suppliers', __name__, url_prefix='/suppliers')

@suppliers_bp.route('', methods=['GET'])
@suppliers_bp.route('/', methods=['GET'])
def get_suppliers():
    try:
        data = SupplierService.get_all()
        return jsonify(data), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@suppliers_bp.route('/<int:sid>', methods=['GET'])
def get_supplier(sid):
    try:
        sup = SupplierService.get_by_id(sid)
        if sup:
            return jsonify(sup), 200
        return jsonify({'success': False, 'message': 'Supplier not found'}), 404
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@suppliers_bp.route('', methods=['POST'])
@suppliers_bp.route('/', methods=['POST'])
def add_supplier():
    try:
        payload = request.get_json()
        SupplierService.add(payload)
        return jsonify({'success': True, 'message': 'Supplier added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@suppliers_bp.route('/<int:sid>', methods=['PUT'])
def update_supplier(sid):
    try:
        payload = request.get_json()
        SupplierService.update(sid, payload)
        return jsonify({'success': True, 'message': 'Supplier updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@suppliers_bp.route('/<int:sid>', methods=['DELETE'])
def delete_supplier(sid):
    try:
        SupplierService.delete(sid)
        return jsonify({'success': True, 'message': 'Supplier deleted'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
