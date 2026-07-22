let warehouseTable;

async function loadWarehouse() {
    await new Promise(r => setTimeout(r, 50));
    if ($.fn.DataTable.isDataTable("#warehouseTable")) {
        warehouseTable.destroy();
    }
    const data = await api.get("/warehouse/");
    warehouseTable = $("#warehouseTable").DataTable({
        data: data,
        responsive: true,
        columns: [
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
                render: row => `
                    <button class="btn btn-warning btn-sm"
                        onclick="editWarehouse(${row.WarehouseId})">Edit</button>
                    <button class="btn btn-danger btn-sm ms-1"
                        onclick="deleteWarehouse(${row.WarehouseId})">Delete</button>
                `
            }
        ]
    });
}

function openAddWarehouse() {
    document.getElementById("warehouseModalTitle").textContent = "Add Warehouse";
    ["warehouseID","warehouseCode","warehouseName","warehouseAddress",
     "warehouseCity","warehouseState","warehouseCountry","warehousePostalCode",
     "warehouseContactPerson","warehouseContactNumber"].forEach(id => {
        document.getElementById(id).value = "";
    });
    document.getElementById("warehouseIsActive").value = "1";
    new bootstrap.Modal(document.getElementById("warehouseModal")).show();
}

async function editWarehouse(id) {
    const w = await api.get(`/warehouse/${id}`);
    document.getElementById("warehouseModalTitle").textContent = "Edit Warehouse";
    document.getElementById("warehouseID").value = w.WarehouseId;
    document.getElementById("warehouseCode").value = w.WarehouseCode;
    document.getElementById("warehouseName").value = w.WarehouseName;
    document.getElementById("warehouseAddress").value = w.AddressLine1;
    document.getElementById("warehouseCity").value = w.City;
    document.getElementById("warehouseState").value = w.State;
    document.getElementById("warehouseCountry").value = w.Country;
    document.getElementById("warehousePostalCode").value = w.PostalCode;
    document.getElementById("warehouseContactPerson").value = w.ContactPerson;
    document.getElementById("warehouseContactNumber").value = w.ContactNumber;
    document.getElementById("warehouseIsActive").value = w.IsActive ? "1" : "0";
    new bootstrap.Modal(document.getElementById("warehouseModal")).show();
}

async function saveWarehouse() {
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
    if (id) {
        await api.put(`/warehouse/${id}`, payload);
    } else {
        await api.post("/warehouse/", payload);
    }
    bootstrap.Modal.getInstance(document.getElementById("warehouseModal")).hide();
    loadWarehouse();
}

async function deleteWarehouse(id) {
    if (!confirm("Delete this warehouse?")) return;
    await api.delete(`/warehouse/${id}`);
    loadWarehouse();
}