let customerTable;

async function loadCustomers() {
    if ($.fn.DataTable.isDataTable("#customerTable")) {
        $("#customerTable").DataTable().destroy();
    }
    const data = await api.get("/customers/");
    customerTable = $("#customerTable").DataTable({
        data: data,
        responsive: true,
        columns: [
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
                render: row => `
                    <button class="btn btn-warning btn-sm"
                        onclick="window.editCustomer(${row.CustomerId})">Edit</button>
                    <button class="btn btn-danger btn-sm ms-1"
                        onclick="window.deleteCustomer(${row.CustomerId})">Delete</button>
                `
            }
        ]
    });
}

window.openAddCustomer = function() {
    document.getElementById("customerModalTitle").textContent = "Add Customer";
    ["customerID","customerCode","customerName","customerEmail",
     "customerPhone","customerAddress","customerCity","customerState",
     "customerCountry","customerPostalCode"].forEach(id => {
        document.getElementById(id).value = "";
    });
    document.getElementById("customerIsActive").value = "1";
    new bootstrap.Modal(document.getElementById("customerModal")).show();
};

window.editCustomer = async function(id) {
    const c = await api.get(`/customers/${id}`);
    document.getElementById("customerModalTitle").textContent = "Edit Customer";
    document.getElementById("customerID").value = c.CustomerId;
    document.getElementById("customerCode").value = c.CustomerCode;
    document.getElementById("customerName").value = c.CustomerName;
    document.getElementById("customerEmail").value = c.Email;
    document.getElementById("customerPhone").value = c.PhoneNumber;
    document.getElementById("customerAddress").value = c.AddressLine1;
    document.getElementById("customerCity").value = c.City;
    document.getElementById("customerState").value = c.State;
    document.getElementById("customerCountry").value = c.Country;
    document.getElementById("customerPostalCode").value = c.PostalCode;
    document.getElementById("customerIsActive").value = c.IsActive ? "1" : "0";
    new bootstrap.Modal(document.getElementById("customerModal")).show();
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
    if (id) {
        await api.put(`/customers/${id}`, payload);
    } else {
        await api.post("/customers/", payload);
    }
    bootstrap.Modal.getInstance(document.getElementById("customerModal")).hide();
    loadCustomers();
};

window.deleteCustomer = async function(id) {
    if (!confirm("Delete this customer?")) return;
    await api.delete(`/customers/${id}`);
    loadCustomers();
};


window.openAddCustomer = openAddCustomer;
window.editCustomer = editCustomer;
window.deleteCustomer = deleteCustomer;
window.saveCustomer = saveCustomer;