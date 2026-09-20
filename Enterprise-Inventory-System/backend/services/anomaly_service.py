"""Anomaly detection service – uses IsolationForest to find outlier inventory movements.
It expects a DataFrame with numeric columns (e.g., Quantity, StockLevel) and returns the
row indices that are considered anomalies.
"""
import pandas as pd
from sklearn.ensemble import IsolationForest
from typing import List, Dict
from database import get_conn

class AnomalyService:
    @staticmethod
    def _load_movements() -> pd.DataFrame:
        """Load recent inventory movement records.
        Expected table: InventoryMovements(MovementID, ProductID, Quantity, MovementDate).
        Returns a DataFrame with numeric columns used for anomaly detection.
        """
        conn = get_conn()
        cur = conn.cursor()
        query = """
            SELECT TOP 1000 Quantity, DATEDIFF(day, MovementDate, GETDATE()) AS DaysSince
            FROM InventoryMovements
            ORDER BY MovementDate DESC
        """
        cur.execute(query)
        rows = cur.fetchall()
        cur.close(); conn.close()
        if not rows:
            raise Exception("No inventory movement data found for anomaly detection")
        df = pd.DataFrame(rows, columns=['Quantity', 'DaysSince'])
        return df

    @staticmethod
    def detect() -> List[int]:
        """Run IsolationForest and return a list of MovementIDs considered anomalies.
        For simplicity we only return the row numbers within the fetched sample.
        """
        df = AnomalyService._load_movements()
        model = IsolationForest(contamination=0.05, random_state=42)
        model.fit(df)
        preds = model.predict(df)
        # IsolationForest returns -1 for outliers, 1 for inliers
        anomaly_indices = [i for i, p in enumerate(preds) if p == -1]
        return anomaly_indices
