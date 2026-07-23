from flask_restx import Namespace, Resource
from database import get_conn

ns = Namespace("dashboard")


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
            return cursor.fetchone()[0]

        result = {
            "products": q("SELECT COUNT(*) FROM master.Product"),
            "suppliers": q("SELECT COUNT(*) FROM master.Supplier"),
            "customers": q("SELECT COUNT(*) FROM sales.Customer"),
            "warehouses": q("SELECT COUNT(*) FROM inventory.Warehouse")
        }

        cursor.close()
        conn.close()

        return result