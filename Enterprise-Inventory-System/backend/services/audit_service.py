from database import get_conn
import json
from datetime import datetime

class AuditService:
    @staticmethod
    def log_activity(action, details=None, user_id=None, username=None, ip_address=None):
        try:
            conn = get_conn()
            cursor = conn.cursor()

            # Serialize details to JSON if it's a dict/list
            if isinstance(details, (dict, list)):
                details_str = json.dumps(details)
            else:
                details_str = str(details) if details else None

            cursor.execute(
                "EXEC master.SP_Log_Activity ?, ?, ?, ?, ?",
                user_id, username, action, details_str, ip_address
            )
            conn.commit()
            cursor.close()
            conn.close()
        except Exception as e:
            # We don't want audit logging to break the main application flow
            print(f"Error logging activity: {e}")

    @staticmethod
    def get_audit_logs(top=500):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_Audit_Logs ?", top)
        columns = [column[0] for column in cursor.description]

        logs = []
        for row in cursor.fetchall():
            log = dict(zip(columns, row))
            # Format datetime
            if isinstance(log['LogDate'], datetime):
                log['LogDate'] = log['LogDate'].isoformat()
            logs.append(log)

        cursor.close()
        conn.close()
        return logs

    @staticmethod
    def log_action(user_id, action, details=None):
        """Convenient wrapper for logging audit actions.
        Parameters
        ----------
        user_id: int
            ID of the user performing the action.
        action: str
            Human‑readable description of the action.
        details: optional
            Additional context (dict, list, or string) serialized as JSON.
        """
        AuditService.log_activity(action=action, details=details, user_id=user_id)
