from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required

from services.supplier_service import SupplierService

suppliers_bp = Blueprint(
    "suppliers",
    __name__,
    url_prefix="/suppliers"
)


@suppliers_bp.get("/")
def get_all_suppliers():
    return jsonify(SupplierService.get_all())


@suppliers_bp.get("/<int:supplier_id>")
def get_supplier(supplier_id):
    supplier = SupplierService.get_by_id(supplier_id)
    if not supplier:
        return jsonify({"success": False, "message": "Supplier not found"}), 404
    return jsonify(supplier)


@suppliers_bp.post("/")
@jwt_required()
def add_supplier():
    SupplierService.add(request.json)
    return jsonify({"success": True, "message": "Supplier Added Successfully"})


@suppliers_bp.put("/<int:supplier_id>")
@jwt_required()
def update_supplier(supplier_id):
    SupplierService.update(supplier_id, request.json)
    return jsonify({"success": True, "message": "Supplier Updated Successfully"})


@suppliers_bp.delete("/<int:supplier_id>")
@jwt_required()
def delete_supplier(supplier_id):
    SupplierService.delete(supplier_id)
    return jsonify({"success": True, "message": "Supplier Deleted Successfully"})