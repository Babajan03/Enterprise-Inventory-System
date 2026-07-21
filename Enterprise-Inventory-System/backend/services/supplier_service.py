from database import get_conn


class SupplierService:

    @staticmethod
    def get_all():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_All_Suppliers")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def get_by_id(supplier_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_Supplier_By_Id ?", supplier_id)
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
            "EXEC master.SP_Add_Supplier ?,?,?,?,?,?,?",
            data["SupplierCode"],
            data["SupplierName"],
            data["ContactPerson"],
            data["Email"],
            data["Phone"],
            data["Address"],
            data["IsActive"]
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update(supplier_id, data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC master.SP_Update_Supplier ?,?,?,?,?,?,?,?",
            supplier_id,
            data["SupplierCode"],
            data["SupplierName"],
            data["ContactPerson"],
            data["Email"],
            data["Phone"],
            data["Address"],
            data["IsActive"]
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def delete(supplier_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Delete_Supplier ?", supplier_id)
        conn.commit()
        cursor.close()
        conn.close()