async function loadDashboard() {

    const response = await fetch(API_BASE + "/dashboard/summary");

    const data = await response.json();

    document.getElementById("products").innerHTML = data.products;

    document.getElementById("suppliers").innerHTML = data.suppliers;

    document.getElementById("customers").innerHTML = data.customers;

    document.getElementById("warehouses").innerHTML = data.warehouses;

}