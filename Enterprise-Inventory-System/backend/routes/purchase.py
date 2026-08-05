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

def create_order():
    result = PurchaseService.create(request.json)
    # result is a dict with keys: status, PurchaseOrderID, PurchaseOrderNumber, message
    purchase_id = result.get("PurchaseOrderID")
    purchase_number = result.get("PurchaseOrderNumber")
    return jsonify({
        "success": result.get("status") == "Success",
        "message": result.get("message", "Purchase Order Created"),
        "PurchaseOrderID": purchase_id,
        "PurchaseOrderNumber": purchase_number
    })


@purchase_bp.post("/<int:order_id>/items")
@jwt_required()
def add_item(order_id):
    PurchaseService.add_item(order_id, request.json)
    return jsonify({"success": True, "message": "Item Added Successfully"})


@purchase_bp.put("/<int:order_id>/status")
@jwt_required()
def update_status(order_id):
    try:
        new_status = request.json.get("Status")
        PurchaseService.update_status(order_id, new_status)

        # Trigger notification
        from services.notification_service import NotificationService
        NotificationService.add_notification(f"Purchase Order #{order_id} was marked as {new_status}")
        
        # Log to audit trail
        user_id = get_jwt_identity()
        from services.audit_service import AuditService
        AuditService.log_activity(f"Update PO Status", f"PO #{order_id} status changed to {new_status}", user_id)

        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500