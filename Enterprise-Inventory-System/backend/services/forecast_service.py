"""Forecast service – uses Prophet to predict future demand for a product.
It pulls historical sales quantity per day for the given product and returns a list of
predicted dates with the forecasted quantity.
"""
import pandas as pd
from prophet import Prophet
from typing import List, Dict
from ..database import get_conn

class ForecastService:
    @staticmethod
    def _load_history(product_id: int) -> pd.DataFrame:
        """Fetch historical sales for a product.
        Expected table: Sales(ProductID, SaleDate, Quantity)
        Returns a DataFrame with columns ['ds', 'y'] where ds is a datetime and y is quantity.
        """
        conn = get_conn()
        cur = conn.cursor()
        query = """
            SELECT CONVERT(date, SaleDate) AS SaleDate, SUM(Quantity) AS Qty
            FROM Sales
            WHERE ProductID = ?
            GROUP BY CONVERT(date, SaleDate)
            ORDER BY SaleDate
        """
        cur.execute(query, product_id)
        rows = cur.fetchall()
        cur.close(); conn.close()
        if not rows:
            raise Exception(f"No sales history found for product {product_id}")
        df = pd.DataFrame(rows, columns=['SaleDate', 'Qty'])
        df.rename(columns={'SaleDate': 'ds', 'Qty': 'y'}, inplace=True)
        return df

    @staticmethod
    def predict(product_id: int, periods: int = 30) -> List[Dict[str, any]]:
        """Return a list of forecasted records for the next *periods* days.
        Each record is a dict: {'date': 'YYYY-MM-DD', 'forecast': float}
        """
        df = ForecastService._load_history(product_id)
        model = Prophet(yearly_seasonality=False, weekly_seasonality=True, daily_seasonality=False)
        model.fit(df)
        future = model.make_future_dataframe(periods=periods)
        forecast = model.predict(future)
        # Keep only the forecasted period (after last actual date)
        result = []
        for _, row in forecast.tail(periods).iterrows():
            result.append({
                'date': row['ds'].date().isoformat(),
                'forecast': round(row['yhat'], 2)
            })
        return result
