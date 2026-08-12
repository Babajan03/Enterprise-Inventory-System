from database import get_conn


class PurchaseService:


    @staticmethod
    def get_all():
        conn = get_conn()
        cursor = conn.cursor()
        query = """
        SELECT
            poh.PurchaseOrderID,
            poh.PurchaseOrderNumber,
            s.SupplierName,
            CONVERT(varchar, poh.OrderDate, 23) AS OrderDate,
            CONVERT(varchar, poh.ExpectedDeliveryDate, 23) AS ExpectedDeliveryDate,
            ISNULL(poh.TotalAmount, 0) AS TotalAmount,
            poh.Status
        FROM purchase.PurchaseOrderHeader poh
        LEFT JOIN master.Supplier s ON poh.SupplierID = s.SupplierID
        """
        cursor.execute(query)
        columns = [col[0] for col in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data


    @staticmethod
    def get_by_id(order_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC purchase.SP_Get_Purchase_Order_By_Id ?", order_id)
        row = cursor.fetchone()
        if not row:
            cursor.close()
            conn.close()
            return None
        columns = [column[0] for column in cursor.description]
        result = dict(zip(columns, row))
        cursor.close()
        conn.close()
        return result

    @staticmethod
    def get_items(order_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC purchase.SP_Get_Purchase_Order_Items ?", order_id)
        columns = [column[0] for column in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return data

    @staticmethod
    def create(data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC purchase.SP_Create_Purchase_Order ?,?,?",
            data["SupplierID"],
            data.get("ExpectedDeliveryDate"),
            data.get("Remarks", "")
        )
        # The stored procedure returns Status, PurchaseOrderID, PurchaseOrderNumber, Message
        row = cursor.fetchone()
        if not row:
            conn.rollback()
            cursor.close()
            conn.close()
            raise Exception("Failed to create purchase order")
        # row format: (Status, PurchaseOrderID, PurchaseOrderNumber, Message)
        result = {
            "status": row[0],
            "PurchaseOrderID": row[1],
            "PurchaseOrderNumber": row[2],
            "message": row[3]
        }
        conn.commit()
        cursor.close()
        conn.close()
        return result

    @staticmethod
    def add_item(order_id, data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC purchase.SP_Add_Purchase_Order_Item ?,?,?,?,?,?",
            order_id,
            data["ProductID"],
            data["OrderedQuantity"],
            data["UnitPrice"],
            data.get("DiscountAmount", 0),
            data.get("TaxAmount", 0)
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def update_status(order_id, status):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC purchase.SP_Update_Purchase_Order_Status ?,?",
            order_id,
            status
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def approve_purchase_order(po_id, user_id, decision, remarks):
        """
        Approve or reject a purchase order.
        decision: "Approved" or "Rejected"
        """
        if decision == "Approved":
            try:
                conn = get_conn()
                cursor = conn.cursor()
                cursor.execute("EXEC purchase.SP_Approve_Purchase_Order ?", po_id)
                conn.commit()
                cursor.close()
                conn.close()
                return True, "Purchase order approved."
            except Exception as e:
                return False, str(e)
        else:
            # Reject path: update status to Rejected
            try:
                PurchaseService.update_status(po_id, "Rejected")
                return True, "Purchase order rejected."
            except Exception as e:
                return False, str(e)