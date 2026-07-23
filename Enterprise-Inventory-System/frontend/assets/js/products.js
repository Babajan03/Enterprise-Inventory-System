let productTable;

async function loadProducts() {
    if ($.fn.DataTable.isDataTable("#productTable")) {
        productTable.destroy();
    }
    const data = await api.get("/products/");
    productTable = $("#productTable").DataTable({
        data: data,
        responsive: true,
        columns: [
            { data: "ProductCode" },
            { data: "ProductName" },
            { data: "CategoryName" },
            { data: "BrandName" },
            {
                data: "SellingPrice",
                render: v => "₹ " + parseFloat(v).toFixed(2)
            },
            { data: "MinimumStock" },
            { data: "ReorderLevel" },
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
                        onclick="window.editProduct(${row.ProductID})">Edit</button>
                    <button class="btn btn-danger btn-sm ms-1"
                        onclick="window.deleteProduct(${row.ProductID})">Delete</button>
                `
            }
        ]
    });
}

window.openAddProduct = function() {
    document.getElementById("productModalTitle").textContent = "Add Product";
    document.getElementById("productID").value = "";
    document.getElementById("productCode").value = "";
    document.getElementById("productName").value = "";
    document.getElementById("productSKU").value = "";
    document.getElementById("productBarcode").value = "";
    document.getElementById("productHSN").value = "";
    document.getElementById("productDescription").value = "";
    document.getElementById("productCategory").value = "1";
    document.getElementById("productBrand").value = "1";
    document.getElementById("productUnit").value = "1";
    document.getElementById("productTax").value = "1";
    document.getElementById("productCurrency").value = "1";
    document.getElementById("productCostPrice").value = "";
    document.getElementById("productSellingPrice").value = "";
    document.getElementById("productMinStock").value = "";
    document.getElementById("productMaxStock").value = "";
    document.getElementById("productReorderLevel").value = "";
    new bootstrap.Modal(document.getElementById("productModal")).show();
};

window.editProduct = async function(id) {
    const p = await api.get(`/products/${id}`);
    document.getElementById("productModalTitle").textContent = "Edit Product";
    document.getElementById("productID").value = p.ProductID;
    document.getElementById("productCode").value = p.ProductCode;
    document.getElementById("productName").value = p.ProductName;
    document.getElementById("productSKU").value = p.SKU;
    document.getElementById("productBarcode").value = p.Barcode;
    document.getElementById("productHSN").value = p.HSNCode;
    document.getElementById("productDescription").value = p.ProductDescription;
    document.getElementById("productCategory").value = p.CategoryID;
    document.getElementById("productBrand").value = p.BrandID;
    document.getElementById("productUnit").value = p.UnitID;
    document.getElementById("productTax").value = p.TaxID;
    document.getElementById("productCurrency").value = p.CurrencyID;
    document.getElementById("productCostPrice").value = p.CostPrice;
    document.getElementById("productSellingPrice").value = p.SellingPrice;
    document.getElementById("productMinStock").value = p.MinimumStock;
    document.getElementById("productMaxStock").value = p.MaximumStock;
    document.getElementById("productReorderLevel").value = p.ReorderLevel;
    new bootstrap.Modal(document.getElementById("productModal")).show();
};

window.saveProduct = async function() {
    const id = document.getElementById("productID").value;
    const payload = {
        ProductCode: document.getElementById("productCode").value,
        ProductName: document.getElementById("productName").value,
        ProductDescription: document.getElementById("productDescription").value,
        SKU: document.getElementById("productSKU").value,
        Barcode: document.getElementById("productBarcode").value,
        HSNCode: document.getElementById("productHSN").value,
        CategoryID: parseInt(document.getElementById("productCategory").value),
        BrandID: parseInt(document.getElementById("productBrand").value),
        UnitID: parseInt(document.getElementById("productUnit").value),
        TaxID: parseInt(document.getElementById("productTax").value),
        CurrencyID: parseInt(document.getElementById("productCurrency").value),
        CostPrice: parseFloat(document.getElementById("productCostPrice").value),
        SellingPrice: parseFloat(document.getElementById("productSellingPrice").value),
        MinimumStock: parseInt(document.getElementById("productMinStock").value),
        MaximumStock: parseInt(document.getElementById("productMaxStock").value),
        ReorderLevel: parseInt(document.getElementById("productReorderLevel").value)
    };
    if (id) {
        await api.put(`/products/${id}`, payload);
    } else {
        await api.post("/products/", payload);
    }
    bootstrap.Modal.getInstance(document.getElementById("productModal")).hide();
    loadProducts();
};

window.deleteProduct = function(id) {
    document.getElementById("deleteProductID").value = id;
    new bootstrap.Modal(document.getElementById("deleteProductModal")).show();
};

window.confirmDeleteProduct = async function() {
    const id = document.getElementById("deleteProductID").value;
    await api.delete(`/products/${id}`);
    bootstrap.Modal.getInstance(document.getElementById("deleteProductModal")).hide();
    loadProducts();
};

window.openAddProduct = openAddProduct;
window.editProduct = editProduct;
window.deleteProduct = deleteProduct;
window.confirmDeleteProduct = confirmDeleteProduct;
window.saveProduct = saveProduct;