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
            if isinstance(transfer.get('TransferDate'), datetime):
                transfer['TransferDate'] = transfer['TransferDate'].isoformat()
            transfers.append(transfer)
            
        cursor.close()
        conn.close()
        return transfers

    @staticmethod
    def create_transfer(data, user_id):
        conn = get_conn()
        cursor = conn.cursor()
        
        try:
            req_user_id = int(user_id)
        except (ValueError, TypeError):
            req_user_id = 1

        cursor.execute(
            "EXEC master.SP_Create_Stock_Transfer ?, ?, ?, ?, ?, ?",
            int(data['ProductID']),
            int(data['FromWarehouseID']),
            int(data['ToWarehouseID']), 
            int(data['Quantity']),
            req_user_id,
            data.get('Notes', '')
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def approve_transfer(transfer_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Approve_Stock_Transfer ?", int(transfer_id))
        conn.commit()
        cursor.close()
        conn.close()
