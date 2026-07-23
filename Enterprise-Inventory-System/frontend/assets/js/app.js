async function loadComponent(id, file) {
    const html = await fetch(file).then(r => r.text());
    document.getElementById(id).innerHTML = html;
}

function showLoader() {
    const loader = document.getElementById("pageLoader");
    if (loader) loader.style.display = "flex";
}

function hideLoader() {
    const loader = document.getElementById("pageLoader");
    if (loader) loader.style.display = "none";
}

async function loadPage(page) {
    showLoader();

    $.fn.DataTable.tables({ visible: true, api: true }).destroy();

    const html = await fetch(`pages/${page}.html`).then(r => r.text());
    document.getElementById("content").innerHTML = html;

    document.querySelectorAll(".nav-item").forEach(el => el.classList.remove("active"));
    const active = document.querySelector(`.nav-item[onclick="loadPage('${page}')"]`);
    if (active) active.classList.add("active");

    requestAnimationFrame(() => {
        requestAnimationFrame(() => {
            switch (page) {
                case "dashboard":   loadDashboard();   break;
                case "products":    loadProducts();    break;
                case "suppliers":   loadSuppliers();   break;
                case "customers":   loadCustomers();   break;
                case "inventory":   loadInventory();   break;
                case "warehouse":   loadWarehouse();   break;
                case "purchase":    loadPurchase();    break;
                case "sales":       loadSales();       break;
                case "reports":     loadReports();     break;
            }
            hideLoader();
        });
    });
}

window.onload = async () => {
    await loadComponent("sidebar", "components/sidebar.html");
    await loadComponent("navbar", "components/navbar.html");
    await loadComponent("footer", "components/footer.html");
    await loadComponent("loader", "components/loader.html");
    initNavbar();
    await loadPage("dashboard");
};