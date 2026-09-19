"""Anomaly detection route – expose IsolationForest results.
GET /anomaly returns JSON with list of row indices flagged as outliers.
"""
from flask import Blueprint, jsonify
from services.anomaly_service import AnomalyService
from decorators import jwt_protect, role_required

anomaly_bp = Blueprint('anomaly', __name__)

@anomaly_bp.route('/anomaly', methods=['GET'])
@jwt_protect
@role_required('admin')
def get_anomalies():
    try:
        indices = AnomalyService.detect()
        return jsonify({'success': True, 'data': indices}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500
