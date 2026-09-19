"""Warehouse service – basic CRUD using direct SQL statements.
"""
import pyodbc
from typing import List, Dict, Any
from ..database import get_conn

class WarehouseService:
    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("SELECT WarehouseID, WarehouseName, Location FROM Warehouses")
        cols = [c[0] for c in cur.description]
        rows = [dict(zip(cols, r)) for r in cur.fetchall()]
        cur.close(); conn.close()
        return rows

    @staticmethod
    def add(wh: Dict[str, Any]) -> None:
        conn = get_conn(); cur = conn.cursor()
        cur.execute(
            "INSERT INTO Warehouses (WarehouseName, Location) VALUES (?, ?)",
            wh.get('WarehouseName'), wh.get('Location')
        )
        conn.commit(); cur.close(); conn.close()

    @staticmethod
    def update(wid: int, wh: Dict[str, Any]) -> None:
        conn = get_conn(); cur = conn.cursor()
        cur.execute(
            "UPDATE Warehouses SET WarehouseName = ?, Location = ? WHERE WarehouseID = ?",
            wh.get('WarehouseName'), wh.get('Location'), wid
        )
        conn.commit(); cur.close(); conn.close()

    @staticmethod
    def delete(wid: int) -> None:
        conn = get_conn(); cur = conn.cursor()
        cur.execute("DELETE FROM Warehouses WHERE WarehouseID = ?", wid)
        conn.commit(); cur.close(); conn.close()
