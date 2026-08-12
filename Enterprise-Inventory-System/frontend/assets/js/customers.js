let customerTable = null;

async function loadCustomers() {
    try {
        const data = await api.get("/customers/");
        const columns = [
            { data: "CustomerCode" },
            { data: "CustomerName" },
            { data: "Email" },
            { data: "PhoneNumber" },
            { data: "City" },
            { data: "State" },
            { data: "Country" },
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
                        onclick="window.editCustomer(${row.CustomerId})">Edit</button>
                    <button class="btn btn-danger btn-sm ms-1"
                        onclick="window.deleteCustomer(${row.CustomerId})">Delete</button>
                `
            }
        ];
        customerTable = updateOrInitDataTable("#customerTable", customerTable, data, columns, {
            buttons: getDTExportButtons("Customers List", "customers")
        });
    } catch (err) {
        showToast("Failed to load customers: " + err.message, "danger");
    }
}

window.openAddCustomer = function() {
    document.getElementById("customerModalTitle").textContent = "Add Customer";
    ["customerID","customerCode","customerName","customerEmail",
     "customerPhone","customerAddress","customerCity","customerState",
     "customerCountry","customerPostalCode"].forEach(id => {
        document.getElementById(id).value = "";
    });
    document.getElementById("customerCode").value = "CUST-" + Date.now().toString().slice(-6);
    document.getElementById("customerIsActive").value = "1";
    new bootstrap.Modal(document.getElementById("customerModal")).show();
};

window.editCustomer = async function(id) {
    try {
        const c = await api.get(`/customers/${id}`);
        document.getElementById("customerModalTitle").textContent = "Edit Customer";
        document.getElementById("customerID").value = c.CustomerId;
        document.getElementById("customerCode").value = c.CustomerCode || "";
        document.getElementById("customerName").value = c.CustomerName || "";
        document.getElementById("customerEmail").value = c.Email || "";
        document.getElementById("customerPhone").value = c.PhoneNumber || "";
        document.getElementById("customerAddress").value = c.AddressLine1 || "";
        document.getElementById("customerCity").value = c.City || "";
        document.getElementById("customerState").value = c.State || "";
        document.getElementById("customerCountry").value = c.Country || "";
        document.getElementById("customerPostalCode").value = c.PostalCode || "";
        document.getElementById("customerIsActive").value = c.IsActive ? "1" : "0";
        new bootstrap.Modal(document.getElementById("customerModal")).show();
    } catch (err) {
        showToast("Failed to fetch customer details: " + err.message, "danger");
    }
};

window.saveCustomer = async function() {
    const id = document.getElementById("customerID").value;
    const payload = {
        CustomerCode: document.getElementById("customerCode").value,
        CustomerName: document.getElementById("customerName").value,
        Email: document.getElementById("customerEmail").value,
        PhoneNumber: document.getElementById("customerPhone").value,
        AddressLine1: document.getElementById("customerAddress").value,
        City: document.getElementById("customerCity").value,
        State: document.getElementById("customerState").value,
        Country: document.getElementById("customerCountry").value,
        PostalCode: document.getElementById("customerPostalCode").value,
        IsActive: document.getElementById("customerIsActive").value === "1"
    };
    try {
        if (id) {
            await api.put(`/customers/${id}`, payload);
            showToast("Customer updated successfully!", "success");
        } else {
            await api.post("/customers/", payload);
            showToast("Customer created successfully!", "success");
        }
        bootstrap.Modal.getInstance(document.getElementById("customerModal")).hide();
        await loadCustomers();
    } catch (err) {
        showToast("Error: " + err.message, "danger");
    }
};

window.deleteCustomer = async function(id) {
    if (!confirm("Delete this customer?")) return;
    try {
        await api.delete(`/customers/${id}`);
        showToast("Customer deleted successfully!", "success");
        loadCustomers();
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