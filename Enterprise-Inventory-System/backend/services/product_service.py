from database import get_conn


class ProductService:

    @staticmethod
    def get_all():

        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute("EXEC master.SP_Get_All_Products")

        columns = [column[0] for column in cursor.description]

        data = [dict(zip(columns, row)) for row in cursor.fetchall()]

        cursor.close()
        conn.close()

        return data

    @staticmethod
    def get_by_id(product_id):

        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC master.SP_Get_Product_By_Id ?",
            product_id
        )

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

        cursor.execute("""

EXEC master.SP_Add_Product
?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?

""",
            data["ProductCode"],
            data["ProductName"],
            data["ProductDescription"],
            data["SKU"],
            data["Barcode"],
            data["HSNCode"],
            data["CategoryID"],
            data["BrandID"],
            data["UnitID"],
            data["TaxID"],
            data["CurrencyID"],
            data["CostPrice"],
            data["SellingPrice"],
            data["MinimumStock"],
            data["MaximumStock"],
            data["ReorderLevel"]
        )

        conn.commit()

        cursor.close()
        conn.close()

    @staticmethod
    def update(product_id, data):

        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute("""

EXEC master.SP_Update_Product
?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?

""",
            product_id,
            data["ProductName"],
            data["ProductDescription"],
            data["SKU"],
            data["Barcode"],
            data["HSNCode"],
            data["CategoryID"],
            data["BrandID"],
            data["UnitID"],
            data["TaxID"],
            data["CurrencyID"],
            data["CostPrice"],
            data["SellingPrice"],
            data["MinimumStock"],
            data["MaximumStock"],
            data["ReorderLevel"]
        )

        conn.commit()

        cursor.close()
        conn.close()

    @staticmethod
    def delete(product_id):

        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC master.SP_Delete_Product ?",
            product_id
        )

        conn.commit()

        cursor.close()
        conn.close()

    @staticmethod
    def search(data):

        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute("""

EXEC master.SP_Search_Product ?,?,?,?

""",
            data["ProductName"],
            data["CategoryID"],
            data["BrandID"],
            data["IsActive"]
        )

        columns = [column[0] for column in cursor.description]

        result = [dict(zip(columns, row)) for row in cursor.fetchall()]

        cursor.close()
        conn.close()

        return result