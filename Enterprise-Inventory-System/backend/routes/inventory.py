from flask import Blueprint, jsonify, request
from services.inventory_service import InventoryService

inventory_bp = Blueprint("inventory", __name__, url_prefix="/inventory")


@inventory_bp.get("/")
def get_all_inventory():
    return jsonify(InventoryService.get_all())


@inventory_bp.put("/<int:inventory_id>/adjust")
def adjust_inventory(inventory_id):
    try:
        InventoryService.adjust(inventory_id, request.json)
        return jsonify({"success": True, "message": "Inventory Adjusted Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@inventory_bp.post("/receive")
def receive_goods():
    try:
        InventoryService.receive_goods(request.json)
        return jsonify({"success": True, "message": "Goods Received Successfully & Stock Updated"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500