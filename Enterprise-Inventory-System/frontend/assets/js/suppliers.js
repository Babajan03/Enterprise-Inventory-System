let supplierTable;

async function loadSuppliers() {
    if ($.fn.DataTable.isDataTable("#supplierTable")) {
        supplierTable.destroy();
    }

    const data = await api.get("/suppliers/");

    supplierTable = $("#supplierTable").DataTable({
        data: data,
        responsive: true,
        columns: [
            { data: "SupplierCode" },
            { data: "SupplierName" },
            { data: "ContactPerson" },
            { data: "Email" },
            { data: "Phone" },
            { data: "City" },
            { data: "GSTNumber" },
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
                            onclick="editSupplier(${row.SupplierID})">Edit</button>
                        <button class="btn btn-danger btn-sm ms-1"
                            onclick="deleteSupplier(${row.SupplierID})">Delete</button>
                    `;
                }
            }
        ]
    });
}

function openAddSupplier() {
    document.getElementById("supplierModalTitle").textContent = "Add Supplier";
    document.getElementById("supplierID").value = "";
    document.getElementById("supplierCode").value = "";
    document.getElementById("supplierName").value = "";
    document.getElementById("contactPerson").value = "";
    document.getElementById("supplierEmail").value = "";
    document.getElementById("supplierPhone").value = "";
    document.getElementById("gstNumber").value = "";
    document.getElementById("addressLine1").value = "";
    document.getElementById("city").value = "";
    document.getElementById("stateName").value = "";
    document.getElementById("countryName").value = "";
    document.getElementById("postalCode").value = "";
    document.getElementById("supplierIsActive").value = "1";
    new bootstrap.Modal(document.getElementById("supplierModal")).show();
}

async function editSupplier(id) {
    const supplier = await api.get(`/suppliers/${id}`);
    document.getElementById("supplierModalTitle").textContent = "Edit Supplier";
    document.getElementById("supplierID").value = supplier.SupplierID;
    document.getElementById("supplierCode").value = supplier.SupplierCode;
    document.getElementById("supplierName").value = supplier.SupplierName;
    document.getElementById("contactPerson").value = supplier.ContactPerson;
    document.getElementById("supplierEmail").value = supplier.Email;
    document.getElementById("supplierPhone").value = supplier.Phone;
    document.getElementById("gstNumber").value = supplier.GSTNumber;
    document.getElementById("addressLine1").value = supplier.AddressLine1;
    document.getElementById("city").value = supplier.City;
    document.getElementById("stateName").value = supplier.StateName;
    document.getElementById("countryName").value = supplier.CountryName;
    document.getElementById("postalCode").value = supplier.PostalCode;
    document.getElementById("supplierIsActive").value = supplier.IsActive ? "1" : "0";
    new bootstrap.Modal(document.getElementById("supplierModal")).show();
}

async function saveSupplier() {
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

    if (id) {
        await api.put(`/suppliers/${id}`, payload);
    } else {
        await api.post("/suppliers/", payload);
    }

    bootstrap.Modal.getInstance(document.getElementById("supplierModal")).hide();
    loadSuppliers();
}

async function deleteSupplier(id) {
    if (!confirm("Are you sure you want to delete this supplier?")) return;
    await api.delete(`/suppliers/${id}`);
    loadSuppliers();
}