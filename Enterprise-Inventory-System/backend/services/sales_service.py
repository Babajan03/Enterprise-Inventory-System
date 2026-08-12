from database import get_conn


class SalesService:

    @staticmethod
    def get_all():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT 
                soh.SalesOrderId,
                soh.OrderNumber,
                c.CustomerName,
                CONVERT(VARCHAR, soh.OrderDate, 23) AS OrderDate,
                ISNULL(soh.OrderStatus, 'Draft') AS OrderStatus,
                ISNULL(soh.TotalAmount, 0) AS TotalAmount
            FROM sales.SalesOrderHeader soh
            LEFT JOIN sales.Customer c ON soh.CustomerId = c.CustomerId
        """)
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
        cursor.execute("""
            SELECT 
                sod.SalesOrderDetailId,
                sod.SalesOrderId,
                p.ProductName,
                sod.Quantity,
                sod.UnitPrice,
                (sod.Quantity * sod.UnitPrice) AS TotalPrice
            FROM sales.SalesOrderDetail sod
            JOIN master.Product p ON sod.ProductId = p.ProductID
            WHERE sod.SalesOrderId = ?
        """, order_id)
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
            "EXEC sales.SP_Create_Sales_Order ?,?",
            data["CustomerId"],
            "SYSTEM"
        )
        row = cursor.fetchone()
        result = {}
        if row:
            columns = [col[0] for col in cursor.description]
            result = dict(zip(columns, row))
        conn.commit()
        cursor.close()
        conn.close()
        return result

    @staticmethod
    def add_item(order_id, data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC sales.SP_Add_Sales_Order_Item ?,?,?,?,?",
            order_id,
            data["ProductId"],
            data["Quantity"],
            data["UnitPrice"],
            "SYSTEM"
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update_status(order_id, status):
        conn = get_conn()
        cursor = conn.cursor()
        if status in ('Confirmed', 'Approved', 'CONFIRMED', 'APPROVED'):
            cursor.execute("EXEC sales.SP_Approve_Sales_Order ?,?", order_id, "SYSTEM")
        elif status in ('Shipped', 'SHIPPED'):
            cursor.execute("EXEC sales.SP_Ship_Sales_Order ?,?", order_id, "SYSTEM")
        else:
            cursor.execute(
                "UPDATE sales.SalesOrderHeader SET OrderStatus = ? WHERE SalesOrderId = ?",
                status,
                order_id
            )
        conn.commit()
        cursor.close()
        conn.close()