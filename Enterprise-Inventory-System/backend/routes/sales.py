from flask import Blueprint, jsonify, request
from services.sales_service import SalesService

sales_bp = Blueprint("sales", __name__, url_prefix="/sales")


@sales_bp.get("/")
def get_all_orders():
    return jsonify(SalesService.get_all())


@sales_bp.get("/<int:order_id>")
def get_order(order_id):
    order = SalesService.get_by_id(order_id)
    if not order:
        return jsonify({"success": False, "message": "Order not found"}), 404
    return jsonify(order)


@sales_bp.get("/<int:order_id>/items")
def get_order_items(order_id):
    return jsonify(SalesService.get_items(order_id))


@sales_bp.post("/")
def create_order():
    try:
        result = SalesService.create(request.json)
        return jsonify({
            "success": True,
            "message": "Sales Order Created",
            "SalesOrderId": result.get("SalesOrderId"),
            "OrderNumber": result.get("OrderNumber")
        })
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@sales_bp.post("/<int:order_id>/items")
def add_item(order_id):
    try:
        SalesService.add_item(order_id, request.json)
        return jsonify({"success": True, "message": "Item Added Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@sales_bp.put("/<int:order_id>/status")
def update_status(order_id):
    try:
        SalesService.update_status(order_id, request.json["OrderStatus"])
        return jsonify({"success": True, "message": "Status Updated Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500