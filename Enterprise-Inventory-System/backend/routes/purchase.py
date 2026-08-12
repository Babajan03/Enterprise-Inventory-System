from flask import Blueprint, jsonify, request
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
def create_order():
    try:
        result = PurchaseService.create(request.json)
        purchase_id = result.get("PurchaseOrderID")
        purchase_number = result.get("PurchaseOrderNumber")
        return jsonify({
            "success": result.get("status") == "Success",
            "message": result.get("message", "Purchase Order Created"),
            "PurchaseOrderID": purchase_id,
            "PurchaseOrderNumber": purchase_number
        })
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@purchase_bp.post("/<int:order_id>/items")
def add_item(order_id):
    try:
        PurchaseService.add_item(order_id, request.json)
        return jsonify({"success": True, "message": "Item Added Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@purchase_bp.put("/<int:order_id>/status")
def update_status(order_id):
    try:
        new_status = request.json.get("Status")
        PurchaseService.update_status(order_id, new_status)
        return jsonify({"success": True, "message": f"Status updated to {new_status}"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500