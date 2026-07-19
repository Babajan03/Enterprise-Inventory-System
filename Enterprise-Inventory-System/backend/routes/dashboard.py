from flask_restx import Namespace, Resource
from database import get_conn
ns=Namespace("dashboard")
@ns.route("/health")
class Health(Resource):
    def get(self):
        return {"success":True,"message":"API Running"}
@ns.route("/summary")
class Summary(Resource):
    def get(self):
        c=get_conn().cursor()
        q=lambda s:c.execute(s).fetchval()
        return {
          "products":q("select count(*) from master.Product"),
          "suppliers":q("select count(*) from purchase.Supplier"),
          "customers":q("select count(*) from sales.Customer"),
          "warehouses":q("select count(*) from inventory.Warehouse")
        }
