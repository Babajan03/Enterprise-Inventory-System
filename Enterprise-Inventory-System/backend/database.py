import pyodbc
from typing import List, Dict


def get_conn():
    # Update connection string as needed for your environment
    conn_str = (
        "Driver={ODBC Driver 17 for SQL Server};"
        "Server=localhost;"
        "Database=InventoryManagementDB;"
        "Trusted_Connection=yes;"
    )
    return pyodbc.connect(conn_str)
