from database import get_conn
from datetime import datetime

class NotificationService:
    @staticmethod
    def get_notifications(user_id, unread_only=True):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_Notifications ?, ?", user_id, 1 if unread_only else 0)
        columns = [column[0] for column in cursor.description]
        
        notifications = []
        for row in cursor.fetchall():
            notif = dict(zip(columns, row))
            if isinstance(notif['CreatedDate'], datetime):
                notif['CreatedDate'] = notif['CreatedDate'].isoformat()
            notifications.append(notif)
            
        cursor.close()
        conn.close()
        return notifications

    @staticmethod
    def add_notification(message, user_id=None):
        try:
            conn = get_conn()
            cursor = conn.cursor()
            cursor.execute("EXEC master.SP_Add_Notification ?, ?", user_id, message)
            conn.commit()
            cursor.close()
            conn.close()
        except Exception as e:
            print(f"Error adding notification: {e}")

    @staticmethod
    def mark_as_read(notification_id, user_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Mark_Notification_Read ?, ?", notification_id, user_id)
        conn.commit()
        cursor.close()
        conn.close()
