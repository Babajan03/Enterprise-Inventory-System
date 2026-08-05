let transfersTableInstance;

async function loadTransfers() {
    try {
        if ($.fn.DataTable.isDataTable("#transfersTable")) {
            $("#transfersTable").DataTable().destroy();
        }

        const data = await api.get("/transfers/");

        transfersTableInstance = $("#transfersTable").DataTable({
            data: data,
            columns: [
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
                    render: function(row) {
                        if (row.Status === "Pending") {
                            return `
                                <button class="btn btn-sm btn-success" onclick="approveTransfer(${row.TransferID})" title="Approve Transfer">
                                    <i class="bi bi-check-circle"></i> Approve
                                </button>
                            `;
                        }
                        return "-";
                    }
                }
            ],
            responsive: true,
            order: [[1, 'desc']], // Order by Date descending
            buttons: getDTExportButtons("Stock Transfers", "transfers"),
            dom: defaultDTDom
        });

    } catch (error) {
        console.error("Error loading transfers:", error);
    }
}

async function openCreateTransferModal() {
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
        alert("Failed to load dependencies");
    }
}

async function saveTransfer() {
    const payload = {
        ProductID: parseInt(document.getElementById("transferProduct").value),
        FromWarehouseID: parseInt(document.getElementById("transferFrom").value),
        ToWarehouseID: parseInt(document.getElementById("transferTo").value),
        Quantity: parseInt(document.getElementById("transferQty").value),
        Notes: document.getElementById("transferNotes").value
    };
    
    if (payload.FromWarehouseID === payload.ToWarehouseID) {
        alert("Source and destination warehouse cannot be the same.");
        return;
    }
    
    if (payload.Quantity < 1) {
        alert("Quantity must be greater than zero.");
        return;
    }
    
    try {
        await api.post("/transfers/", payload);
        bootstrap.Modal.getInstance(document.getElementById("transferModal")).hide();
        loadTransfers();
    } catch (error) {
        alert("Failed to create transfer: " + error.message);
    }
}

async function approveTransfer(id) {
    if(confirm("Are you sure you want to approve this stock transfer? This will immediately move the inventory.")) {
        try {
            await api.put(`/transfers/${id}/approve`, {});
            loadTransfers();
        } catch (error) {
            alert("Failed to approve transfer: " + error.message);
        }
    }
}
