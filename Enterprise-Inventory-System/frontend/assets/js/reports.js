/* ===== Report Charts & Tables — Full Logic ===== */

let reportChart = null;
let reportTable = null;

/* ---------- colour palette ---------- */
const CHART_COLORS = [
    "#4e73df", "#1cc88a", "#36b9cc", "#f6c23e",
    "#e74a3b", "#858796", "#5a5c69", "#2e59d9",
    "#17a673", "#2c9faf"
];

function currencyFmt(v) {
    return "₹ " + parseFloat(v || 0).toLocaleString("en-IN", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

/* ---------- main entry ---------- */
async function loadReports() {
    // default — show inventory on load
    showReport("inventory");
}

window.showReport = async function (type) {

    /* -- active tab styling -- */
    document.querySelectorAll("#reportTabs .nav-link").forEach(btn => btn.classList.remove("active"));
    const activeBtn = document.querySelector(`#reportTabs .nav-link[data-report="${type}"]`);
    if (activeBtn) activeBtn.classList.add("active");

    /* -- tear down previous DataTable -- */
    if ($.fn.DataTable.isDataTable("#reportTable")) {
        $("#reportTable").DataTable().destroy();
        document.getElementById("reportHead").innerHTML = "";
        document.getElementById("reportBody").innerHTML = "";
    }

    /* -- tear down previous Chart -- */
    if (reportChart) {
        reportChart.destroy();
        reportChart = null;
    }

    /* -- reset areas -- */
    document.getElementById("chartCard").style.display = "none";
    document.getElementById("summaryCards").style.display = "none";
    document.getElementById("summaryCards").innerHTML = "";
    document.getElementById("reportCount").style.display = "none";

    /* -- fetch data -- */
    let data;
    try {
        data = await api.get(`/reports/${type}`);
    } catch (err) {
        console.error("Report fetch error:", err);
        document.getElementById("reportTitle").innerHTML =
            '<i class="bi bi-exclamation-circle text-danger me-1"></i> Error loading report';
        return;
    }

    /* -- record count badge -- */
    const countBadge = document.getElementById("reportCount");
    countBadge.textContent = data.length + " records";
    countBadge.style.display = "inline";

    /* -- build report by type -- */
    let columns = [];
    let title = "";
    let chartTitle = "";

    switch (type) {

        /* ────────────── INVENTORY ────────────── */
        case "inventory":
            title = "Inventory Summary";
            columns = [
                { data: "ProductCode", title: "Code" },
                { data: "ProductName", title: "Product" },
                { data: "WarehouseName", title: "Warehouse" },
                { data: "Quantity", title: "Qty" },
                { data: "ReorderLevel", title: "Reorder Lvl" },
                {
                    data: "StockStatus", title: "Status",
                    render: v => v === "Low Stock"
                        ? '<span class="badge bg-danger"><i class="bi bi-exclamation-circle me-1"></i>Low Stock</span>'
                        : '<span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>OK</span>'
                }
            ];
            break;

        /* ────────────── SALES SUMMARY ────────────── */
        case "sales":
            title = "Sales Summary — by Customer";
            columns = [
                { data: "CustomerName", title: "Customer" },
                { data: "TotalOrders", title: "Orders" },
                { data: "TotalRevenue", title: "Revenue", render: v => currencyFmt(v) }
            ];
            break;

        /* ────────────── PURCHASE SUMMARY ────────────── */
        case "purchase":
            title = "Purchase Summary — by Supplier";
            columns = [
                { data: "SupplierName", title: "Supplier" },
                { data: "TotalOrders", title: "Orders" },
                { data: "TotalSpend", title: "Spend", render: v => currencyFmt(v) }
            ];
            break;

        /* ────────────── MONTHLY SALES TRENDS ────────────── */
        case "monthly-sales":
            title = "Monthly Sales Trends — Last 12 Months";
            chartTitle = "Revenue & Orders Over Time";
            columns = [
                { data: "MonthLabel", title: "Month" },
                { data: "TotalOrders", title: "Orders" },
                { data: "TotalUnitsSold", title: "Units Sold" },
                { data: "TotalRevenue", title: "Revenue", render: v => currencyFmt(v) }
            ];

            /* Summary Cards */
            if (data.length > 0) {
                const totalRev = data.reduce((s, r) => s + parseFloat(r.TotalRevenue || 0), 0);
                const totalOrd = data.reduce((s, r) => s + (r.TotalOrders || 0), 0);
                const avgMonthly = totalRev / data.length;
                renderSummaryCards([
                    { label: "Total Revenue", value: currencyFmt(totalRev), icon: "bi-currency-rupee", color: "#4e73df" },
                    { label: "Total Orders", value: totalOrd, icon: "bi-bag-check", color: "#1cc88a" },
                    { label: "Avg Monthly", value: currencyFmt(avgMonthly), icon: "bi-bar-chart-line", color: "#36b9cc" },
                    { label: "Months Covered", value: data.length, icon: "bi-calendar3", color: "#f6c23e" }
                ]);
            }

            /* Line + Bar Combo Chart */
            renderChart(chartTitle, "bar", {
                labels: data.map(r => r.MonthLabel),
                datasets: [
                    {
                        label: "Revenue (₹)",
                        data: data.map(r => r.TotalRevenue),
                        backgroundColor: "rgba(78,115,223,0.15)",
                        borderColor: "#4e73df",
                        borderWidth: 2,
                        type: "line",
                        tension: 0.3,
                        fill: true,
                        yAxisID: "y"
                    },
                    {
                        label: "Orders",
                        data: data.map(r => r.TotalOrders),
                        backgroundColor: "#1cc88a",
                        borderRadius: 6,
                        yAxisID: "y1"
                    }
                ]
            }, {
                y: { position: "left", title: { display: true, text: "Revenue (₹)" } },
                y1: { position: "right", title: { display: true, text: "Orders" }, grid: { drawOnChartArea: false } }
            });
            break;

        /* ────────────── TOP PRODUCTS ────────────── */
        case "top-products":
            title = "Top 10 Selling Products";
            chartTitle = "Top Products by Revenue";
            columns = [
                { data: "ProductCode", title: "Code" },
                { data: "ProductName", title: "Product" },
                { data: "CategoryName", title: "Category" },
                { data: "TotalQuantitySold", title: "Qty Sold" },
                { data: "TotalRevenue", title: "Revenue", render: v => currencyFmt(v) }
            ];

            /* Horizontal Bar Chart */
            renderChart(chartTitle, "bar", {
                labels: data.map(r => r.ProductName),
                datasets: [{
                    label: "Revenue (₹)",
                    data: data.map(r => r.TotalRevenue),
                    backgroundColor: CHART_COLORS.slice(0, data.length),
                    borderRadius: 6
                }]
            }, null, { indexAxis: "y" });
            break;

        /* ────────────── CATEGORY SALES ────────────── */
        case "category-sales":
            title = "Category-wise Sales Breakdown";
            chartTitle = "Revenue Share by Category";
            columns = [
                { data: "CategoryName", title: "Category" },
                { data: "TotalProducts", title: "Products" },
                { data: "TotalQuantitySold", title: "Qty Sold" },
                { data: "TotalRevenue", title: "Revenue", render: v => currencyFmt(v) }
            ];

            /* Doughnut Chart */
            renderChart(chartTitle, "doughnut", {
                labels: data.map(r => r.CategoryName),
                datasets: [{
                    data: data.map(r => r.TotalRevenue),
                    backgroundColor: CHART_COLORS.slice(0, data.length),
                    hoverOffset: 8,
                    borderWidth: 2
                }]
            }, null, null, true);
            break;

        /* ────────────── LOW STOCK ────────────── */
        case "low-stock":
            title = "Low Stock Alert";
            columns = [
                { data: "ProductCode", title: "Code" },
                { data: "ProductName", title: "Product" },
                { data: "WarehouseName", title: "Warehouse" },
                {
                    data: "CurrentStock", title: "Current Stock",
                    render: v => `<span class="text-danger fw-bold">${v}</span>`
                },
                { data: "ReorderLevel", title: "Reorder Level" },
                {
                    data: "RequiredQuantity", title: "Needed",
                    render: v => `<span class="badge bg-warning text-dark">${v} units</span>`
                }
            ];

            /* Summary Cards */
            if (data.length > 0) {
                const totalNeeded = data.reduce((s, r) => s + parseFloat(r.RequiredQuantity || 0), 0);
                renderSummaryCards([
                    { label: "Items Below Reorder", value: data.length, icon: "bi-exclamation-triangle", color: "#e74a3b" },
                    { label: "Total Units Needed", value: Math.round(totalNeeded), icon: "bi-box-seam", color: "#f6c23e" }
                ]);
            }
            break;

        /* ────────────── PRODUCT MOVEMENT ────────────── */
        case "product-movement":
            title = "Product Movement History";
            columns = [
                { data: "ProductCode", title: "Code" },
                { data: "ProductName", title: "Product" },
                {
                    data: "TransactionType", title: "Type",
                    render: v => {
                        const colors = {
                            "PURCHASE": "primary", "SALE": "success",
                            "ADJUSTMENT": "warning", "TRANSFER": "info"
                        };
                        return `<span class="badge bg-${colors[v] || "secondary"}">${v}</span>`;
                    }
                },
                { data: "Quantity", title: "Qty" },
                {
                    data: "TransactionDate", title: "Date",
                    render: v => v ? new Date(v).toLocaleDateString("en-IN", {
                        day: "2-digit", month: "short", year: "numeric"
                    }) : "-"
                },
                { data: "Remarks", title: "Remarks", render: v => v || "-" }
            ];
            break;
    }

    /* -- set title -- */
    document.getElementById("reportTitle").innerHTML =
        `<i class="bi bi-table me-1"></i> ${title}`;

    /* -- initialize DataTable with Export Buttons -- */
    reportTable = $("#reportTable").DataTable({
        data: data,
        columns: columns,
        responsive: true,
        destroy: true,
        pageLength: 10,
        lengthMenu: [10, 25, 50, 100],
        order: [],
        buttons: getDTExportButtons(title, type + "_report"),
        language: {
            emptyTable: "No data available for this report",
            search: '<i class="bi bi-search"></i>',
            searchPlaceholder: "Filter records..."
        },
        dom: '<"d-flex flex-wrap align-items-center justify-content-between gap-2 mb-3"<"d-flex align-items-center gap-2"lB>f>rt<"d-flex justify-content-between align-items-center mt-3"ip>'
    });
};


/* ==================== CHART HELPER ==================== */
function renderChart(title, chartType, chartData, scales, extraOpts, isDoughnut) {
    document.getElementById("chartCard").style.display = "block";
    document.getElementById("chartTitle").textContent = title;

    const ctx = document.getElementById("reportChart").getContext("2d");

    const options = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: isDoughnut ? "right" : "top",
                labels: {
                    padding: 16,
                    usePointStyle: true,
                    pointStyleWidth: 12,
                    font: { size: 12, family: "'Segoe UI', sans-serif" }
                }
            },
            tooltip: {
                backgroundColor: "rgba(0,0,0,0.8)",
                titleFont: { size: 13 },
                bodyFont: { size: 12 },
                padding: 12,
                cornerRadius: 8,
                callbacks: {
                    label: function (context) {
                        let label = context.dataset.label || context.label || "";
                        let value = context.parsed.y ?? context.parsed ?? context.raw;
                        if (typeof value === "number" && !isDoughnut) {
                            return label + ": " + currencyFmt(value);
                        }
                        if (isDoughnut) {
                            return label + ": " + currencyFmt(context.raw);
                        }
                        return label + ": " + value;
                    }
                }
            }
        },
        ...(extraOpts || {})
    };

    if (scales) {
        options.scales = scales;
    } else if (!isDoughnut) {
        options.scales = {
            y: { beginAtZero: true }
        };
    }

    reportChart = new Chart(ctx, {
        type: chartType,
        data: chartData,
        options: options
    });
}


/* ==================== SUMMARY CARDS HELPER ==================== */
function renderSummaryCards(cards) {
    const container = document.getElementById("summaryCards");
    container.style.display = "flex";

    container.innerHTML = cards.map(c => `
        <div class="col-lg-3 col-md-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="rounded-circle d-flex align-items-center justify-content-center me-3"
                         style="width:48px;height:48px;background:${c.color}15;">
                        <i class="bi ${c.icon} fs-4" style="color:${c.color}"></i>
                    </div>
                    <div>
                        <small class="text-muted">${c.label}</small>
                        <h5 class="mb-0 fw-bold">${c.value}</h5>
                    </div>
                </div>
            </div>
        </div>
    `).join("");
}