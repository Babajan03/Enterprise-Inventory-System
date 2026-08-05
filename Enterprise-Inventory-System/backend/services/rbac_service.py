from flask import g
from flask_jwt_extended import verify_jwt_in_request, get_jwt

def rbac_required(allowed_roles):
    """Decorator to enforce role‑based access.
    Usage: @rbac_required(['Admin', 'Manager'])
    """
    def decorator(fn):
        @verify_jwt_in_request
        def wrapper(*args, **kwargs):
            claims = get_jwt()
            user_role = claims.get('Role')
            if user_role not in allowed_roles:
                from flask import jsonify
                return jsonify({"success": False, "message": "Forbidden: insufficient role"}), 403
            return fn(*args, **kwargs)
        # Preserve original function name
        wrapper.__name__ = fn.__name__
        return wrapper
    return decorator
