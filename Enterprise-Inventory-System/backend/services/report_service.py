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

    @staticmethod
    def monthly_sales_trends():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC report.SP_Monthly_Sales_Trends")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def top_selling_products():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC report.SP_Top_Selling_Products")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def category_sales_summary():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC report.SP_Category_Sales_Summary")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def low_stock_report():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC report.SP_Low_Stock_Report")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def product_movement_report():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC report.SP_Product_Movement_Report")
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data