async function loadDashboard() {
    try {
        const data = await api.get("/dashboard/summary");
        document.getElementById("products").innerHTML = data.products || 0;
        document.getElementById("suppliers").innerHTML = data.suppliers || 0;
        document.getElementById("customers").innerHTML = data.customers || 0;
        document.getElementById("warehouses").innerHTML = data.warehouses || 0;
    } catch (err) {
        console.error("Dashboard load error:", err);
    }
}