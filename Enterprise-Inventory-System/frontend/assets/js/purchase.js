let purchaseTable;
let currentOrderId = null;

async function loadPurchase() {
    if ($.fn.DataTable.isDataTable("#purchaseTable")) {
        purchaseTable.destroy();
    }
    const data = await api.get("/purchase/");
    purchaseTable = $("#purchaseTable").DataTable({
        data: data,
        responsive: true,
        columns: [
            { data: "PurchaseOrderNumber" },
            { data: "SupplierName" },
            { data: "OrderDate" },
            { data: "ExpectedDeliveryDate" },
            {
                data: "TotalAmount",
                render: v => "₹ " + parseFloat(v).toFixed(2)
            },
            {
                data: "Status",
                render: v => {
                    const colors = {
                        Draft: "secondary", Approved: "primary",
                        Received: "success", Cancelled: "danger"
                    };
                    return `<span class="badge bg-${colors[v] || 'secondary'}">${v}</span>`;
                }
            },
            {
                data: null,
                render: row => `
                    <button class="btn btn-info btn-sm"
                        onclick="viewItems(${row.PurchaseOrderID}, '${row.PurchaseOrderNumber}')">
                        Items
                    </button>
                    <button class="btn btn-success btn-sm ms-1"
                        onclick="updateStatus(${row.PurchaseOrderID}, 'Approved')">
                        Approve
                    </button>
                `
            }
        ]
    });
}

async function openCreateOrder() {
    const suppliers = await api.get("/suppliers/");
    const select = document.getElementById("poSupplier");
    select.innerHTML = suppliers.map(s =>
        `<option value="${s.SupplierID}">${s.SupplierName}</option>`
    ).join("");
    const today = new Date().toISOString().split("T")[0];
    document.getElementById("poOrderDate").value = today;
    document.getElementById("poDeliveryDate").value = today;
    document.getElementById("poNumber").value = "PO-" + Date.now();
    document.getElementById("poRemarks").value = "";
    new bootstrap.Modal(document.getElementById("purchaseModal")).show();
}

async function savePurchaseOrder() {
    const payload = {
        PurchaseOrderNumber: document.getElementById("poNumber").value,
        SupplierID: document.getElementById("poSupplier").value,
        OrderDate: document.getElementById("poOrderDate").value,
        ExpectedDeliveryDate: document.getElementById("poDeliveryDate").value,
        Remarks: document.getElementById("poRemarks").value
    };
    const result = await api.post("/purchase/", payload);
    bootstrap.Modal.getInstance(document.getElementById("purchaseModal")).hide();
    loadPurchase();
    if (result.PurchaseOrderID) {
        viewItems(result.PurchaseOrderID, payload.PurchaseOrderNumber);
    }
}

async function viewItems(orderId, orderNumber) {
    currentOrderId = orderId;
    document.getElementById("itemsModalTitle").textContent = "Items - " + orderNumber;

    const products = await api.get("/products/");
    const select = document.getElementById("itemProduct");
    select.innerHTML = products.map(p =>
        `<option value="${p.ProductID}">${p.ProductName}</option>`
    ).join("");

    const items = await api.get(`/purchase/${orderId}/items`);
    const tbody = document.getElementById("itemsTableBody");
    tbody.innerHTML = items.map(i => `
        <tr>
            <td>${i.ProductName}</td>
            <td>${i.OrderedQuantity}</td>
            <td>₹${i.UnitPrice}</td>
            <td>₹${i.DiscountAmount}</td>
            <td>₹${i.TaxAmount}</td>
            <td>₹${i.LineTotal}</td>
        </tr>
    `).join("");

    new bootstrap.Modal(document.getElementById("itemsModal")).show();
}

async function addOrderItem() {
    const payload = {
        ProductID: document.getElementById("itemProduct").value,
        OrderedQuantity: document.getElementById("itemQty").value,
        UnitPrice: document.getElementById("itemPrice").value,
        DiscountAmount: document.getElementById("itemDiscount").value || 0,
        TaxAmount: document.getElementById("itemTax").value || 0
    };
    await api.post(`/purchase/${currentOrderId}/items`, payload);
    const items = await api.get(`/purchase/${currentOrderId}/items`);
    const tbody = document.getElementById("itemsTableBody");
    tbody.innerHTML = items.map(i => `
        <tr>
            <td>${i.ProductName}</td>
            <td>${i.OrderedQuantity}</td>
            <td>₹${i.UnitPrice}</td>
            <td>₹${i.DiscountAmount}</td>
            <td>₹${i.TaxAmount}</td>
            <td>₹${i.LineTotal}</td>
        </tr>
    `).join("");
}

async function updateStatus(orderId, status) {
    if (!confirm(`Mark this order as ${status}?`)) return;
    await api.put(`/purchase/${orderId}/status`, { Status: status });
    loadPurchase();
}