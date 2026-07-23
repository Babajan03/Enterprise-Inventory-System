from flask import Blueprint, jsonify
from services.report_service import ReportService

reports_bp = Blueprint("reports", __name__, url_prefix="/reports")


@reports_bp.get("/inventory")
def inventory_summary():
    return jsonify(ReportService.inventory_summary())


@reports_bp.get("/sales")
def sales_summary():
    return jsonify(ReportService.sales_summary())


@reports_bp.get("/purchase")
def purchase_summary():
    return jsonify(ReportService.purchase_summary())