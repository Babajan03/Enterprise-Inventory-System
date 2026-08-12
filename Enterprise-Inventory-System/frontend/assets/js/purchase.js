let purchaseTable = null;
let currentOrderId = null;

async function loadPurchase() {
    try {
        const data = await api.get("/purchase/");
        const columns = [
            { data: "PurchaseOrderNumber" },
            { data: "SupplierName" },
            { data: "OrderDate" },
            { data: "ExpectedDeliveryDate" },
            {
                data: "TotalAmount",
                render: v => "₹ " + parseFloat(v || 0).toFixed(2)
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
                orderable: false,
                render: row => `
                    <button class="btn btn-info btn-sm"
                        onclick="window.viewItems(${row.PurchaseOrderID}, '${row.PurchaseOrderNumber}')">
                        <i class="bi bi-list-ul"></i> Items
                    </button>
                    ${row.Status === 'Draft' ? `
                    <button class="btn btn-success btn-sm ms-1"
                        onclick="window.updateStatus(${row.PurchaseOrderID}, 'Approved')">
                        <i class="bi bi-check-circle"></i> Approve
                    </button>` : ''}
                `
            }
        ];
        purchaseTable = updateOrInitDataTable("#purchaseTable", purchaseTable, data, columns, {
            buttons: getDTExportButtons("Purchase Orders", "purchase_orders")
        });
    } catch (err) {
        showToast("Failed to load purchase orders: " + err.message, "danger");
    }
}

window.openCreateOrder = async function() {
    try {
        const suppliers = await api.get("/suppliers/");
        const select = document.getElementById("poSupplier");
        select.innerHTML = suppliers.map(s =>
            `<option value="${s.SupplierID}">${s.SupplierName}</option>`
        ).join("");
        const today = new Date().toISOString().split("T")[0];
        document.getElementById("poOrderDate").value = today;
        document.getElementById("poDeliveryDate").value = "";
        document.getElementById("poNumber").value = "Auto-generated";
        document.getElementById("poNumber").disabled = true;
        document.getElementById("poRemarks").value = "";
        new bootstrap.Modal(document.getElementById("purchaseModal")).show();
    } catch (err) {
        showToast("Failed to load suppliers: " + err.message, "danger");
    }
};

window.savePurchaseOrder = async function() {
    const btn = event.target;
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Creating...';
    try {
        const payload = {
            SupplierID: document.getElementById("poSupplier").value,
            ExpectedDeliveryDate: document.getElementById("poDeliveryDate").value || null,
            Remarks: document.getElementById("poRemarks").value
        };
        const result = await api.post("/purchase/", payload);
        bootstrap.Modal.getInstance(document.getElementById("purchaseModal")).hide();
        showToast("Purchase Order created successfully!", "success");
        await loadPurchase();
        if (result.PurchaseOrderID) {
            setTimeout(() => window.viewItems(result.PurchaseOrderID, result.PurchaseOrderNumber), 500);
        }
    } catch (err) {
        showToast("Failed to create PO: " + err.message, "danger");
    } finally {
        btn.disabled = false;
        btn.innerHTML = 'Create';
    }
};

window.viewItems = async function(orderId, orderNumber) {
    currentOrderId = orderId;
    document.getElementById("itemsModalTitle").textContent = "Items - " + orderNumber;
    try {
        const products = await api.get("/products/");
        const select = document.getElementById("itemProduct");
        select.innerHTML = products.map(p =>
            `<option value="${p.ProductID}">${p.ProductName}</option>`
        ).join("");
        const items = await api.get(`/purchase/${orderId}/items`);
        renderItemsTable(items);
        new bootstrap.Modal(document.getElementById("itemsModal")).show();
    } catch (err) {
        showToast("Failed to load items: " + err.message, "danger");
    }
};

function renderItemsTable(items) {
    const tbody = document.getElementById("itemsTableBody");
    tbody.innerHTML = items.length === 0
        ? `<tr><td colspan="6" class="text-center text-muted">No items yet — add products above</td></tr>`
        : items.map(i => `
            <tr>
                <td>${i.ProductName}</td>
                <td>${i.OrderedQuantity}</td>
                <td>₹${parseFloat(i.UnitPrice || 0).toFixed(2)}</td>
                <td>₹${parseFloat(i.DiscountAmount || 0).toFixed(2)}</td>
                <td>₹${parseFloat(i.TaxAmount || 0).toFixed(2)}</td>
                <td><strong>₹${parseFloat(i.LineTotal || 0).toFixed(2)}</strong></td>
            </tr>
        `).join("");
}

window.addOrderItem = async function() {
    const btn = event.target;
    btn.disabled = true;
    try {
        const payload = {
            ProductID: document.getElementById("itemProduct").value,
            OrderedQuantity: document.getElementById("itemQty").value,
            UnitPrice: document.getElementById("itemPrice").value,
            DiscountAmount: document.getElementById("itemDiscount").value || 0,
            TaxAmount: document.getElementById("itemTax").value || 0
        };
        await api.post(`/purchase/${currentOrderId}/items`, payload);
        const items = await api.get(`/purchase/${currentOrderId}/items`);
        renderItemsTable(items);
        document.getElementById("itemQty").value = "";
        document.getElementById("itemPrice").value = "";
        document.getElementById("itemDiscount").value = "0";
        document.getElementById("itemTax").value = "0";
        showToast("Item added successfully!", "success");
        await loadPurchase();
    } catch (err) {
        showToast("Failed to add item: " + err.message, "danger");
    } finally {
        btn.disabled = false;
    }
};

window.updateStatus = async function(orderId, status) {
    if (!confirm(`Mark this order as ${status}?`)) return;
    try {
        await api.put(`/purchase/${orderId}/status`, { Status: status });
        showToast(`Order marked as ${status}`, "success");
        await loadPurchase();
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