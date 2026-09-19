from flask import Blueprint, jsonify
from ..decorators import jwt_protect, role_required

@dashboard_bp.route('/dashboard/full-summary', methods=['GET'])
@jwt_protect
@role_required('admin')
def full_summary():
from decorators import jwt_protect, role_required

# Simple dashboard API returning aggregated placeholder data for the front‑end dashboard.
# In a real system this would query the DB and combine multiple services.

dashboard_bp = Blueprint('dashboard', __name__)

@dashboard_bp.route('/dashboard/full-summary', methods=['GET'])
def full_summary():
    # Placeholder KPI metrics
    metrics = {
        "TotalProducts": 120,
        "TotalInventoryValue": 7523400.50,
        "TotalSalesRevenue": 1245600.75,
        "TotalCustomers": 58,
        "TotalPurchaseSpend": 842300.20,
        "TotalSuppliers": 12,
        "LowStockCount": 7,
        "TotalWarehouses": 3,
    }
    # Placeholder monthly trends (last 6 months)
    trends = [
        {"MonthLabel": "Jan", "SalesAmount": 200000, "PurchaseAmount": 150000},
        {"MonthLabel": "Feb", "SalesAmount": 210000, "PurchaseAmount": 155000},
        {"MonthLabel": "Mar", "SalesAmount": 190000, "PurchaseAmount": 160000},
        {"MonthLabel": "Apr", "SalesAmount": 230000, "PurchaseAmount": 170000},
        {"MonthLabel": "May", "SalesAmount": 250000, "PurchaseAmount": 180000},
        {"MonthLabel": "Jun", "SalesAmount": 240000, "PurchaseAmount": 175000},
    ]
    # Placeholder stock health distribution
    stock_status = {
        "HealthyStockCount": 95,
        "LowStockCount": 7,
        "OutOfStockCount": 2,
    }
    # Placeholder recent sales orders
    recent_sales = [
        {"OrderNumber": "SO-001", "CustomerName": "Acme Corp", "OrderDate": "2026-09-01", "TotalAmount": 12400.50, "OrderStatus": "Shipped"},
        {"OrderNumber": "SO-002", "CustomerName": "Beta Ltd", "OrderDate": "2026-09-03", "TotalAmount": 8300.00, "OrderStatus": "Pending"},
    ]
    # Placeholder urgent low‑stock alerts
    urgent_stock = [
        {"ProductName": "Widget A", "WarehouseName": "Main", "ProductCode": "WGT-A", "CurrentStock": 3, "ReorderLevel": 10},
        {"ProductName": "Gadget B", "WarehouseName": "East", "ProductCode": "GAD-B", "CurrentStock": 2, "ReorderLevel": 8},
    ]
    return jsonify({
        "metrics": metrics,
        "trends": trends,
        "stock_status": stock_status,
        "recent_sales": recent_sales,
        "urgent_stock": urgent_stock,
    })
