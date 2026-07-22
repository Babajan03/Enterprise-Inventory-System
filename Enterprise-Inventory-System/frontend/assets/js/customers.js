let customerTable;

async function loadCustomers() {
    if ($.fn.DataTable.isDataTable("#customerTable")) {
        customerTable.destroy();
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
                render: function (value) {
                    return value
                        ? `<span class="badge bg-success">Active</span>`
                        : `<span class="badge bg-danger">Inactive</span>`;
                }
            },
            {
                data: null,
                render: function (row) {
                    return `
                        <button class="btn btn-warning btn-sm"
                            onclick="editCustomer(${row.CustomerId})">Edit</button>
                        <button class="btn btn-danger btn-sm ms-1"
                            onclick="deleteCustomer(${row.CustomerId})">Delete</button>
                    `;
                }
            }
        ]
    });
}

function openAddCustomer() {
    document.getElementById("customerModalTitle").textContent = "Add Customer";
    document.getElementById("customerID").value = "";
    document.getElementById("customerCode").value = "";
    document.getElementById("customerName").value = "";
    document.getElementById("customerEmail").value = "";
    document.getElementById("customerPhone").value = "";
    document.getElementById("customerAddress").value = "";
    document.getElementById("customerCity").value = "";
    document.getElementById("customerState").value = "";
    document.getElementById("customerCountry").value = "";
    document.getElementById("customerPostalCode").value = "";
    document.getElementById("customerIsActive").value = "1";
    new bootstrap.Modal(document.getElementById("customerModal")).show();
}

async function editCustomer(id) {
    const customer = await api.get(`/customers/${id}`);
    document.getElementById("customerModalTitle").textContent = "Edit Customer";
    document.getElementById("customerID").value = customer.CustomerId;
    document.getElementById("customerCode").value = customer.CustomerCode;
    document.getElementById("customerName").value = customer.CustomerName;
    document.getElementById("customerEmail").value = customer.Email;
    document.getElementById("customerPhone").value = customer.PhoneNumber;
    document.getElementById("customerAddress").value = customer.AddressLine1;
    document.getElementById("customerCity").value = customer.City;
    document.getElementById("customerState").value = customer.State;
    document.getElementById("customerCountry").value = customer.Country;
    document.getElementById("customerPostalCode").value = customer.PostalCode;
    document.getElementById("customerIsActive").value = customer.IsActive ? "1" : "0";
    new bootstrap.Modal(document.getElementById("customerModal")).show();
}

async function saveCustomer() {
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
}

async function deleteCustomer(id) {
    if (!confirm("Are you sure you want to delete this customer?")) return;
    await api.delete(`/customers/${id}`);
    loadCustomers();
}