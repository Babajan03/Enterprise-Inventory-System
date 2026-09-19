"""Forecast route blueprint – expose demand forecasting via Prophet.
GET /forecast/<product_id>?periods=N returns JSON with list of date/forecast.
"""
from flask import Blueprint, request, jsonify
from services.forecast_service import ForecastService
from ..decorators import jwt_protect, role_required

forecast_bp = Blueprint('forecast', __name__)

@forecast_bp.route('/forecast/<int:product_id>', methods=['GET'])
@jwt_protect
@role_required('admin')
def get_forecast(product_id):
    try:
        periods = int(request.args.get('periods', 30))
        if periods <= 0:
            return jsonify({'success': False, 'message': 'Periods must be positive'}), 400
        result = ForecastService.predict(product_id, periods)
        return jsonify({'success': True, 'data': result}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
