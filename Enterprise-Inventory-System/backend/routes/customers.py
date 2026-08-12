from flask import Blueprint, jsonify, request
from services.customer_service import CustomerService

customers_bp = Blueprint(
    "customers",
    __name__,
    url_prefix="/customers"
)


@customers_bp.get("/")
def get_all_customers():
    return jsonify(CustomerService.get_all())


@customers_bp.get("/<int:customer_id>")
def get_customer(customer_id):
    customer = CustomerService.get_by_id(customer_id)
    if not customer:
        return jsonify({"success": False, "message": "Customer not found"}), 404
    return jsonify(customer)


@customers_bp.post("/")
def add_customer():
    try:
        CustomerService.add(request.json)
        return jsonify({"success": True, "message": "Customer Added Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@customers_bp.put("/<int:customer_id>")
def update_customer(customer_id):
    try:
        CustomerService.update(customer_id, request.json)
        return jsonify({"success": True, "message": "Customer Updated Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@customers_bp.delete("/<int:customer_id>")
def delete_customer(customer_id):
    try:
        CustomerService.delete(customer_id)
        return jsonify({"success": True, "message": "Customer Deleted Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500