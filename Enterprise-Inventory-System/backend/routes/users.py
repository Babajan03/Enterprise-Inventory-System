"""User route blueprint – CRUD for Users.
All endpoints return JSON with {success, data/message} and use try/except.
"""
from flask import Blueprint, request, jsonify
from services.user_service import UserService

users_bp = Blueprint('users', __name__)

@users_bp.route('/users', methods=['GET'])
def get_users():
    try:
        data = UserService.get_all()
        return jsonify({'success': True, 'data': data}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@users_bp.route('/users', methods=['POST'])
def add_user():
    try:
        payload = request.get_json()
        UserService.add(payload)
        return jsonify({'success': True, 'message': 'User added'}), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@users_bp.route('/users/<int:uid>', methods=['PUT'])
def update_user(uid):
    try:
        payload = request.get_json()
        UserService.update(uid, payload)
        return jsonify({'success': True, 'message': 'User updated'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@users_bp.route('/users/<int:uid>', methods=['DELETE'])
def delete_user(uid):
    try:
        UserService.delete(uid)
        return jsonify({'success': True, 'message': 'User deleted'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
