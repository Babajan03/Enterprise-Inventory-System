let inventoryTable;

async function loadInventory() {
    if ($.fn.DataTable.isDataTable("#inventoryTable")) {
        inventoryTable.destroy();
    }
    const data = await api.get("/inventory/");
    inventoryTable = $("#inventoryTable").DataTable({
        data: data,
        responsive: true,
        columns: [
            { data: "ProductCode" },
            { data: "ProductName" },
            { data: "WarehouseName" },
            { data: "Quantity" },
            { data: "ReorderLevel" },
            {
                data: "LastUpdatedDate",
                render: v => v ? new Date(v).toLocaleDateString() : "-"
            },
            {
                data: null,
                render: row => `
                    <button class="btn btn-warning btn-sm"
                        onclick="openAdjust(${row.InventoryId}, '${row.ProductName}', ${row.Quantity})">
                        Adjust
                    </button>
                `
            }
        ]
    });
}

function openAdjust(id, productName, currentQty) {
    document.getElementById("adjustInventoryID").value = id;
    document.getElementById("adjustProductName").value = productName;
    document.getElementById("adjustQuantity").value = currentQty;
    document.getElementById("adjustRemarks").value = "";
    new bootstrap.Modal(document.getElementById("adjustModal")).show();
}

async function saveAdjustment() {
    const id = document.getElementById("adjustInventoryID").value;
    const payload = {
        Quantity: document.getElementById("adjustQuantity").value,
        Remarks: document.getElementById("adjustRemarks").value
    };
    await api.put(`/inventory/${id}/adjust`, payload);
    bootstrap.Modal.getInstance(document.getElementById("adjustModal")).hide();
    loadInventory();
}