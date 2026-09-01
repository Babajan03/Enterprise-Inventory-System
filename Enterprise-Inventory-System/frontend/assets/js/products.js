let productTable = null;

async function loadProducts() {
    try {
        const data = await api.get("/products/");
        const columns = [
            { data: "ProductCode" },
            { data: "ProductName" },
            { data: "CategoryName" },
            { data: "BrandName" },
            {
                data: "SellingPrice",
                render: v => "₹ " + parseFloat(v || 0).toFixed(2)
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
                orderable: false,
                render: row => `
                    <button class="btn btn-dark btn-sm me-1" title="Generate Barcode"
                        onclick="window.openBarcodeModal('${row.ProductCode}', '${row.ProductName}')">
                        <i class="bi bi-upc-scan"></i>
                    </button>
                    <button class="btn btn-warning btn-sm"
                        onclick="window.editProduct(${row.ProductID})">Edit</button>
                    <button class="btn btn-danger btn-sm ms-1"
                        onclick="window.deleteProduct(${row.ProductID})">Delete</button>
                `
            }
        ];
        productTable = updateOrInitDataTable("#productTable", productTable, data, columns, {
            buttons: getDTExportButtons("Products List", "products")
        });
    } catch (err) {
        showToast("Failed to load products: " + err.message, "danger");
    }
}

window.openAddProduct = function() {
    document.getElementById("productModalTitle").textContent = "Add Product";
    document.getElementById("productID").value = "";
    document.getElementById("productCode").value = "PROD-" + Date.now().toString().slice(-6);
    document.getElementById("productCode").readOnly = false;
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
    document.getElementById("productMinStock").value = "5";
    document.getElementById("productMaxStock").value = "100";
    document.getElementById("productReorderLevel").value = "10";
    new bootstrap.Modal(document.getElementById("productModal")).show();
};

window.editProduct = async function(id) {
    try {
        const p = await api.get(`/products/${id}`);
        document.getElementById("productModalTitle").textContent = "Edit Product";
        document.getElementById("productID").value = p.ProductID;
        document.getElementById("productCode").value = p.ProductCode || "";
        document.getElementById("productCode").readOnly = true;
        document.getElementById("productName").value = p.ProductName || "";
        document.getElementById("productSKU").value = p.SKU || "";
        document.getElementById("productBarcode").value = p.Barcode || "";
        document.getElementById("productHSN").value = p.HSNCode || "";
        document.getElementById("productDescription").value = p.ProductDescription || "";
        document.getElementById("productCategory").value = p.CategoryID || "1";
        document.getElementById("productBrand").value = p.BrandID || "1";
        document.getElementById("productUnit").value = p.UnitID || "1";
        document.getElementById("productTax").value = p.TaxID || "1";
        document.getElementById("productCurrency").value = p.CurrencyID || "1";
        document.getElementById("productCostPrice").value = p.CostPrice || 0;
        document.getElementById("productSellingPrice").value = p.SellingPrice || 0;
        document.getElementById("productMinStock").value = p.MinimumStock || 0;
        document.getElementById("productMaxStock").value = p.MaximumStock || 0;
        document.getElementById("productReorderLevel").value = p.ReorderLevel || 0;
        new bootstrap.Modal(document.getElementById("productModal")).show();
    } catch (err) {
        showToast("Failed to fetch product details: " + err.message, "danger");
    }
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
        CostPrice: parseFloat(document.getElementById("productCostPrice").value || 0),
        SellingPrice: parseFloat(document.getElementById("productSellingPrice").value || 0),
        MinimumStock: parseInt(document.getElementById("productMinStock").value || 0),
        MaximumStock: parseInt(document.getElementById("productMaxStock").value || 0),
        ReorderLevel: parseInt(document.getElementById("productReorderLevel").value || 0)
    };
    try {
        if (id) {
            await api.put(`/products/${id}`, payload);
            showToast("Product updated successfully!", "success");
        } else {
            await api.post("/products/", payload);
            showToast("Product created successfully!", "success");
        }
        bootstrap.Modal.getInstance(document.getElementById("productModal")).hide();
        await loadProducts();
    } catch (err) {
        showToast("Error: " + err.message, "danger");
    }
};

window.deleteProduct = function(id) {
    document.getElementById("deleteProductID").value = id;
    new bootstrap.Modal(document.getElementById("deleteProductModal")).show();
};

window.confirmDeleteProduct = async function() {
    const id = document.getElementById("deleteProductID").value;
    try {
        await api.delete(`/products/${id}`);
        bootstrap.Modal.getInstance(document.getElementById("deleteProductModal")).hide();
        showToast("Product deleted successfully!", "success");
        loadProducts();
    } catch (err) {
        showToast("Error: " + err.message, "danger");
    }
};

// Barcode & QR Code Logic
window.openBarcodeModal = function(productCode, productName) {
    document.getElementById("barcodeProductName").textContent = productName;
    
    JsBarcode("#barcodeSvg", productCode, {
        format: "CODE128",
        lineColor: "#000",
        width: 2,
        height: 60,
        displayValue: true
    });
    
    const qrcodeDiv = document.getElementById("qrcodeDiv");
    qrcodeDiv.innerHTML = "";
    new QRCode(qrcodeDiv, {
        text: productCode,
        width: 128,
        height: 128,
        colorDark : "#000000",
        colorLight : "#ffffff",
        correctLevel : QRCode.CorrectLevel.H
    });

    new bootstrap.Modal(document.getElementById("barcodeModal")).show();
};

window.printBarcode = function() {
    const printContent = document.getElementById("printableLabels").innerHTML;
    const originalContent = document.body.innerHTML;
    
    document.body.innerHTML = `
        <div style="text-align: center; margin-top: 50px;">
            ${printContent}
        </div>
    `;
    
    window.print();
    document.body.innerHTML = originalContent;
    window.location.reload();
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