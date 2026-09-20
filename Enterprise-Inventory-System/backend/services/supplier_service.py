"""Supplier service – basic CRUD using simple SQL statements.
No stored‑procedure result rows, so pyodbc exceptions are caught by the route.
"""
import pyodbc
from typing import List, Dict, Any
from database import get_conn

class SupplierService:
    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT SupplierID, SupplierName, Contact, Phone FROM Suppliers")
        columns = [c[0] for c in cursor.description]
        rows = [dict(zip(columns, r)) for r in cursor.fetchall()]
        cursor.close()
        conn.close()
        return rows

    @staticmethod
    def add(supplier: Dict[str, Any]) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO Suppliers (SupplierName, Contact, Phone) VALUES (?, ?, ?)",
            supplier.get('SupplierName'),
            supplier.get('Contact'),
            supplier.get('Phone')
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update(supplier_id: int, supplier: Dict[str, Any]) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE Suppliers SET SupplierName = ?, Contact = ?, Phone = ? WHERE SupplierID = ?",
            supplier.get('SupplierName'),
            supplier.get('Contact'),
            supplier.get('Phone'),
            supplier_id
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def delete(supplier_id: int) -> None:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Suppliers WHERE SupplierID = ?", supplier_id)
        conn.commit()
        cursor.close()
        conn.close()
