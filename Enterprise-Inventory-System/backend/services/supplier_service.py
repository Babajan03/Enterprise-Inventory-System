"""Supplier service – CRUD using database stored procedures and master.Supplier table.
"""
import pyodbc
import time
from typing import List, Dict, Any
from database import get_conn

class SupplierService:
    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_All_Suppliers")
        columns = [c[0] for c in cursor.description]
        rows = [dict(zip(columns, r)) for r in cursor.fetchall()]
        cursor.close()
        conn.close()
        return rows

    @staticmethod
    def get_by_id(sid: int) -> Dict[str, Any]:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_Supplier_By_Id ?", sid)
        row = cursor.fetchone()
        if not row:
            cursor.close()
            conn.close()
            return None
        cols = [c[0] for c in cursor.description]
        res = dict(zip(cols, row))
        cursor.close()
        conn.close()
        return res

    @staticmethod
    def add(supplier: Dict[str, Any]) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        code = supplier.get('SupplierCode') or f"SUP-{int(time.time())}"
        cursor.execute(
            "EXEC master.SP_Add_Supplier ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?",
            code,
            supplier.get('SupplierName'),
            supplier.get('ContactPerson', supplier.get('Contact', '')),
            supplier.get('Email', ''),
            supplier.get('Phone', ''),
            supplier.get('GSTNumber', ''),
            supplier.get('AddressLine1', ''),
            supplier.get('City', ''),
            supplier.get('StateName', ''),
            supplier.get('CountryName', 'India'),
            supplier.get('PostalCode', ''),
            supplier.get('IsActive', True)
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update(supplier_id: int, supplier: Dict[str, Any]) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC master.SP_Update_Supplier ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?",
            supplier_id,
            supplier.get('SupplierCode', f"SUP-{supplier_id}"),
            supplier.get('SupplierName'),
            supplier.get('ContactPerson', supplier.get('Contact', '')),
            supplier.get('Email', ''),
            supplier.get('Phone', ''),
            supplier.get('GSTNumber', ''),
            supplier.get('AddressLine1', ''),
            supplier.get('City', ''),
            supplier.get('StateName', ''),
            supplier.get('CountryName', 'India'),
            supplier.get('PostalCode', ''),
            supplier.get('IsActive', True)
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def delete(supplier_id: int) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Delete_Supplier ?", supplier_id)
        conn.commit()
        cursor.close()
        conn.close()
