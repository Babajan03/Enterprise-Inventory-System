# from database import get_conn
# from werkzeug.security import generate_password_hash, check_password_hash


# class AuthService:

#     @staticmethod
#     def register(data):

#         conn = get_conn()
#         cursor = conn.cursor()

#         password_hash = generate_password_hash(data["Password"])

#         cursor.execute(
#             "EXEC master.SP_Add_User ?,?,?,?,?",
#             data["Username"],
#             password_hash,
#             data["FullName"],
#             data.get("Email"),
#             data.get("Role", "Staff")
#         )

#         conn.commit()

#         cursor.close()
#         conn.close()

#     @staticmethod
#     def get_user_by_username(username):

#         conn = get_conn()
#         cursor = conn.cursor()

#         cursor.execute(
#             "EXEC master.SP_Get_User_By_Username ?",
#             username
#         )

#         row = cursor.fetchone()

#         if not row:
#             cursor.close()
#             conn.close()
#             return None

#         columns = [column[0] for column in cursor.description]

#         user = dict(zip(columns, row))

#         cursor.close()
#         conn.close()

#         return user

#     @staticmethod
#     def verify_login(username, password):

#         user = AuthService.get_user_by_username(username)

#         if not user:
#             return None

#         if not user["IsActive"]:
#             return None

#         if not check_password_hash(user["PasswordHash"], password):
#             return None

#         return user



from database import get_conn
from werkzeug.security import generate_password_hash, check_password_hash


class AuthService:

    @staticmethod
    def register(data):
        conn = get_conn()
        cursor = conn.cursor()
        password_hash = generate_password_hash(data["Password"])
        cursor.execute(
            "EXEC master.SP_Add_User ?,?,?,?,?",
            data["Username"],
            password_hash,
            data["FullName"],
            data.get("Email"),
            data.get("Role", "Staff")
        )
        conn.commit()
        cursor.close()
        conn.close()

    @staticmethod
    def get_user_by_username(username):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("EXEC master.SP_Get_User_By_Username ?", username)
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
    def get_user_by_id(user_id):
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT UserID, Username, PasswordHash, FullName, Email, Role, IsActive FROM master.[User] WHERE UserID = ?",
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
    def verify_login(username, password):
        user = AuthService.get_user_by_username(username)
        if not user:
            return None
        if not user["IsActive"]:
            return None
        if not check_password_hash(user["PasswordHash"], password):
            return None
        return user

    @staticmethod
    def change_password(user_id, current_password, new_password):
        user = AuthService.get_user_by_id(user_id)
        if not user:
            return False
        if not check_password_hash(user["PasswordHash"], current_password):
            return False
        conn = get_conn()
        cursor = conn.cursor()
        new_hash = generate_password_hash(new_password)
        cursor.execute(
            "UPDATE master.[User] SET PasswordHash = ? WHERE UserID = ?",
            new_hash, user_id
        )
        conn.commit()
        cursor.close()
        conn.close()
        return True