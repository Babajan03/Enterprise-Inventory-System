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


@reports_bp.get("/monthly-sales")
def monthly_sales_trends():
    return jsonify(ReportService.monthly_sales_trends())


@reports_bp.get("/top-products")
def top_selling_products():
    return jsonify(ReportService.top_selling_products())


@reports_bp.get("/category-sales")
def category_sales_summary():
    return jsonify(ReportService.category_sales_summary())


@reports_bp.get("/low-stock")
def low_stock_report():
    return jsonify(ReportService.low_stock_report())


@reports_bp.get("/product-movement")
def product_movement_report():
    return jsonify(ReportService.product_movement_report())