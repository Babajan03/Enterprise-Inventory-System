from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from services.notification_service import NotificationService

notifications_bp = Blueprint("notifications", __name__, url_prefix="/notifications")

@notifications_bp.get("")
@jwt_required()
def get_user_notifications():
    try:
        user_id = get_jwt_identity()
        unread_only = request.args.get('unread', 'true').lower() == 'true'
        notifs = NotificationService.get_notifications(user_id, unread_only)
        return jsonify(notifs)
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@notifications_bp.post("/<int:id>/read")
@jwt_required()
def mark_read(id):
    try:
        user_id = get_jwt_identity()
        NotificationService.mark_as_read(id, user_id)
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500
