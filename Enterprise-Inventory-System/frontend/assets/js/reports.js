let reportTable;

async function loadReports() {
    // loads empty, user clicks button to choose report
}

window.showReport = async function(type) {
    if ($.fn.DataTable.isDataTable("#reportTable")) {
        $("#reportTable").DataTable().destroy();
        document.getElementById("reportHead").innerHTML = "";
        document.getElementById("reportBody").innerHTML = "";
    }

    const data = await api.get(`/reports/${type}`);
    let columns = [];
    let title = "";

    if (type === "inventory") {
        title = "Inventory Report";
        columns = [
            { data: "ProductCode", title: "Code" },
            { data: "ProductName", title: "Product" },
            { data: "WarehouseName", title: "Warehouse" },
            { data: "Quantity", title: "Quantity" },
            { data: "ReorderLevel", title: "Reorder Level" },
            {
                data: "StockStatus", title: "Status",
                render: v => v === "Low Stock"
                    ? `<span class="badge bg-danger">Low Stock</span>`
                    : `<span class="badge bg-success">OK</span>`
            }
        ];
    } else if (type === "sales") {
        title = "Sales Summary Report";
        columns = [
            { data: "CustomerName", title: "Customer" },
            { data: "TotalOrders", title: "Total Orders" },
            {
                data: "TotalRevenue", title: "Total Revenue",
                render: v => "₹ " + parseFloat(v || 0).toFixed(2)
            }
        ];
    } else if (type === "purchase") {
        title = "Purchase Summary Report";
        columns = [
            { data: "SupplierName", title: "Supplier" },
            { data: "TotalOrders", title: "Total Orders" },
            {
                data: "TotalSpend", title: "Total Spend",
                render: v => "₹ " + parseFloat(v || 0).toFixed(2)
            }
        ];
    }

    document.getElementById("reportTitle").textContent = title;
    reportTable = $("#reportTable").DataTable({
        data: data,
        columns: columns,
        responsive: true,
        destroy: true
    });
};

window.showReport = showReport;