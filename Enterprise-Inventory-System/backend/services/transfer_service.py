from database import get_conn
from datetime import datetime

class TransferService:
    @staticmethod
    def get_all_transfers():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_Stock_Transfers")
        columns = [column[0] for column in cursor.description]
        
        transfers = []
        for row in cursor.fetchall():
            transfer = dict(zip(columns, row))
            if isinstance(transfer['TransferDate'], datetime):
                transfer['TransferDate'] = transfer['TransferDate'].isoformat()
            transfers.append(transfer)
            
        cursor.close()
        conn.close()
        return transfers

    @staticmethod
    def create_transfer(data, user_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC master.SP_Create_Stock_Transfer ?, ?, ?, ?, ?, ?",
            data['ProductID'], data['FromWarehouseID'], data['ToWarehouseID'], 
            data['Quantity'], user_id, data.get('Notes', '')
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def approve_transfer(transfer_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Approve_Stock_Transfer ?", transfer_id)
        conn.commit()
        cursor.close()
        conn.close()
