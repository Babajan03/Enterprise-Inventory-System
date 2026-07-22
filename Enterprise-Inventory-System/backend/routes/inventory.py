from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required
from services.inventory_service import InventoryService

inventory_bp = Blueprint("inventory", __name__, url_prefix="/inventory")


@inventory_bp.get("/")
def get_all_inventory():
    return jsonify(InventoryService.get_all())


@inventory_bp.put("/<int:inventory_id>/adjust")
@jwt_required()
def adjust_inventory(inventory_id):
    InventoryService.adjust(inventory_id, request.json)
    return jsonify({"success": True, "message": "Inventory Adjusted Successfully"})