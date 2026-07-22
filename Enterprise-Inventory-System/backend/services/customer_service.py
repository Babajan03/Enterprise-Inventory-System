from database import get_conn


class CustomerService:

    @staticmethod
    def get_all():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC sales.SP_Get_All_Customers")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def get_by_id(customer_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC sales.SP_Get_Customer_By_Id ?", customer_id)
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
    def add(data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC sales.SP_Add_Customer ?,?,?,?,?,?,?,?,?,?",
            data["CustomerCode"],
            data["CustomerName"],
            data["Email"],
            data["PhoneNumber"],
            data["AddressLine1"],
            data["City"],
            data["State"],
            data["Country"],
            data["PostalCode"],
            data["IsActive"]
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update(customer_id, data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC sales.SP_Update_Customer ?,?,?,?,?,?,?,?,?,?,?",
            customer_id,
            data["CustomerCode"],
            data["CustomerName"],
            data["Email"],
            data["PhoneNumber"],
            data["AddressLine1"],
            data["City"],
            data["State"],
            data["Country"],
            data["PostalCode"],
            data["IsActive"]
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def delete(customer_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC sales.SP_Delete_Customer ?", customer_id)
        conn.commit()
        cursor.close()
        conn.close()