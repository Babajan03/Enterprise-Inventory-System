"""Customer service – using database stored procedures and sales.Customer table.
"""
import pyodbc
import time
from typing import List, Dict, Any
from database import get_conn

class CustomerService:
    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC sales.SP_Get_All_Customers")
        cols = [c[0] for c in cur.description]
        rows = [dict(zip(cols, r)) for r in cur.fetchall()]
        cur.close()
        conn.close()
        return rows

    @staticmethod
    def get_by_id(cid: int) -> Dict[str, Any]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC sales.SP_Get_Customer_By_Id ?", cid)
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
    def add(customer: Dict[str, Any]) -> None:
        conn = get_conn()
        cur = conn.cursor()
        code = customer.get('CustomerCode') or f"CUST-{int(time.time())}"
        cur.execute(
            "EXEC sales.SP_Add_Customer ?, ?, ?, ?, ?, ?, ?, ?, ?, ?",
            code,
            customer.get('CustomerName'),
            customer.get('Email', ''),
            customer.get('Phone', customer.get('PhoneNumber', '')),
            customer.get('AddressLine1', ''),
            customer.get('City', ''),
            customer.get('StateName', customer.get('State', '')),
            customer.get('CountryName', customer.get('Country', 'India')),
            customer.get('PostalCode', ''),
            1 if customer.get('IsActive', True) else 0
        )
        conn.commit()
        cur.close()
        conn.close()

    @staticmethod
    def update(cid: int, customer: Dict[str, Any]) -> None:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute(
            "EXEC sales.SP_Update_Customer ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?",
            cid,
            customer.get('CustomerCode'),
            customer.get('CustomerName'),
            customer.get('Email', ''),
            customer.get('Phone', customer.get('PhoneNumber', '')),
            customer.get('AddressLine1', ''),
            customer.get('City', ''),
            customer.get('StateName', customer.get('State', '')),
            customer.get('CountryName', customer.get('Country', 'India')),
            customer.get('PostalCode', ''),
            1 if customer.get('IsActive', True) else 0
        )
        conn.commit()
        cur.close()
        conn.close()

    @staticmethod
    def delete(cid: int) -> None:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("EXEC sales.SP_Delete_Customer ?", cid)
        conn.commit()
        cur.close()
        conn.close()
