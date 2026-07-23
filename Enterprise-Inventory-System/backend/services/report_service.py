from database import get_conn


class ReportService:

    @staticmethod
    def inventory_summary():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC report.SP_Inventory_Summary")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def sales_summary():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC report.SP_Sales_Summary")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def purchase_summary():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC report.SP_Purchase_Summary")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data