"""Purchase service handling real SQL Server purchase order stored procedures.
"""
from typing import List, Dict, Any
from database import get_conn

class PurchaseService:
    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC purchase.SP_Get_All_Purchase_Orders")
        cols = [c[0] for c in cur.description]
        rows = [dict(zip(cols, r)) for r in cur.fetchall()]
        cur.close()
        conn.close()
        return rows

    @staticmethod
    def get_by_id(order_id: int) -> Dict[str, Any]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC purchase.SP_Get_Purchase_Order_By_Id ?", order_id)
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
    def get_items(order_id: int) -> List[Dict[str, Any]]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC purchase.SP_Get_Purchase_Order_Items ?", order_id)
        cols = [c[0] for c in cur.description]
        rows = [dict(zip(cols, r)) for r in cur.fetchall()]
        cur.close()
        conn.close()
        return rows

    @staticmethod
    def create(purchase: Dict[str, Any]) -> Dict[str, Any]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute(
            "EXEC purchase.SP_Create_Purchase_Order ?, ?, ?",
            purchase.get('SupplierID'),
            purchase.get('ExpectedDeliveryDate'),
            purchase.get('Remarks', '')
        )
        row = cur.fetchone()
        result = {}
        if row:
            cols = [c[0] for c in cur.description]
            result = dict(zip(cols, row))
        conn.commit()
        cur.close()
        conn.close()
        return result

    @staticmethod
    def add_item(purchase_id: int, item: Dict[str, Any]) -> None:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute(
            "EXEC purchase.SP_Add_Purchase_Order_Item ?, ?, ?, ?, ?, ?",
            purchase_id,
            item.get('ProductID'),
            item.get('QuantityOrdered', item.get('Quantity', 0)),
            item.get('UnitPrice', 0),
            item.get('DiscountAmount', 0),
            item.get('TaxAmount', 0)
        )
        conn.commit()
        cur.close()
        conn.close()

    @staticmethod
    def update_status(purchase_id: int, status: str) -> None:
        conn = get_conn()
        cur = conn.cursor()
        if status in ('Approved', 'APPROVED', 'Confirmed', 'CONFIRMED'):
            cur.execute("EXEC purchase.SP_Approve_Purchase_Order ?, ?", purchase_id, "SYSTEM")
        else:
            cur.execute(
                "EXEC purchase.SP_Update_Purchase_Order_Status ?, ?, ?",
                purchase_id, status, "SYSTEM"
            )
        conn.commit()
        cur.close()
        conn.close()
