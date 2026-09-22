"""Warehouse service – CRUD using database stored procedures and inventory.Warehouse table.
"""
import pyodbc
import time
from typing import List, Dict, Any
from database import get_conn

class WarehouseService:
    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC inventory.SP_Get_All_Warehouses")
        cols = [c[0] for c in cur.description]
        rows = [dict(zip(cols, r)) for r in cur.fetchall()]
        cur.close()
        conn.close()
        return rows

    @staticmethod
    def get_by_id(wid: int) -> Dict[str, Any]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC inventory.SP_Get_Warehouse_By_Id ?", wid)
        row = cur.fetchone()
        if not row:
            cur.close()
            conn.close()
            return None
        cols = [c[0] for c in cur.description]
        res = dict(zip(cols, row))
        cur.close()
        conn.close()
        return res

    @staticmethod
    def add(wh: Dict[str, Any]) -> None:
        conn = get_conn()
        cur = conn.cursor()
        code = wh.get('WarehouseCode') or f"WH-{int(time.time())}"
        cur.execute(
            "EXEC inventory.SP_Add_Warehouse ?, ?, ?, ?, ?, ?, ?, ?, ?, ?",
            code,
            wh.get('WarehouseName'),
            wh.get('AddressLine1', wh.get('Location', '')),
            wh.get('City', ''),
            wh.get('StateName', ''),
            wh.get('CountryName', 'India'),
            wh.get('PostalCode', ''),
            wh.get('ManagerName', ''),
            wh.get('ContactPhone', ''),
            wh.get('IsActive', True)
        )
        conn.commit()
        cur.close()
        conn.close()

    @staticmethod
    def update(wid: int, wh: Dict[str, Any]) -> None:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute(
            "EXEC inventory.SP_Update_Warehouse ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?",
            wid,
            wh.get('WarehouseCode', f"WH-{wid}"),
            wh.get('WarehouseName'),
            wh.get('AddressLine1', wh.get('Location', '')),
            wh.get('City', ''),
            wh.get('StateName', ''),
            wh.get('CountryName', 'India'),
            wh.get('PostalCode', ''),
            wh.get('ManagerName', ''),
            wh.get('ContactPhone', ''),
            wh.get('IsActive', True)
        )
        conn.commit()
        cur.close()
        conn.close()

    @staticmethod
    def delete(wid: int) -> None:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC inventory.SP_Delete_Warehouse ?", wid)
        conn.commit()
        cur.close()
        conn.close()
