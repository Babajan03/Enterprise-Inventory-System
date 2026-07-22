from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required

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
@jwt_required()
def add_customer():
    CustomerService.add(request.json)
    return jsonify({"success": True, "message": "Customer Added Successfully"})


@customers_bp.put("/<int:customer_id>")
@jwt_required()
def update_customer(customer_id):
    CustomerService.update(customer_id, request.json)
    return jsonify({"success": True, "message": "Customer Updated Successfully"})


@customers_bp.delete("/<int:customer_id>")
@jwt_required()
def delete_customer(customer_id):
    CustomerService.delete(customer_id)
    return jsonify({"success": True, "message": "Customer Deleted Successfully"})