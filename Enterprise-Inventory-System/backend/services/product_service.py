"""Product service handling CRUD operations against SQL Server.
Uses stored procedures that return a status row (Success/Failed) for Add/Update/Delete.
"""
import pyodbc
from typing import List, Dict, Any
from database import get_conn

class ProductService:
    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_All_Products")
        columns = [column[0] for column in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return rows

    @staticmethod
    def add(product: Dict[str, Any]) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC master.SP_Add_Product ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?",
            product.get('ProductCode'),
            product.get('ProductName'),
            product.get('CategoryID'),
            product.get('BrandID'),
            product.get('UnitID'),
            product.get('TaxID'),
            product.get('CurrencyID'),
            product.get('ReorderLevel'),
            product.get('Packaging'),
            product.get('CostPrice'),
            product.get('SellingPrice'),
            product.get('Discount'),
            product.get('MinStock'),
            product.get('MaxStock'),
            product.get('IsActive'),
            product.get('CreatedBy')
        )
        # Expect a result row: (Status, Message)
        row = cursor.fetchone()
        if row and row[0] != 'Success':
            raise Exception(f"Add product failed: {row[1]}")
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update(product_id: int, product: Dict[str, Any]) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC master.SP_Update_Product ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?",
            product_id,
            product.get('ProductCode'),
            product.get('ProductName'),
            product.get('CategoryID'),
            product.get('BrandID'),
            product.get('UnitID'),
            product.get('TaxID'),
            product.get('CurrencyID'),
            product.get('ReorderLevel'),
            product.get('Packaging'),
            product.get('CostPrice'),
            product.get('SellingPrice'),
            product.get('Discount'),
            product.get('MinStock'),
            product.get('MaxStock'),
            product.get('IsActive'),
            product.get('ModifiedBy')
        )
        row = cursor.fetchone()
        if row and row[0] != 'Success':
            raise Exception(f"Update product failed: {row[1]}")
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def delete(product_id: int) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Delete_Product ?", product_id)
        row = cursor.fetchone()
        if row and row[0] != 'Success':
            raise Exception(f"Delete product failed: {row[1]}")
        conn.commit()
        cursor.close()
        conn.close()
