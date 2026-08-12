let transfersTableInstance = null;

async function loadTransfers() {
    try {
        const data = await api.get("/transfers/");
        const columns = [
            { data: "TransferNumber" },
            { 
                data: "TransferDate", 
                render: data => data ? new Date(data).toLocaleDateString() : "-"
            },
            { data: "ProductName" },
            { data: "FromWarehouse" },
            { data: "ToWarehouse" },
            { data: "Quantity" },
            { 
                data: "Status",
                render: function(data) {
                    let color = "secondary";
                    if (data === "Completed") color = "success";
                    if (data === "Pending") color = "warning text-dark";
                    if (data === "Cancelled") color = "danger";
                    return `<span class="badge bg-${color}">${data}</span>`;
                }
            },
            { data: "RequestedBy" },
            {
                data: null,
                className: "text-end",
                orderable: false,
                render: function(row) {
                    if (row.Status === "Pending") {
                        return `
                            <button class="btn btn-sm btn-success" onclick="window.approveTransfer(${row.TransferID})" title="Approve Transfer">
                                <i class="bi bi-check-circle"></i> Approve
                            </button>
                        `;
                    }
                    return "-";
                }
            }
        ];

        transfersTableInstance = updateOrInitDataTable("#transfersTable", transfersTableInstance, data, columns, {
            buttons: getDTExportButtons("Stock Transfers", "transfers")
        });

    } catch (error) {
        showToast("Error loading transfers: " + error.message, "danger");
    }
}

window.openCreateTransferModal = async function() {
    try {
        const products = await api.get("/products/");
        const warehouses = await api.get("/warehouse/");
        
        let pSelect = document.getElementById("transferProduct");
        let fSelect = document.getElementById("transferFrom");
        let tSelect = document.getElementById("transferTo");
        
        pSelect.innerHTML = products.map(p => `<option value="${p.ProductID}">${p.ProductName} (${p.ProductCode})</option>`).join('');
        const wOptions = warehouses.map(w => `<option value="${w.WarehouseId}">${w.WarehouseName}</option>`).join('');
        fSelect.innerHTML = wOptions;
        tSelect.innerHTML = wOptions;
        
        document.getElementById("transferQty").value = "1";
        document.getElementById("transferNotes").value = "";
        
        new bootstrap.Modal(document.getElementById("transferModal")).show();
    } catch (error) {
        showToast("Failed to load dependencies: " + error.message, "danger");
    }
};

window.saveTransfer = async function() {
    const payload = {
        ProductID: parseInt(document.getElementById("transferProduct").value),
        FromWarehouseID: parseInt(document.getElementById("transferFrom").value),
        ToWarehouseID: parseInt(document.getElementById("transferTo").value),
        Quantity: parseInt(document.getElementById("transferQty").value),
        Notes: document.getElementById("transferNotes").value
    };
    
    if (payload.FromWarehouseID === payload.ToWarehouseID) {
        showToast("Source and destination warehouse cannot be the same.", "danger");
        return;
    }
    
    if (payload.Quantity < 1) {
        showToast("Quantity must be greater than zero.", "danger");
        return;
    }
    
    try {
        await api.post("/transfers/", payload);
        bootstrap.Modal.getInstance(document.getElementById("transferModal")).hide();
        showToast("Stock transfer requested successfully!", "success");
        await loadTransfers();
    } catch (error) {
        showToast("Failed to create transfer: " + error.message, "danger");
    }
};

window.approveTransfer = async function(id) {
    if(confirm("Are you sure you want to approve this stock transfer? This will immediately move the inventory.")) {
        try {
            await api.put(`/transfers/${id}/approve`, {});
            showToast("Transfer approved & inventory updated!", "success");
            await loadTransfers();
        } catch (error) {
            showToast("Failed to approve transfer: " + error.message, "danger");
        }
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
