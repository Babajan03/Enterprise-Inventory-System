from database import get_conn


class SalesService:

    @staticmethod
    def get_all():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC sales.SP_Get_All_Sales_Orders")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def get_by_id(order_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC sales.SP_Get_Sales_Order_By_Id ?", order_id)
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
        cursor.execute("EXEC sales.SP_Get_Sales_Order_Items ?", order_id)
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
            "EXEC sales.SP_Create_Sales_Order ?,?,?,?",
            data["OrderNumber"],
            data["CustomerId"],
            data["OrderDate"],
            data.get("OrderStatus", "Draft")
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
            "EXEC sales.SP_Add_Sales_Order_Item ?,?,?,?",
            order_id,
            data["ProductId"],
            data["Quantity"],
            data["UnitPrice"]
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update_status(order_id, status):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC sales.SP_Update_Sales_Order_Status ?,?",
            order_id,
            status
        )
        conn.commit()
        cursor.close()
        conn.close()