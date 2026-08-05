from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required
from services.audit_service import AuditService

audit_bp = Blueprint("audit", __name__, url_prefix="/audit")

@audit_bp.get("")
@jwt_required()
def get_audit_logs():
    try:
        # We could parse a ?top=100 query param here if needed
        top = request.args.get('top', default=500, type=int)
        logs = AuditService.get_audit_logs(top)
        return jsonify(logs)
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500
