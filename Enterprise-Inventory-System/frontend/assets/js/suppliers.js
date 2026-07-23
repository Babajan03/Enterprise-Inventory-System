let supplierTable;

async function loadSuppliers() {
    if ($.fn.DataTable.isDataTable("#supplierTable")) {
        $("#supplierTable").DataTable().destroy();
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
                render: v => v
                    ? `<span class="badge bg-success">Active</span>`
                    : `<span class="badge bg-danger">Inactive</span>`
            },
            {
                data: null,
                render: row => `
                    <button class="btn btn-warning btn-sm"
                        onclick="window.editSupplier(${row.SupplierID})">Edit</button>
                    <button class="btn btn-danger btn-sm ms-1"
                        onclick="window.deleteSupplier(${row.SupplierID})">Delete</button>
                `
            }
        ]
    });
}

window.openAddSupplier = function() {
    document.getElementById("supplierModalTitle").textContent = "Add Supplier";
    ["supplierID","supplierCode","supplierName","contactPerson",
     "supplierEmail","supplierPhone","gstNumber","addressLine1",
     "city","stateName","countryName","postalCode"].forEach(id => {
        document.getElementById(id).value = "";
    });
    document.getElementById("supplierIsActive").value = "1";
    new bootstrap.Modal(document.getElementById("supplierModal")).show();
};

window.editSupplier = async function(id) {
    const s = await api.get(`/suppliers/${id}`);
    document.getElementById("supplierModalTitle").textContent = "Edit Supplier";
    document.getElementById("supplierID").value = s.SupplierID;
    document.getElementById("supplierCode").value = s.SupplierCode;
    document.getElementById("supplierName").value = s.SupplierName;
    document.getElementById("contactPerson").value = s.ContactPerson;
    document.getElementById("supplierEmail").value = s.Email;
    document.getElementById("supplierPhone").value = s.Phone;
    document.getElementById("gstNumber").value = s.GSTNumber;
    document.getElementById("addressLine1").value = s.AddressLine1;
    document.getElementById("city").value = s.City;
    document.getElementById("stateName").value = s.StateName;
    document.getElementById("countryName").value = s.CountryName;
    document.getElementById("postalCode").value = s.PostalCode;
    document.getElementById("supplierIsActive").value = s.IsActive ? "1" : "0";
    new bootstrap.Modal(document.getElementById("supplierModal")).show();
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
    if (id) {
        await api.put(`/suppliers/${id}`, payload);
    } else {
        await api.post("/suppliers/", payload);
    }
    bootstrap.Modal.getInstance(document.getElementById("supplierModal")).hide();
    loadSuppliers();
};

window.deleteSupplier = async function(id) {
    if (!confirm("Delete this supplier?")) return;
    await api.delete(`/suppliers/${id}`);
    loadSuppliers();
};


window.openAddSupplier = openAddSupplier;
window.editSupplier = editSupplier;
window.deleteSupplier = deleteSupplier;
window.saveSupplier = saveSupplier;