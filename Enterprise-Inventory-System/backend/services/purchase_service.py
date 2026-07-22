from database import get_conn


class PurchaseService:

    @staticmethod
    def get_all():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC purchase.SP_Get_All_Purchase_Orders")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def get_by_id(order_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC purchase.SP_Get_Purchase_Order_By_Id ?", order_id)
        row = cursor.fetchone()
        if not row:
            cursor.close()
            conn.close()
            return None
        columns = [column[0] for column in cursor.description]
        result = dict(zip(columns, row))
        cursor.close()
        conn.close()
        return result

    @staticmethod
    def get_items(order_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC purchase.SP_Get_Purchase_Order_Items ?", order_id)
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def create(data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC purchase.SP_Create_Purchase_Order ?,?,?,?,?",
            data["PurchaseOrderNumber"],
            data["SupplierID"],
            data["OrderDate"],
            data["ExpectedDeliveryDate"],
            data.get("Remarks", "")
        )
        row = cursor.fetchone()
        order_id = row[0] if row else None
        conn.commit()
        cursor.close()
        conn.close()
        return order_id

    @staticmethod
    def add_item(order_id, data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC purchase.SP_Add_Purchase_Order_Item ?,?,?,?,?,?",
            order_id,
            data["ProductID"],
            data["OrderedQuantity"],
            data["UnitPrice"],
            data.get("DiscountAmount", 0),
            data.get("TaxAmount", 0)
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update_status(order_id, status):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC purchase.SP_Update_Purchase_Order_Status ?,?",
            order_id,
            status
        )
        conn.commit()
        cursor.close()
        conn.close()