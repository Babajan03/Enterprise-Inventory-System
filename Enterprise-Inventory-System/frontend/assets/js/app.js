const API_BASE = "http://127.0.0.1:5000";

async function loadComponent(id, file) {
    const html = await fetch(file).then(r => r.text());
    document.getElementById(id).innerHTML = html;
}

async function loadPage(page) {
    const html = await fetch(`pages/${page}.html`).then(r => r.text());
    document.getElementById("content").innerHTML = html;

    switch (page) {
        case "dashboard":
            loadDashboard();
            break;

        case "products":
            loadProducts();
            break;

        case "suppliers":
            loadSuppliers();
            break;

        case "customers":
            loadCustomers();
            break;

        case "inventory":
            loadInventory();
            break;

        case "warehouse":
            loadWarehouse();
            break;

        case "purchase":
            loadPurchase();
            break;

        case "sales":
            loadSales();
            break;

        case "reports":
            loadReports();
            break;
    }
}

window.onload = async () => {

    await loadComponent("sidebar", "components/sidebar.html");

    await loadComponent("navbar", "components/navbar.html");

    await loadPage("dashboard");

};