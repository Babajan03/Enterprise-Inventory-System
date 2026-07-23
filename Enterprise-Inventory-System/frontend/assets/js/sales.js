let salesTable;
let currentSalesOrderId = null;

async function loadSales() {
    if ($.fn.DataTable.isDataTable("#salesTable")) {
        $("#salesTable").DataTable().destroy();
    }
    const data = await api.get("/sales/");
    salesTable = $("#salesTable").DataTable({
        data: data,
        responsive: true,
        columns: [
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
                render: row => `
                    <button class="btn btn-info btn-sm"
                        onclick="window.viewSalesItems(${row.SalesOrderId}, '${row.OrderNumber}')">
                        Items
                    </button>
                    <button class="btn btn-success btn-sm ms-1"
                        onclick="window.updateSalesStatus(${row.SalesOrderId}, 'Confirmed')">
                        Confirm
                    </button>
                `
            }
        ]
    });
}

window.openCreateSalesOrder = async function() {
    const customers = await api.get("/customers/");
    const select = document.getElementById("soCustomer");
    select.innerHTML = customers.map(c =>
        `<option value="${c.CustomerId}">${c.CustomerName}</option>`
    ).join("");
    const today = new Date().toISOString().split("T")[0];
    document.getElementById("soOrderDate").value = today;
    document.getElementById("soNumber").value = "SO-" + Date.now();
    document.getElementById("soStatus").value = "Draft";
    new bootstrap.Modal(document.getElementById("salesModal")).show();
};

window.saveSalesOrder = async function() {
    const payload = {
        OrderNumber: document.getElementById("soNumber").value,
        CustomerId: document.getElementById("soCustomer").value,
        OrderDate: document.getElementById("soOrderDate").value,
        OrderStatus: document.getElementById("soStatus").value
    };
    const result = await api.post("/sales/", payload);
    bootstrap.Modal.getInstance(document.getElementById("salesModal")).hide();
    loadSales();
    if (result.SalesOrderId) {
        setTimeout(() => window.viewSalesItems(result.SalesOrderId, payload.OrderNumber), 500);
    }
};

window.viewSalesItems = async function(orderId, orderNumber) {
    currentSalesOrderId = orderId;
    document.getElementById("salesItemsTitle").textContent = "Items - " + orderNumber;
    const products = await api.get("/products/");
    const select = document.getElementById("soItemProduct");
    select.innerHTML = products.map(p =>
        `<option value="${p.ProductID}">${p.ProductName}</option>`
    ).join("");
    const items = await api.get(`/sales/${orderId}/items`);
    renderSalesItems(items);
    new bootstrap.Modal(document.getElementById("salesItemsModal")).show();
};

function renderSalesItems(items) {
    const tbody = document.getElementById("salesItemsBody");
    tbody.innerHTML = items.length === 0
        ? `<tr><td colspan="4" class="text-center">No items yet</td></tr>`
        : items.map(i => `
            <tr>
                <td>${i.ProductName}</td>
                <td>${i.Quantity}</td>
                <td>₹${i.UnitPrice}</td>
                <td>₹${i.TotalPrice}</td>
            </tr>
        `).join("");
}

window.addSalesItem = async function() {
    const payload = {
        ProductId: document.getElementById("soItemProduct").value,
        Quantity: document.getElementById("soItemQty").value,
        UnitPrice: document.getElementById("soItemPrice").value
    };
    await api.post(`/sales/${currentSalesOrderId}/items`, payload);
    const items = await api.get(`/sales/${currentSalesOrderId}/items`);
    renderSalesItems(items);
};

window.updateSalesStatus = async function(orderId, status) {
    if (!confirm(`Mark this order as ${status}?`)) return;
    await api.put(`/sales/${orderId}/status`, { OrderStatus: status });
    loadSales();
};


window.openCreateSalesOrder = openCreateSalesOrder;
window.saveSalesOrder = saveSalesOrder;
window.viewSalesItems = viewSalesItems;
window.addSalesItem = addSalesItem;
window.updateSalesStatus = updateSalesStatus;