let dashTrendChartInstance = null;
let dashStockChartInstance = null;

function formatCurrencyINR(amount) {
    return "₹ " + parseFloat(amount || 0).toLocaleString("en-IN", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

async function loadDashboard() {
    // Clean up previous charts if re-entering page
    if (dashTrendChartInstance) {
        dashTrendChartInstance.destroy();
        dashTrendChartInstance = null;
    }
    if (dashStockChartInstance) {
        dashStockChartInstance.destroy();
        dashStockChartInstance = null;
    }

    try {
        const data = await api.get("/dashboard/full-summary");
        if (!data) return;

        // 1. Populate KPI Cards
        const m = data.metrics || {};
        document.getElementById("dashProductsCount").textContent = m.TotalProducts || 0;
        document.getElementById("dashInventoryValue").textContent = formatCurrencyINR(m.TotalInventoryValue);
        document.getElementById("dashSalesRevenue").textContent = formatCurrencyINR(m.TotalSalesRevenue);
        document.getElementById("dashCustomersCount").textContent = m.TotalCustomers || 0;
        document.getElementById("dashPurchaseSpend").textContent = formatCurrencyINR(m.TotalPurchaseSpend);
        document.getElementById("dashSuppliersCount").textContent = m.TotalSuppliers || 0;
        document.getElementById("dashLowStockCount").textContent = m.LowStockCount || 0;
        document.getElementById("dashWarehousesCount").textContent = m.TotalWarehouses || 0;

        // 2. Render Trend Chart (Sales vs Purchase)
        renderDashTrendChart(data.trends || []);

        // 3. Render Stock Status Doughnut Chart
        renderDashStockChart(data.stock_status || {});

        // 4. Render Recent Sales Table
        renderRecentSales(data.recent_sales || []);

        // 5. Render Urgent Stock Alerts
        renderUrgentStock(data.urgent_stock || []);

    } catch (err) {
        console.error("Dashboard error:", err);
    }
}

function renderDashTrendChart(trends) {
    const ctx = document.getElementById("dashTrendChart");
    if (!ctx) return;

    const labels = trends.map(t => t.MonthLabel);
    const salesData = trends.map(t => t.SalesAmount);
    const purchaseData = trends.map(t => t.PurchaseAmount);

    dashTrendChartInstance = new Chart(ctx.getContext("2d"), {
        type: "line",
        data: {
            labels: labels,
            datasets: [
                {
                    label: "Sales Revenue (₹)",
                    data: salesData,
                    borderColor: "#1cc88a",
                    backgroundColor: "rgba(28, 200, 138, 0.1)",
                    fill: true,
                    tension: 0.3,
                    borderWidth: 2
                },
                {
                    label: "Purchase Spend (₹)",
                    data: purchaseData,
                    borderColor: "#36b9cc",
                    backgroundColor: "rgba(54, 185, 204, 0.1)",
                    fill: true,
                    tension: 0.3,
                    borderWidth: 2
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: "top", labels: { usePointStyle: true } },
                tooltip: {
                    callbacks: {
                        label: ctx => ctx.dataset.label + ": " + formatCurrencyINR(ctx.raw)
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: value => "₹" + value.toLocaleString("en-IN")
                    }
                }
            }
        }
    });
}

function renderDashStockChart(status) {
    const ctx = document.getElementById("dashStockChart");
    if (!ctx) return;

    const healthy = status.HealthyStockCount || 0;
    const low = status.LowStockCount || 0;
    const out = status.OutOfStockCount || 0;

    dashStockChartInstance = new Chart(ctx.getContext("2d"), {
        type: "doughnut",
        data: {
            labels: ["Healthy Stock", "Low Stock Alert", "Out of Stock"],
            datasets: [{
                data: [healthy, low, out],
                backgroundColor: ["#1cc88a", "#f6c23e", "#e74a3b"],
                borderWidth: 2,
                hoverOffset: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: "bottom", labels: { usePointStyle: true } }
            }
        }
    });
}

function renderRecentSales(sales) {
    const tbody = document.getElementById("dashRecentSalesBody");
    if (!tbody) return;

    if (!sales || sales.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-3">No recent sales orders found</td></tr>';
        return;
    }

    tbody.innerHTML = sales.map(s => {
        const dateStr = s.OrderDate ? new Date(s.OrderDate).toLocaleDateString("en-IN", { day: "2-digit", month: "short" }) : "-";
        let statusBadge = "bg-secondary";
        const status = (s.OrderStatus || "").toLowerCase();
        if (status === "shipped" || status === "completed" || status === "confirmed") statusBadge = "bg-success";
        else if (status === "pending" || status === "draft") statusBadge = "bg-warning text-dark";

        return `
            <tr>
                <td class="ps-3 fw-bold text-primary">${s.OrderNumber}</td>
                <td>${s.CustomerName}</td>
                <td>${dateStr}</td>
                <td class="fw-bold">${formatCurrencyINR(s.TotalAmount)}</td>
                <td class="pe-3"><span class="badge ${statusBadge}">${s.OrderStatus}</span></td>
            </tr>
        `;
    }).join("");
}

function renderUrgentStock(stockList) {
    const list = document.getElementById("dashUrgentStockList");
    if (!list) return;

    if (!stockList || stockList.length === 0) {
        list.innerHTML = '<li class="list-group-item text-center text-success py-3"><i class="bi bi-check-circle me-1"></i> All stock levels healthy</li>';
        return;
    }

    list.innerHTML = stockList.map(item => `
        <li class="list-group-item d-flex align-items-center justify-content-between py-2 border-0 border-bottom">
            <div>
                <div class="fw-bold text-dark mb-0">${item.ProductName}</div>
                <small class="text-muted"><i class="bi bi-building me-1"></i>${item.WarehouseName} (${item.ProductCode})</small>
            </div>
            <div class="text-end">
                <span class="badge bg-danger mb-1">${item.CurrentStock} / ${item.ReorderLevel} Qty</span>
                <div><small class="text-muted">Low Stock</small></div>
            </div>
        </li>
    `).join("");
}