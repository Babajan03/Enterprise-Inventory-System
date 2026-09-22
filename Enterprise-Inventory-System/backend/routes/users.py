from flask import Blueprint, request, jsonify
from services.user_service import UserService

users_bp = Blueprint('users', __name__, url_prefix='/users')

@users_bp.route('', methods=['GET'])
@users_bp.route('/', methods=['GET'])
def get_users():
    try:
        data = UserService.get_all()
        return jsonify(data), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@users_bp.route('/<int:uid>', methods=['GET'])
def get_user(uid):
    try:
        u = UserService.get_user_by_id(uid)
        if u:
            return jsonify(u), 200
        return jsonify({'success': False, 'message': 'User not found'}), 404
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@users_bp.route('', methods=['POST'])
@users_bp.route('/', methods=['POST'])
def add_user():
    try:
        payload = request.get_json()
        UserService.add(payload)
        return jsonify({'success': True, 'message': 'User added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@users_bp.route('/<int:uid>', methods=['PUT'])
def update_user(uid):
    try:
        payload = request.get_json()
        UserService.update(uid, payload)
        return jsonify({'success': True, 'message': 'User updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@users_bp.route('/<int:uid>', methods=['DELETE'])
def delete_user(uid):
    try:
        UserService.delete(uid)
        return jsonify({'success': True, 'message': 'User status updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
