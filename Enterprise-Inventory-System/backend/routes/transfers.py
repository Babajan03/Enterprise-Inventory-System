from flask import Blueprint, jsonify, request
from services.transfer_service import TransferService

transfers_bp = Blueprint("transfers", __name__, url_prefix="/transfers")

@transfers_bp.get("/")
def get_transfers():
    try:
        transfers = TransferService.get_all_transfers()
        return jsonify(transfers)
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@transfers_bp.post("/")
def create_transfer():
    try:
        data = request.json
        TransferService.create_transfer(data, "SYSTEM")
        return jsonify({"success": True, "message": "Stock transfer requested successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@transfers_bp.put("/<int:id>/approve")
def approve_transfer(id):
    try:
        TransferService.approve_transfer(id)
        return jsonify({"success": True, "message": "Stock transfer approved"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500
