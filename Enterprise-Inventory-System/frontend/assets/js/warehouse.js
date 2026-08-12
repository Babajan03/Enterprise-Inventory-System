let warehouseTable = null;

async function loadWarehouse() {
    try {
        const data = await api.get("/warehouse/");
        const columns = [
            { data: "WarehouseCode" },
            { data: "WarehouseName" },
            { data: "City" },
            { data: "State" },
            { data: "Country" },
            { data: "ContactPerson" },
            { data: "ContactNumber" },
            {
                data: "IsActive",
                render: v => v
                    ? `<span class="badge bg-success">Active</span>`
                    : `<span class="badge bg-danger">Inactive</span>`
            },
            {
                data: null,
                orderable: false,
                render: row => `
                    <button class="btn btn-warning btn-sm"
                        onclick="window.editWarehouse(${row.WarehouseId})">Edit</button>
                    <button class="btn btn-danger btn-sm ms-1"
                        onclick="window.deleteWarehouse(${row.WarehouseId})">Delete</button>
                `
            }
        ];
        warehouseTable = updateOrInitDataTable("#warehouseTable", warehouseTable, data, columns, {
            buttons: getDTExportButtons("Warehouse List", "warehouse")
        });
    } catch (err) {
        showToast("Failed to load warehouse data: " + err.message, "danger");
    }
}

window.openAddWarehouse = function() {
    document.getElementById("warehouseModalTitle").textContent = "Add Warehouse";
    ["warehouseID","warehouseCode","warehouseName","warehouseAddress",
     "warehouseCity","warehouseState","warehouseCountry","warehousePostalCode",
     "warehouseContactPerson","warehouseContactNumber"].forEach(id => {
        document.getElementById(id).value = "";
    });
    document.getElementById("warehouseCode").value = "WH-" + Date.now().toString().slice(-6);
    document.getElementById("warehouseIsActive").value = "1";
    new bootstrap.Modal(document.getElementById("warehouseModal")).show();
};

window.editWarehouse = async function(id) {
    try {
        const w = await api.get(`/warehouse/${id}`);
        document.getElementById("warehouseModalTitle").textContent = "Edit Warehouse";
        document.getElementById("warehouseID").value = w.WarehouseId;
        document.getElementById("warehouseCode").value = w.WarehouseCode || "";
        document.getElementById("warehouseName").value = w.WarehouseName || "";
        document.getElementById("warehouseAddress").value = w.AddressLine1 || "";
        document.getElementById("warehouseCity").value = w.City || "";
        document.getElementById("warehouseState").value = w.State || "";
        document.getElementById("warehouseCountry").value = w.Country || "";
        document.getElementById("warehousePostalCode").value = w.PostalCode || "";
        document.getElementById("warehouseContactPerson").value = w.ContactPerson || "";
        document.getElementById("warehouseContactNumber").value = w.ContactNumber || "";
        document.getElementById("warehouseIsActive").value = w.IsActive ? "1" : "0";
        new bootstrap.Modal(document.getElementById("warehouseModal")).show();
    } catch (err) {
        showToast("Failed to fetch warehouse details: " + err.message, "danger");
    }
};

window.saveWarehouse = async function() {
    const id = document.getElementById("warehouseID").value;
    const payload = {
        WarehouseCode: document.getElementById("warehouseCode").value,
        WarehouseName: document.getElementById("warehouseName").value,
        AddressLine1: document.getElementById("warehouseAddress").value,
        City: document.getElementById("warehouseCity").value,
        State: document.getElementById("warehouseState").value,
        Country: document.getElementById("warehouseCountry").value,
        PostalCode: document.getElementById("warehousePostalCode").value,
        ContactPerson: document.getElementById("warehouseContactPerson").value,
        ContactNumber: document.getElementById("warehouseContactNumber").value,
        IsActive: document.getElementById("warehouseIsActive").value === "1"
    };
    try {
        if (id) {
            await api.put(`/warehouse/${id}`, payload);
            showToast("Warehouse updated successfully!", "success");
        } else {
            await api.post("/warehouse/", payload);
            showToast("Warehouse created successfully!", "success");
        }
        bootstrap.Modal.getInstance(document.getElementById("warehouseModal")).hide();
        await loadWarehouse();
    } catch (err) {
        showToast("Error: " + err.message, "danger");
    }
};

window.deleteWarehouse = async function(id) {
    if (!confirm("Delete this warehouse?")) return;
    try {
        await api.delete(`/warehouse/${id}`);
        showToast("Warehouse deleted successfully!", "success");
        loadWarehouse();
    } catch (err) {
        showToast("Error: " + err.message, "danger");
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