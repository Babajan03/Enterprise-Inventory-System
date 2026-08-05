from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from services.transfer_service import TransferService
from services.notification_service import NotificationService
from services.audit_service import AuditService

transfers_bp = Blueprint("transfers", __name__, url_prefix="/transfers")

@transfers_bp.get("/")
@jwt_required()
def get_transfers():
    try:
        transfers = TransferService.get_all_transfers()
        return jsonify(transfers)
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@transfers_bp.post("/")
@jwt_required()
def create_transfer():
    try:
        user_id = get_jwt_identity()
        data = request.json
        TransferService.create_transfer(data, user_id)
        
        # Log to audit trail
        AuditService.log_activity("Stock Transfer Requested", f"Requested {data['Quantity']} units of Product {data['ProductID']}", user_id)
        
        return jsonify({"success": True, "message": "Stock transfer requested successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@transfers_bp.put("/<int:id>/approve")
@jwt_required()
def approve_transfer(id):
    try:
        user_id = get_jwt_identity()
        TransferService.approve_transfer(id)
        
        # Trigger notification
        NotificationService.add_notification(f"Stock Transfer #{id} was approved and completed.")
        
        # Log to audit trail
        AuditService.log_activity("Stock Transfer Approved", f"Transfer #{id} completed", user_id)
        
        return jsonify({"success": True, "message": "Stock transfer approved"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500
