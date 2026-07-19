import pyodbc
from config import CONN_STR
def get_conn():
    return pyodbc.connect(CONN_STR)
