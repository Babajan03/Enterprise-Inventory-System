from flask_restx import Namespace, Resource
from database import get_conn
from decimal import Decimal
from datetime import date, datetime

ns = Namespace("dashboard")


def serialize_data(data):
    if isinstance(data, list):
        return [serialize_data(item) for item in data]
    elif isinstance(data, dict):
        return {key: serialize_data(value) for key, value in data.items()}
    elif isinstance(data, Decimal):
        return float(data)
    elif isinstance(data, (datetime, date)):
        return data.isoformat()
    return data


@ns.route("/health")
class Health(Resource):
    def get(self):
        return {"success": True, "message": "API Running"}


@ns.route("/summary")
class Summary(Resource):
    def get(self):
        conn = get_conn()
        cursor = conn.cursor()

        def q(sql):
            cursor.execute(sql)
            row = cursor.fetchone()
            return row[0] if row and row[0] is not None else 0

        try:
            result = {
                "products": q("SELECT COUNT(*) FROM master.Product"),
                "suppliers": q("SELECT COUNT(*) FROM master.Supplier"),
                "customers": q("SELECT COUNT(*) FROM sales.Customer"),
                "warehouses": q("SELECT COUNT(*) FROM inventory.Warehouse")
            }
        except Exception:
            result = {"products": 0, "suppliers": 0, "customers": 0, "warehouses": 0}
        finally:
            cursor.close()
            conn.close()

        return result


@ns.route("/full-summary")
class FullSummary(Resource):
    def get(self):
        conn = get_conn()
        cursor = conn.cursor()

        try:
            cursor.execute("EXEC report.SP_Get_Dashboard_Data")
            
            # Result Set 1: KPI Metrics
            cols1 = [c[0] for c in cursor.description]
            row1 = cursor.fetchone()
            metrics = dict(zip(cols1, row1)) if row1 else {}

            # Result Set 2: Monthly Trends
            cursor.nextset()
            cols2 = [c[0] for c in cursor.description]
            trends = [dict(zip(cols2, r)) for r in cursor.fetchall()]

            # Result Set 3: Stock Status Distribution
            cursor.nextset()
            cols3 = [c[0] for c in cursor.description]
            row3 = cursor.fetchone()
            stock_status = dict(zip(cols3, row3)) if row3 else {}

            # Result Set 4: Recent Sales
            cursor.nextset()
            cols4 = [c[0] for c in cursor.description]
            recent_sales = [dict(zip(cols4, r)) for r in cursor.fetchall()]

            # Result Set 5: Urgent Low Stock
            cursor.nextset()
            cols5 = [c[0] for c in cursor.description]
            urgent_stock = [dict(zip(cols5, r)) for r in cursor.fetchall()]

            payload = {
                "metrics": metrics,
                "trends": trends,
                "stock_status": stock_status,
                "recent_sales": recent_sales,
                "urgent_stock": urgent_stock
            }
            return serialize_data(payload)
        except Exception as e:
            return {
                "error": str(e),
                "metrics": {
                    "TotalProducts": 0, "TotalSuppliers": 0, "TotalCustomers": 0, "TotalWarehouses": 0,
                    "TotalSalesRevenue": 0, "TotalPurchaseSpend": 0, "LowStockCount": 0, "TotalInventoryValue": 0
                },
                "trends": [],
                "stock_status": {"HealthyStockCount": 0, "LowStockCount": 0, "OutOfStockCount": 0},
                "recent_sales": [],
                "urgent_stock": []
            }, 500
        finally:
            cursor.close()
            conn.close()