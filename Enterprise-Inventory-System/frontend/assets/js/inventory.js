let inventoryTable = null;
let inventoryDataCache = [];

async function loadInventory() {
    try {
        const data = await api.get("/inventory/");
        inventoryDataCache = data;
        const columns = [
            { data: "ProductCode" },
            { data: "ProductName" },
            { data: "WarehouseName" },
            { 
                data: "Quantity",
                render: (v, t, r) => {
                    const isLow = v <= (r.ReorderLevel || 0);
                    return isLow 
                        ? `<span class="badge bg-warning text-dark me-1"><i class="bi bi-exclamation-triangle"></i> Low</span> <strong>${v}</strong>`
                        : `<span class="badge bg-success text-white me-1"><i class="bi bi-check-circle"></i> OK</span> ${v}`;
                }
            },
            { data: "ReorderLevel" },
            {
                data: "LastUpdatedDate",
                render: v => v ? new Date(v).toLocaleDateString() : "-"
            },
            {
                data: null,
                orderable: false,
                className: "text-center",
                render: row => `
                    <button class="btn btn-warning btn-sm"
                        onclick="window.openAdjust(${row.InventoryId}, '${row.ProductName}', ${row.Quantity})">
                        <i class="bi bi-pencil-square"></i> Adjust
                    </button>
                    <button class="btn btn-success btn-sm ms-1"
                        onclick="window.openReceiveModalForItem(${row.InventoryId})">
                        <i class="bi bi-box-arrow-in-down"></i> Receive
                    </button>
                `
            }
        ];
        inventoryTable = updateOrInitDataTable("#inventoryTable", inventoryTable, data, columns, {
            buttons: getDTExportButtons("Inventory List", "inventory")
        });
    } catch (err) {
        showToast("Failed to load inventory: " + err.message, "danger");
    }
}

window.openAdjust = function(id, productName, currentQty) {
    document.getElementById("adjustInventoryID").value = id;
    document.getElementById("adjustProductName").value = productName;
    document.getElementById("adjustQuantity").value = currentQty;
    document.getElementById("adjustRemarks").value = "";
    new bootstrap.Modal(document.getElementById("adjustModal")).show();
};

window.saveAdjustment = async function() {
    const id = document.getElementById("adjustInventoryID").value;
    const payload = {
        Quantity: document.getElementById("adjustQuantity").value,
        Remarks: document.getElementById("adjustRemarks").value
    };
    try {
        await api.put(`/inventory/${id}/adjust`, payload);
        bootstrap.Modal.getInstance(document.getElementById("adjustModal")).hide();
        showToast("Inventory adjusted successfully!", "success");
        await loadInventory();
    } catch (err) {
        showToast("Error: " + err.message, "danger");
    }
};

window.openReceiveModal = function() {
    const select = document.getElementById("receiveInventoryItem");
    select.innerHTML = inventoryDataCache.map(i => 
        `<option value="${i.InventoryId}">${i.ProductName} (${i.ProductCode}) - ${i.WarehouseName} [Current Stock: ${i.Quantity}]</option>`
    ).join('');
    document.getElementById("receiveQuantity").value = "10";
    document.getElementById("receiveRef").value = "GRN-" + Date.now().toString().slice(-6);
    new bootstrap.Modal(document.getElementById("receiveModal")).show();
};

window.openReceiveModalForItem = function(inventoryId) {
    window.openReceiveModal();
    document.getElementById("receiveInventoryItem").value = inventoryId;
};

window.saveReceiveGoods = async function() {
    const payload = {
        InventoryId: parseInt(document.getElementById("receiveInventoryItem").value),
        Quantity: parseFloat(document.getElementById("receiveQuantity").value),
        ReferenceNumber: document.getElementById("receiveRef").value
    };

    if (!payload.Quantity || payload.Quantity <= 0) {
        showToast("Please enter a valid quantity greater than zero.", "danger");
        return;
    }

    try {
        await api.post("/inventory/receive", payload);
        bootstrap.Modal.getInstance(document.getElementById("receiveModal")).hide();
        showToast("Goods received & stock updated successfully!", "success");
        await loadInventory();
    } catch (err) {
        showToast("Error receiving goods: " + err.message, "danger");
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