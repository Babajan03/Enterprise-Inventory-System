from database import get_conn
from werkzeug.security import generate_password_hash


class UserService:

    @staticmethod
    def get_all_users():
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_All_Users")
        columns = [column[0] for column in cursor.description]
        users = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return users

    @staticmethod
    def get_all():
        return UserService.get_all_users()

    @staticmethod
    def get_user_by_id(user_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT UserID, Username, FullName, Email, Role, IsActive, CreatedDate FROM master.[User] WHERE UserID = ?",
            user_id
        )
        row = cursor.fetchone()
        if not row:
            cursor.close()
            conn.close()
            return None
        columns = [column[0] for column in cursor.description]
        user = dict(zip(columns, row))
        cursor.close()
        conn.close()
        return user

    @staticmethod
    def add_user(data):
        conn = get_conn()
        cursor = conn.cursor()
        
        # Check duplicate username
        cursor.execute("SELECT UserID FROM master.[User] WHERE Username = ?", data["Username"])
        if cursor.fetchone():
            cursor.close()
            conn.close()
            raise ValueError("Username already exists")

        password_hash = generate_password_hash(data["Password"])
        cursor.execute(
            "EXEC master.SP_Add_User ?,?,?,?,?",
            data["Username"],
            password_hash,
            data["FullName"],
            data.get("Email", ""),
            data.get("Role", "Staff")
        )
        conn.commit()
        cursor.close()
        conn.close()
        return True

    @staticmethod
    def add(data):
        return UserService.add_user(data)

    @staticmethod
    def update_user(user_id, data):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC master.SP_Update_User ?,?,?,?,?",
            user_id,
            data["FullName"],
            data.get("Email", ""),
            data.get("Role", "Staff"),
            1 if data.get("IsActive", True) else 0
        )
        conn.commit()
        cursor.close()
        conn.close()
        return True

    @staticmethod
    def update(user_id, data):
        return UserService.update_user(user_id, data)

    @staticmethod
    def toggle_user_status(user_id, is_active):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "EXEC master.SP_Toggle_User_Status ?,?",
            user_id,
            1 if is_active else 0
        )
        conn.commit()
        cursor.close()
        conn.close()
        return True

    @staticmethod
    def delete(user_id):
        return UserService.toggle_user_status(user_id, False)

    @staticmethod
    def reset_password(user_id, new_password):
        conn = get_conn()
        cursor = conn.cursor()
        password_hash = generate_password_hash(new_password)
        cursor.execute(
            "EXEC master.SP_Admin_Reset_Password ?,?",
            user_id,
            password_hash
        )
        conn.commit()
        cursor.close()
        conn.close()
        return True
