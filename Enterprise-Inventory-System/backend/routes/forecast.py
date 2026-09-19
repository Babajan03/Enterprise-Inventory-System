"""Forecast route blueprint – expose demand forecasting via Prophet.
GET /forecast/<product_id>?periods=N returns JSON with list of date/forecast.
"""
from flask import Blueprint, request, jsonify
from services.forecast_service import ForecastService

forecast_bp = Blueprint('forecast', __name__)

@forecast_bp.route('/forecast/<int:product_id>', methods=['GET'])
def get_forecast(product_id):
    try:
        periods = int(request.args.get('periods', 30))
        result = ForecastService.predict(product_id, periods)
        return jsonify({'success': True, 'data': result}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
