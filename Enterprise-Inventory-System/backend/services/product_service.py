"""Product service handling CRUD operations against SQL Server.
Uses master.SP_Add_Product and master.SP_Update_Product stored procedures with correct parameter ordering.
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
            product.get('ProductDescription', ''),
            product.get('SKU', ''),
            product.get('Barcode', ''),
            product.get('HSNCode', ''),
            product.get('CategoryID', 1),
            product.get('BrandID', 1),
            product.get('UnitID', 1),
            product.get('TaxID', 1),
            product.get('CurrencyID', 1),
            product.get('CostPrice', 0),
            product.get('SellingPrice', 0),
            product.get('MinimumStock', 0),
            product.get('MaximumStock', 100),
            product.get('ReorderLevel', 10)
        )
        row = cursor.fetchone()
        if row and row[0] == 'Failed':
            raise Exception(row[1])
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update(product_id: int, product: Dict[str, Any]) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC master.SP_Update_Product ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?",
            product_id,
            product.get('ProductName'),
            product.get('ProductDescription', ''),
            product.get('SKU', ''),
            product.get('Barcode', ''),
            product.get('HSNCode', ''),
            product.get('CategoryID', 1),
            product.get('BrandID', 1),
            product.get('UnitID', 1),
            product.get('TaxID', 1),
            product.get('CurrencyID', 1),
            product.get('CostPrice', 0),
            product.get('SellingPrice', 0),
            product.get('MinimumStock', 0),
            product.get('MaximumStock', 100),
            product.get('ReorderLevel', 10)
        )
        row = cursor.fetchone()
        if row and row[0] == 'Failed':
            raise Exception(row[1])
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def delete(product_id: int) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Delete_Product ?", product_id)
        row = cursor.fetchone()
        if row and row[0] == 'Failed':
            raise Exception(row[1])
        conn.commit()
        cursor.close()
        conn.close()
