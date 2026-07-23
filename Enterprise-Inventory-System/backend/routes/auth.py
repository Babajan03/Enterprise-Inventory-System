# from flask import Blueprint, jsonify, request
# from flask_jwt_extended import create_access_token

# from services.auth_service import AuthService

# auth_bp = Blueprint(
#     "auth",
#     __name__,
#     url_prefix="/auth"
# )


# @auth_bp.post("/register")
# def register():

#     AuthService.register(request.json)

#     return jsonify(
#         {
#             "success": True,
#             "message": "User Registered Successfully"
#         }
#     )


# @auth_bp.post("/login")
# def login():

#     data = request.json

#     user = AuthService.verify_login(
#         data["Username"],
#         data["Password"]
#     )

#     if not user:
#         return jsonify(
#             {
#                 "success": False,
#                 "message": "Invalid username or password"
#             }
#         ), 401

#     token = create_access_token(
#         identity=str(user["UserID"]),
#         additional_claims={"Role": user["Role"]}
#     )

#     return jsonify(
#         {
#             "success": True,
#             "token": token,
#             "user": {
#                 "UserID": user["UserID"],
#                 "Username": user["Username"],
#                 "FullName": user["FullName"],
#                 "Role": user["Role"]
#             }
#         }
#     )


from flask import Blueprint, jsonify, request
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from services.auth_service import AuthService

auth_bp = Blueprint("auth", __name__, url_prefix="/auth")


@auth_bp.post("/register")
def register():
    AuthService.register(request.json)
    return jsonify({"success": True, "message": "User Registered Successfully"})


@auth_bp.post("/login")
def login():
    data = request.json
    user = AuthService.verify_login(data["Username"], data["Password"])
    if not user:
        return jsonify({"success": False, "message": "Invalid username or password"}), 401

    token = create_access_token(
        identity=str(user["UserID"]),
        additional_claims={"Role": user["Role"]}
    )
    return jsonify({
        "success": True,
        "token": token,
        "user": {
            "UserID": user["UserID"],
            "Username": user["Username"],
            "FullName": user["FullName"],
            "Email": user["Email"] if user["Email"] else "",
            "Role": user["Role"]
        }
    })


@auth_bp.post("/change-password")
@jwt_required()
def change_password():
    data = request.json
    user_id = get_jwt_identity()
    result = AuthService.change_password(
        int(user_id),
        data["CurrentPassword"],
        data["NewPassword"]
    )
    if not result:
        return jsonify({"success": False, "message": "Current password is incorrect"}), 400
    return jsonify({"success": True, "message": "Password changed successfully"})