let salesTable = null;
let currentSalesOrderId = null;

async function loadSales() {
    try {
        const data = await api.get("/sales/");
        const columns = [
            { data: "OrderNumber" },
            { data: "CustomerName" },
            {
                data: "OrderDate",
                render: v => v ? new Date(v).toLocaleDateString() : "-"
            },
            {
                data: "OrderStatus",
                render: v => {
                    const colors = {
                        Draft: "secondary", Confirmed: "primary",
                        Shipped: "info", Delivered: "success",
                        Cancelled: "danger"
                    };
                    return `<span class="badge bg-${colors[v] || 'secondary'}">${v}</span>`;
                }
            },
            {
                data: "TotalAmount",
                render: v => "₹ " + parseFloat(v || 0).toFixed(2)
            },
            {
                data: null,
                orderable: false,
                render: row => {
                    let btns = `
                        <button class="btn btn-info btn-sm"
                            onclick="window.viewSalesItems(${row.SalesOrderId}, '${row.OrderNumber}')">
                            <i class="bi bi-list-ul"></i> Items
                        </button>`;
                    if (row.OrderStatus === 'Draft') {
                        btns += `
                        <button class="btn btn-success btn-sm ms-1"
                            onclick="window.updateSalesStatus(${row.SalesOrderId}, 'Confirmed')">
                            <i class="bi bi-check-circle"></i> Confirm
                        </button>`;
                    }
                    if (row.OrderStatus === 'Confirmed') {
                        btns += `
                        <button class="btn btn-primary btn-sm ms-1"
                            onclick="window.updateSalesStatus(${row.SalesOrderId}, 'Shipped')">
                            <i class="bi bi-truck"></i> Ship
                        </button>`;
                    }
                    return btns;
                }
            }
        ];
        salesTable = updateOrInitDataTable("#salesTable", salesTable, data, columns, {
            buttons: getDTExportButtons("Sales Orders", "sales_orders")
        });
    } catch (err) {
        showToast("Failed to load sales orders: " + err.message, "danger");
    }
}

window.openCreateSalesOrder = async function() {
    try {
        const customers = await api.get("/customers/");
        const select = document.getElementById("soCustomer");
        select.innerHTML = customers.map(c =>
            `<option value="${c.CustomerId}">${c.CustomerName}</option>`
        ).join("");
        document.getElementById("soNumber").value = "Auto-generated";
        document.getElementById("soNumber").disabled = true;
        const today = new Date().toISOString().split("T")[0];
        document.getElementById("soOrderDate").value = today;
        document.getElementById("soStatus").value = "Draft";
        new bootstrap.Modal(document.getElementById("salesModal")).show();
    } catch (err) {
        showToast("Failed to load customers: " + err.message, "danger");
    }
};

window.saveSalesOrder = async function() {
    const btn = event.target;
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Creating...';
    try {
        const payload = {
            CustomerId: document.getElementById("soCustomer").value
        };
        const result = await api.post("/sales/", payload);
        bootstrap.Modal.getInstance(document.getElementById("salesModal")).hide();
        showToast("Sales Order created successfully!", "success");
        await loadSales();
        if (result.SalesOrderId) {
            setTimeout(() => window.viewSalesItems(result.SalesOrderId, result.OrderNumber), 500);
        }
    } catch (err) {
        showToast("Failed to create Sales Order: " + err.message, "danger");
    } finally {
        btn.disabled = false;
        btn.innerHTML = 'Create';
    }
};

window.viewSalesItems = async function(orderId, orderNumber) {
    currentSalesOrderId = orderId;
    document.getElementById("salesItemsTitle").textContent = "Items - " + orderNumber;
    try {
        const products = await api.get("/products/");
        const select = document.getElementById("soItemProduct");
        select.innerHTML = products.map(p =>
            `<option value="${p.ProductID}">${p.ProductName}</option>`
        ).join("");
        const items = await api.get(`/sales/${orderId}/items`);
        renderSalesItems(items);
        new bootstrap.Modal(document.getElementById("salesItemsModal")).show();
    } catch (err) {
        showToast("Failed to load items: " + err.message, "danger");
    }
};

function renderSalesItems(items) {
    const tbody = document.getElementById("salesItemsBody");
    tbody.innerHTML = items.length === 0
        ? `<tr><td colspan="4" class="text-center text-muted">No items yet — add products above</td></tr>`
        : items.map(i => `
            <tr>
                <td>${i.ProductName}</td>
                <td>${i.Quantity}</td>
                <td>₹${parseFloat(i.UnitPrice || 0).toFixed(2)}</td>
                <td><strong>₹${parseFloat(i.TotalPrice || 0).toFixed(2)}</strong></td>
            </tr>
        `).join("");
}

window.addSalesItem = async function() {
    const btn = event.target;
    btn.disabled = true;
    try {
        const payload = {
            ProductId: document.getElementById("soItemProduct").value,
            Quantity: document.getElementById("soItemQty").value,
            UnitPrice: document.getElementById("soItemPrice").value
        };
        await api.post(`/sales/${currentSalesOrderId}/items`, payload);
        const items = await api.get(`/sales/${currentSalesOrderId}/items`);
        renderSalesItems(items);
        document.getElementById("soItemQty").value = "";
        document.getElementById("soItemPrice").value = "";
        showToast("Item added successfully!", "success");
        await loadSales();
    } catch (err) {
        showToast("Failed to add item: " + err.message, "danger");
    } finally {
        btn.disabled = false;
    }
};

window.updateSalesStatus = async function(orderId, status) {
    if (!confirm(`Mark this order as ${status}?`)) return;
    try {
        await api.put(`/sales/${orderId}/status`, { OrderStatus: status });
        showToast(`Order marked as ${status}`, "success");
        await loadSales();
    } catch (err) {
        showToast("Failed to update status: " + err.message, "danger");
    }
};

// Toast notification helper
function showToast(message, type = "success") {
    const existing = document.getElementById("appToast");
    if (existing) existing.remove();
    const toast = document.createElement("div");
    toast.id = "appToast";
    toast.className = `alert alert-${type} position-fixed shadow-lg`;
    toast.style.cssText = "top:20px;right:20px;z-index:9999;min-width:300px;animation:slideIn 0.3s ease;";
    toast.innerHTML = `
        <div class="d-flex align-items-center gap-2">
            <i class="bi ${type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill'}"></i>
            <span>${message}</span>
            <button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.remove()"></button>
        </div>
    `;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 4000);
}