from functools import wraps
from flask import jsonify
from flask_jwt_extended import verify_jwt_in_request, get_jwt

def jwt_protect(fn):
    """Require a valid JWT for any endpoint using this decorator."""
    @wraps(fn)
    def wrapper(*args, **kwargs):
        try:
            verify_jwt_in_request()
        except Exception as e:
            return jsonify({'success': False, 'message': str(e)}), 401
        return fn(*args, **kwargs)
    return wrapper

def role_required(allowed_roles):
    """Require the JWT to contain a 'role' claim matching one of ``allowed_roles``.
    ``allowed_roles`` can be a list or a single string.
    """
    if isinstance(allowed_roles, str):
        allowed_roles = [allowed_roles]
    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            try:
                verify_jwt_in_request()
                claims = get_jwt()
                role = claims.get('role')
                if role not in allowed_roles:
                    return jsonify({'success': False, 'message': 'Forbidden: insufficient role'}), 403
            except Exception as e:
                return jsonify({'success': False, 'message': str(e)}), 401
            return fn(*args, **kwargs)
        return wrapper
    return decorator
