from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required
from services.user_service import UserService

users_bp = Blueprint("users", __name__, url_prefix="/users")


@users_bp.get("")
@jwt_required()
def get_users():
    try:
        users = UserService.get_all_users()
        return jsonify(users)
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@users_bp.get("/<int:user_id>")
@jwt_required()
def get_user(user_id):
    user = UserService.get_user_by_id(user_id)
    if not user:
        return jsonify({"success": False, "message": "User not found"}), 404
    return jsonify(user)


@users_bp.post("")
@jwt_required()
def add_user():
    data = request.json
    if not data or not data.get("Username") or not data.get("Password") or not data.get("FullName"):
        return jsonify({"success": False, "message": "Username, Password, and FullName are required"}), 400

    try:
        UserService.add_user(data)
        return jsonify({"success": True, "message": "User created successfully"}), 201
    except ValueError as ve:
        return jsonify({"success": False, "message": str(ve)}), 400
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@users_bp.put("/<int:user_id>")
@jwt_required()
def update_user(user_id):
    data = request.json
    if not data or not data.get("FullName"):
        return jsonify({"success": False, "message": "FullName is required"}), 400

    try:
        UserService.update_user(user_id, data)
        return jsonify({"success": True, "message": "User updated successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@users_bp.put("/<int:user_id>/status")
@jwt_required()
def toggle_status(user_id):
    data = request.json
    is_active = data.get("IsActive", True)
    try:
        UserService.toggle_user_status(user_id, is_active)
        status_text = "activated" if is_active else "deactivated"
        return jsonify({"success": True, "message": f"User {status_text} successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@users_bp.put("/<int:user_id>/reset-password")
@jwt_required()
def reset_password(user_id):
    data = request.json
    new_password = data.get("NewPassword")
    if not new_password:
        return jsonify({"success": False, "message": "New password is required"}), 400

    try:
        UserService.reset_password(user_id, new_password)
        return jsonify({"success": True, "message": "Password reset successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500
