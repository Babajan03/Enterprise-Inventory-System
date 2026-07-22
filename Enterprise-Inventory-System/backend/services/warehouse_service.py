from database import get_conn


class WarehouseService:

    @staticmethod
    def get_all():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC inventory.SP_Get_All_Warehouses")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def get_by_id(warehouse_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC inventory.SP_Get_Warehouse_By_Id ?", warehouse_id)
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
            "EXEC inventory.SP_Add_Warehouse ?,?,?,?,?,?,?,?,?,?",
            data["WarehouseCode"],
            data["WarehouseName"],
            data["AddressLine1"],
            data["City"],
            data["State"],
            data["Country"],
            data["PostalCode"],
            data["ContactPerson"],
            data["ContactNumber"],
            data["IsActive"]
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update(warehouse_id, data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC inventory.SP_Update_Warehouse ?,?,?,?,?,?,?,?,?,?,?",
            warehouse_id,
            data["WarehouseCode"],
            data["WarehouseName"],
            data["AddressLine1"],
            data["City"],
            data["State"],
            data["Country"],
            data["PostalCode"],
            data["ContactPerson"],
            data["ContactNumber"],
            data["IsActive"]
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def delete(warehouse_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC inventory.SP_Delete_Warehouse ?", warehouse_id)
        conn.commit()
        cursor.close()
        conn.close()