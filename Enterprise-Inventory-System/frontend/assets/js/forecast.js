// forecast.js – UI for demand forecasting
import { get } from './api.js';
import { showToast } from './common.js';

document.addEventListener('DOMContentLoaded', () => {
    const btn = document.getElementById('loadForecastBtn');
    btn.addEventListener('click', async () => {
        const productId = document.getElementById('productId').value;
        const periods = document.getElementById('periods').value;
        const tbody = document.querySelector('#forecastTable tbody');
        tbody.innerHTML = '';
        try {
            const response = await get(`/forecast/${productId}?periods=${periods}`);
            if (response.success) {
                const data = response.data;
                data.forEach(item => {
                    const tr = document.createElement('tr');
                    const tdDate = document.createElement('td');
                    tdDate.textContent = item.date;
                    const tdQty = document.createElement('td');
                    tdQty.textContent = item.forecast;
                    tr.appendChild(tdDate);
                    tr.appendChild(tdQty);
                    tbody.appendChild(tr);
                });
            } else {
                showToast(response.message || 'Failed to load forecast', 'error');
            }
        } catch (err) {
            console.error(err);
            showToast('Error fetching forecast', 'error');
        }
    });
});
