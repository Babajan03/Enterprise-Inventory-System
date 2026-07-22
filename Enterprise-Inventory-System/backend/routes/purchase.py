from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required
from services.purchase_service import PurchaseService

purchase_bp = Blueprint("purchase", __name__, url_prefix="/purchase")


@purchase_bp.get("/")
def get_all_orders():
    return jsonify(PurchaseService.get_all())


@purchase_bp.get("/<int:order_id>")
def get_order(order_id):
    order = PurchaseService.get_by_id(order_id)
    if not order:
        return jsonify({"success": False, "message": "Order not found"}), 404
    return jsonify(order)


@purchase_bp.get("/<int:order_id>/items")
def get_order_items(order_id):
    return jsonify(PurchaseService.get_items(order_id))


@purchase_bp.post("/")
@jwt_required()
def create_order():
    order_id = PurchaseService.create(request.json)
    return jsonify({"success": True, "message": "Purchase Order Created", "PurchaseOrderID": order_id})


@purchase_bp.post("/<int:order_id>/items")
@jwt_required()
def add_item(order_id):
    PurchaseService.add_item(order_id, request.json)
    return jsonify({"success": True, "message": "Item Added Successfully"})


@purchase_bp.put("/<int:order_id>/status")
@jwt_required()
def update_status(order_id):
    PurchaseService.update_status(order_id, request.json["Status"])
    return jsonify({"success": True, "message": "Status Updated Successfully"})