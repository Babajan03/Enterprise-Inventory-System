from database import get_conn


class InventoryService:

    @staticmethod
    def get_all():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC inventory.SP_Get_All_Inventory")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def adjust(inventory_id, data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC inventory.SP_Adjust_Inventory ?,?,?",
            inventory_id,
            data["Quantity"],
            data["Remarks"]
        )
        conn.commit()
        cursor.close()
        conn.close()