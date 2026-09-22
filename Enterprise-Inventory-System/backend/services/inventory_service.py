"""Inventory service handling real SQL Server queries and stored procedures.
"""
import time
from typing import List, Dict, Any
from database import get_conn

class InventoryService:
    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC inventory.SP_Get_All_Inventory")
        cols = [c[0] for c in cur.description]
        rows = [dict(zip(cols, r)) for r in cur.fetchall()]
        cur.close()
        conn.close()
        return rows

    @staticmethod
    def adjust(data: Dict[str, Any]) -> None:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute(
            "EXEC inventory.SP_Adjust_Inventory ?, ?, ?, ?, ?, ?",
            data.get('ProductID'),
            data.get('WarehouseID'),
            data.get('TransactionType', 'ADJUSTMENT'),
            data.get('Quantity'),
            data.get('Reason', 'Manual Adjustment'),
            data.get('CreatedBy', 'SYSTEM')
        )
        conn.commit()
        cur.close()
        conn.close()

    @staticmethod
    def receive(data: Dict[str, Any]) -> None:
        conn = get_conn()
        cur = conn.cursor()
        
        inventory_id = data.get('InventoryID') or data.get('InventoryId')
        product_id = data.get('ProductID') or data.get('ProductId')
        warehouse_id = data.get('WarehouseID') or data.get('WarehouseId')
        qty = float(data.get('QuantityReceived') or data.get('Quantity') or 0)
        ref_no = str(data.get('ReferenceNumber') or data.get('PurchaseOrderNumber') or f"RCV-{int(time.time())}")
        created_by = str(data.get('CreatedBy', 'SYSTEM'))

        if not inventory_id and product_id and warehouse_id:
            cur.execute("SELECT InventoryID FROM inventory.Inventory WHERE ProductID = ? AND WarehouseID = ?", product_id, warehouse_id)
            row = cur.fetchone()
            if row:
                inventory_id = row[0]
            else:
                cur.execute("INSERT INTO inventory.Inventory (ProductID, WarehouseID, Quantity, ReorderLevel) VALUES (?, ?, ?, 10)", product_id, warehouse_id, 0)
                conn.commit()
                cur.execute("SELECT InventoryID FROM inventory.Inventory WHERE ProductID = ? AND WarehouseID = ?", product_id, warehouse_id)
                r2 = cur.fetchone()
                if r2:
                    inventory_id = r2[0]

        if not inventory_id:
            cur.execute("SELECT TOP 1 InventoryID FROM inventory.Inventory")
            row = cur.fetchone()
            inventory_id = row[0] if row else 1

        cur.execute(
            "EXEC inventory.SP_Receive_Goods ?, ?, ?, ?",
            inventory_id,
            qty,
            ref_no,
            created_by
        )
        conn.commit()
        cur.close()
        conn.close()
