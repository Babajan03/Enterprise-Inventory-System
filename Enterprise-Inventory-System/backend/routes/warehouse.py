from flask import Blueprint, jsonify, request
from services.warehouse_service import WarehouseService

warehouse_bp = Blueprint("warehouse", __name__, url_prefix="/warehouse")


@warehouse_bp.get("/")
def get_all_warehouses():
    return jsonify(WarehouseService.get_all())


@warehouse_bp.get("/<int:warehouse_id>")
def get_warehouse(warehouse_id):
    warehouse = WarehouseService.get_by_id(warehouse_id)
    if not warehouse:
        return jsonify({"success": False, "message": "Warehouse not found"}), 404
    return jsonify(warehouse)


@warehouse_bp.post("/")
def add_warehouse():
    try:
        WarehouseService.add(request.json)
        return jsonify({"success": True, "message": "Warehouse Added Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@warehouse_bp.put("/<int:warehouse_id>")
def update_warehouse(warehouse_id):
    try:
        WarehouseService.update(warehouse_id, request.json)
        return jsonify({"success": True, "message": "Warehouse Updated Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500


@warehouse_bp.delete("/<int:warehouse_id>")
def delete_warehouse(warehouse_id):
    try:
        WarehouseService.delete(warehouse_id)
        return jsonify({"success": True, "message": "Warehouse Deleted Successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500