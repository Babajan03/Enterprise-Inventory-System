let supplierTable = null;

async function loadSuppliers() {
    try {
        const data = await api.get("/suppliers/");
        const columns = [
            { data: "SupplierCode" },
            { data: "SupplierName" },
            { data: "ContactPerson" },
            { data: "Email" },
            { data: "Phone" },
            { data: "City" },
            { data: "GSTNumber" },
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
                        onclick="window.editSupplier(${row.SupplierID})">Edit</button>
                    <button class="btn btn-danger btn-sm ms-1"
                        onclick="window.deleteSupplier(${row.SupplierID})">Delete</button>
                `
            }
        ];
        supplierTable = updateOrInitDataTable("#supplierTable", supplierTable, data, columns, {
            buttons: getDTExportButtons("Suppliers List", "suppliers")
        });
    } catch (err) {
        showToast("Failed to load suppliers: " + err.message, "danger");
    }
}

window.openAddSupplier = function() {
    document.getElementById("supplierModalTitle").textContent = "Add Supplier";
    ["supplierID","supplierCode","supplierName","contactPerson",
     "supplierEmail","supplierPhone","gstNumber","addressLine1",
     "city","stateName","countryName","postalCode"].forEach(id => {
        document.getElementById(id).value = "";
    });
    document.getElementById("supplierCode").value = "SUP-" + Date.now().toString().slice(-6);
    document.getElementById("supplierIsActive").value = "1";
    new bootstrap.Modal(document.getElementById("supplierModal")).show();
};

window.editSupplier = async function(id) {
    try {
        const s = await api.get(`/suppliers/${id}`);
        document.getElementById("supplierModalTitle").textContent = "Edit Supplier";
        document.getElementById("supplierID").value = s.SupplierID;
        document.getElementById("supplierCode").value = s.SupplierCode || "";
        document.getElementById("supplierName").value = s.SupplierName || "";
        document.getElementById("contactPerson").value = s.ContactPerson || "";
        document.getElementById("supplierEmail").value = s.Email || "";
        document.getElementById("supplierPhone").value = s.Phone || "";
        document.getElementById("gstNumber").value = s.GSTNumber || "";
        document.getElementById("addressLine1").value = s.AddressLine1 || "";
        document.getElementById("city").value = s.City || "";
        document.getElementById("stateName").value = s.StateName || "";
        document.getElementById("countryName").value = s.CountryName || "";
        document.getElementById("postalCode").value = s.PostalCode || "";
        document.getElementById("supplierIsActive").value = s.IsActive ? "1" : "0";
        new bootstrap.Modal(document.getElementById("supplierModal")).show();
    } catch (err) {
        showToast("Failed to fetch supplier details: " + err.message, "danger");
    }
};

window.saveSupplier = async function() {
    const id = document.getElementById("supplierID").value;
    const payload = {
        SupplierCode: document.getElementById("supplierCode").value,
        SupplierName: document.getElementById("supplierName").value,
        ContactPerson: document.getElementById("contactPerson").value,
        Email: document.getElementById("supplierEmail").value,
        Phone: document.getElementById("supplierPhone").value,
        GSTNumber: document.getElementById("gstNumber").value,
        AddressLine1: document.getElementById("addressLine1").value,
        City: document.getElementById("city").value,
        StateName: document.getElementById("stateName").value,
        CountryName: document.getElementById("countryName").value,
        PostalCode: document.getElementById("postalCode").value,
        IsActive: document.getElementById("supplierIsActive").value === "1"
    };
    try {
        if (id) {
            await api.put(`/suppliers/${id}`, payload);
            showToast("Supplier updated successfully!", "success");
        } else {
            await api.post("/suppliers/", payload);
            showToast("Supplier created successfully!", "success");
        }
        bootstrap.Modal.getInstance(document.getElementById("supplierModal")).hide();
        await loadSuppliers();
    } catch (err) {
        showToast("Error: " + err.message, "danger");
    }
};

window.deleteSupplier = async function(id) {
    if (!confirm("Delete this supplier?")) return;
    try {
        await api.delete(`/suppliers/${id}`);
        showToast("Supplier deleted successfully!", "success");
        loadSuppliers();
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