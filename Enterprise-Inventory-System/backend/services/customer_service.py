"""Customer service – simple CRUD using direct SQL.\n"""
import pyodbc
from typing import List, Dict, Any
from database import get_conn

class CustomerService:
    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("SELECT CustomerID, CustomerName, Contact, Phone FROM Customers")
        cols = [c[0] for c in cur.description]
        rows = [dict(zip(cols, r)) for r in cur.fetchall()]
        cur.close(); conn.close()
        return rows

    @staticmethod
    def add(customer: Dict[str, Any]) -> None:
        conn = get_conn(); cur = conn.cursor()
        cur.execute(
            "INSERT INTO Customers (CustomerName, Contact, Phone) VALUES (?, ?, ?)",
            customer.get('CustomerName'), customer.get('Contact'), customer.get('Phone')
        )
        conn.commit(); cur.close(); conn.close()

    @staticmethod
    def update(cid: int, customer: Dict[str, Any]) -> None:
        conn = get_conn(); cur = conn.cursor()
        cur.execute(
            "UPDATE Customers SET CustomerName = ?, Contact = ?, Phone = ? WHERE CustomerID = ?",
            customer.get('CustomerName'), customer.get('Contact'), customer.get('Phone'), cid
        )
        conn.commit(); cur.close(); conn.close()

    @staticmethod
    def delete(cid: int) -> None:
        conn = get_conn(); cur = conn.cursor()
        cur.execute("DELETE FROM Customers WHERE CustomerID = ?", cid)
        conn.commit(); cur.close(); conn.close()
